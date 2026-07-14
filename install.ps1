# Copyright (c) 2026 SES-GO / UFG
# Todos os direitos reservados.

<#
.SYNOPSIS
  Instalador do hubsaude-cli para Windows.

.DESCRIPTION
  Baixa o binário mais recente publicado nas GitHub Releases do repositório
  público de distribuição, verifica o checksum SHA-256 e o instala em um
  diretório do usuário, adicionando-o ao PATH (escopo de usuário).

  Uso rápido (PowerShell):
    irm https://raw.githubusercontent.com/kyriosdata/runner/main/install.ps1 | iex

  Uso local:
    .\install.ps1 [-Version <X.Y.Z>] [-BinDir <DIR>] [-Help]

.PARAMETER Version
  Versão a instalar (padrão: a mais recente). Aceita "0.2.2", "v0.2.2" ou
  "hubsaude-cli-v0.2.2".

.PARAMETER BinDir
  Diretório de instalação (padrão: %LOCALAPPDATA%\Programs\hubsaude).

.NOTES
  Variáveis de ambiente opcionais: HUBSAUDE_CLI_REPO, HUBSAUDE_CLI_VERSION,
  HUBSAUDE_CLI_BIN_DIR, GITHUB_TOKEN (apenas para elevar o rate limit da API).
#>
#requires -version 5.1
[CmdletBinding()]
param(
  [string]$Version = $env:HUBSAUDE_CLI_VERSION,
  [Alias('bin-dir')]
  [string]$BinDir  = $env:HUBSAUDE_CLI_BIN_DIR,
  [switch]$Help
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'  # acelera Invoke-WebRequest

# TLS 1.2 para Windows PowerShell 5.1 (Core já usa padrões modernos)
try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch {}

$Repo      = if ($env:HUBSAUDE_CLI_REPO)     { $env:HUBSAUDE_CLI_REPO }     else { 'kyriosdata/runner' }
$ApiBase   = if ($env:GITHUB_API_URL)        { $env:GITHUB_API_URL }        else { 'https://api.github.com' }
$DlBase    = if ($env:GITHUB_DOWNLOAD_URL)   { $env:GITHUB_DOWNLOAD_URL }   else { 'https://github.com' }
$TagPrefix = 'hubsaude-cli-v'
$BinName   = 'hubsaude.exe'

function Write-Info($m) { [Console]::Error.WriteLine("[i] $m") }
function Write-Ok($m)   { [Console]::Error.WriteLine("[ok] $m") }
function Write-Warn($m) { [Console]::Error.WriteLine("[!] $m") }
function Die($m)        { [Console]::Error.WriteLine("[x] $m"); exit 1 }

if ($Help) {
  @"
Instalador do hubsaude-cli (Windows).

USO:
  .\install.ps1 [-Version <X.Y.Z>] [-BinDir <DIR>] [-Help]
  irm https://raw.githubusercontent.com/$Repo/main/install.ps1 | iex

PARÂMETROS:
  -Version <X.Y.Z>   Instala uma versão específica (padrão: a mais recente).
  -BinDir  <DIR>     Diretório de instalação (padrão: %LOCALAPPDATA%\Programs\hubsaude).
  -Help              Exibe esta ajuda.

VARIÁVEIS DE AMBIENTE:
  HUBSAUDE_CLI_REPO, HUBSAUDE_CLI_VERSION, HUBSAUDE_CLI_BIN_DIR, GITHUB_TOKEN
"@ | Write-Host
  exit 0
}

# ----------------------------------------------------------------------------
# Detecção de arquitetura
# ----------------------------------------------------------------------------
$archRaw = $env:PROCESSOR_ARCHITECTURE
switch ($archRaw) {
  'AMD64' { $arch = 'amd64' }
  'ARM64' { $arch = 'arm64' }
  'x86'   { Die 'Windows 32-bit (x86) não é suportado.' }
  default { Die "arquitetura não suportada: $archRaw" }
}
$asset = "hubsaude-windows-$arch.exe"
Write-Info "Plataforma detectada: windows/$arch (binário: $asset)"

# Cabeçalhos HTTP (autenticação opcional, apenas para rate limit)
$headers = @{ 'User-Agent' = 'hubsaude-cli-installer' }
if ($env:GITHUB_TOKEN) { $headers['Authorization'] = "Bearer $($env:GITHUB_TOKEN)" }

# ----------------------------------------------------------------------------
# Resolução da versão / tag
# ----------------------------------------------------------------------------
if ($Version) {
  if     ($Version.StartsWith($TagPrefix)) { $tag = $Version }
  elseif ($Version.StartsWith('v'))        { $tag = "$TagPrefix$($Version.Substring(1))" }
  else                                     { $tag = "$TagPrefix$Version" }
  Write-Info "Versão fixada: $tag"
}
else {
  Write-Info "Descobrindo a versão mais recente do CLI em $Repo..."
  # O repositório de distribuição hospeda releases de vários componentes;
  # filtramos estritamente pelo prefixo do CLI e tomamos a mais recente.
  $releases = Invoke-RestMethod -Headers $headers -Uri "$ApiBase/repos/$Repo/releases?per_page=100"
  $match = $releases | Where-Object { $_.tag_name -like "$TagPrefix*" } | Select-Object -First 1
  if (-not $match) { Die "nenhuma release '$TagPrefix*' encontrada em $Repo. Informe -Version." }
  $tag = $match.tag_name
}
$resolvedVersion = $tag.Substring($TagPrefix.Length)
Write-Ok "Versão alvo: $resolvedVersion (tag $tag)"

# ----------------------------------------------------------------------------
# Download
# ----------------------------------------------------------------------------
if (-not $BinDir) { $BinDir = Join-Path $env:LOCALAPPDATA 'Programs\hubsaude' }
$base = "$DlBase/$Repo/releases/download/$tag"
$tmp  = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

try {
  Write-Info "Baixando $asset..."
  Invoke-WebRequest -Headers $headers -Uri "$base/$asset" -OutFile (Join-Path $tmp $asset)
  Write-Info "Baixando checksums.txt..."
  Invoke-WebRequest -Headers $headers -Uri "$base/checksums.txt" -OutFile (Join-Path $tmp 'checksums.txt')

  # --------------------------------------------------------------------------
  # Verificação de integridade
  # --------------------------------------------------------------------------
  Write-Info "Verificando integridade (SHA-256)..."
  # Formato de cada linha: "<sha256>␠␠[*]<arquivo>" (modo texto/binário do sha256sum).
  $expected = $null
  foreach ($l in Get-Content (Join-Path $tmp 'checksums.txt')) {
    if ($l -match '^([0-9a-fA-F]{64})\s+\*?(.+)$' -and $matches[2].Trim() -eq $asset) {
      $expected = $matches[1].ToLower(); break
    }
  }
  if (-not $expected) { Die "checksum de $asset ausente em checksums.txt" }
  $actual = (Get-FileHash -Algorithm SHA256 -Path (Join-Path $tmp $asset)).Hash.ToLower()
  if ($expected -ne $actual) {
    Die "checksum NÃO confere para ${asset}:`n       esperado: $expected`n       obtido:   $actual"
  }
  Write-Ok "Checksum verificado: $actual"

  # --------------------------------------------------------------------------
  # Instalação
  # --------------------------------------------------------------------------
  New-Item -ItemType Directory -Force -Path $BinDir | Out-Null
  $dest = Join-Path $BinDir $BinName
  Copy-Item -Force -Path (Join-Path $tmp $asset) -Destination $dest
  Write-Ok "Instalado: $dest"
}
finally {
  Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}

# ----------------------------------------------------------------------------
# PATH (escopo de usuário, persistente)
# ----------------------------------------------------------------------------
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (-not $userPath) { $userPath = '' }
if (($userPath -split ';') -notcontains $BinDir) {
  $newPath = ($userPath.TrimEnd(';') + ';' + $BinDir).TrimStart(';')
  [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
  Write-Warn "$BinDir foi adicionado ao PATH do usuário. Reabra o terminal para usar 'hubsaude'."
}

# ----------------------------------------------------------------------------
# Verificação final (não fatal)
# ----------------------------------------------------------------------------
# Observação: a invocação de um .exe NÃO lança exceção em exit-code != 0
# (apenas falhas de execução, ex.: arquivo ausente). Por isso inspecionamos
# $LASTEXITCODE explicitamente, além do try/catch.
try {
  & (Join-Path $BinDir $BinName) version *> $null
  if ($LASTEXITCODE -eq 0) {
    Write-Ok "hubsaude $resolvedVersion instalado com sucesso. Experimente: hubsaude --help"
  } else {
    Write-Warn "Binário instalado em $dest, mas 'hubsaude version' retornou código $LASTEXITCODE."
  }
}
catch {
  Write-Warn "Binário instalado em $dest, mas a verificação de execução falhou: $($_.Exception.Message)"
}
