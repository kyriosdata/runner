# Sprint 1 — Tarefas Operacionais

## Decisões Técnicas

Registradas aqui para rastreabilidade. Foram tomadas como pré-condição da sprint.

| # | Decisão | Valor |
|---|---------|-------|
| DT-01 | Módulo Go | `github.com/kyriosdata/runner` |
| DT-02 | Branch principal | `main` |
| DT-03 | Plataformas-alvo | `windows/amd64`, `linux/amd64`, `darwin/amd64` |
| DT-04 | Convenção de nome dos artefatos | `assinatura-<versão>-<os>-<arch>` (ex.: `assinatura-v0.1.0-linux-amd64`) |
| DT-05 | Checksums | SHA256 gerado para cada binário e publicado junto ao release |
| DT-06 | Layout de pacotes | Ver seção abaixo |

### DT-06 — Layout de pacotes

```
runner/
├── cmd/
│   ├── assinatura/        ← binário principal (Sprint 1)
│   │   └── main.go
│   └── simulador/         ← stub vazio (binário da Sprint 4)
│       └── main.go
├── internal/
│   ├── cli/               ← parsing de comandos (cobra)
│   ├── invoker/           ← invocação do assinador.jar (local e HTTP)
│   ├── jdk/               ← detecção e provisionamento do JDK
│   └── release/           ← download de artefatos (simulador.jar, JDK)
├── assinador/             ← projeto Java/Maven (Sprint 2)
│   ├── pom.xml
│   └── src/
├── go.mod
└── go.sum
```

Justificativa: dois binários em `cmd/` compartilham os pacotes de `internal/`. O projeto Java vive no mesmo repositório para CI unificada.

---

## US-01.1 — Estrutura base do CLI em Go

### T-01.1.0 — Instalar Go 1.25

- Baixar o instalador de [https://go.dev/dl/](https://go.dev/dl/) para a plataforma de desenvolvimento
- Instalar e verificar com `go version` — saída esperada: `go version go1.25 <os>/<arch>`
- Confirmar que `GOPATH` e `GOROOT` estão configurados corretamente
- Garantir que o binário `go` está no `PATH` (necessário para todas as tarefas seguintes)

### T-01.1.1 — Inicializar repositório e módulo Go

- Garantir que a branch padrão do repositório GitHub seja `main` (DT-02)
- Executar `go mod init github.com/kyriosdata/runner` na raiz (DT-01)
- Confirmar que `go.mod` foi gerado corretamente

### T-01.1.2 — Criar estrutura de diretórios

- Criar os diretórios conforme DT-06
- Criar arquivos `.gitkeep` nos diretórios `internal/*` ainda vazios para preservá-los no Git
- Criar `assinador/` com `.gitkeep` (será populado na Sprint 2)

### T-01.1.3 — Implementar comando `assinatura version`

- Criar `cmd/assinatura/main.go` com CLI mínima usando a biblioteca [cobra](https://github.com/spf13/cobra)
- Adicionar `cobra` como dependência: `go get github.com/spf13/cobra`
- Declarar a versão como **variável** (não constante): `var version = "dev"` — obrigatório para que `-ldflags` consiga sobrescrever o valor em tempo de build; se declarada como `const`, o linker ignora silenciosamente a injeção
- Implementar subcomando `version` que imprime o valor de `version`
- A versão é injetada pela pipeline CI via `-ldflags "-X main.version=<tag>"`; localmente exibe `dev`

### T-01.1.4 — Criar stub do binário `simulador`

- Criar `cmd/simulador/main.go` com `main()` minimalista que imprime `"simulador v<versão> — em construção"`
- Não é necessário lógica funcional; o objetivo é garantir que o repositório compile dois binários desde o início

### T-01.1.5 — Verificar compilação local

- Executar `go build ./...` e confirmar que não há erros
- Executar `go vet ./...` e corrigir eventuais warnings

### T-01.1.6 — Teste de aceitação do comando `version`

- Criar `cmd/assinatura/version_test.go` com um teste de integração que:
  1. Usa `os/exec` para executar `go run . version` a partir do diretório `cmd/assinatura`
  2. Verifica que a saída contém a string `"dev"` (valor padrão da variável `version` sem injeção de ldflags)
- Usar `go run` em vez de compilar binário temporário: mais simples, sem necessidade de gerenciar arquivo temporário ou extensão `.exe` por plataforma
- Executar com `go test ./cmd/assinatura/...` e confirmar que passa

---

## US-05.1 — Pipeline CI/CD multiplataforma

### T-05.1.1 — Criar workflow de build

- Criar `.github/workflows/build.yml`
- Trigger: `push` e `pull_request` restritos à branch `main` (`branches: [main]`) — sem essa restrição, o workflow também dispararia ao criar tags `v*`, colidindo com `release.yml`
- Usar `actions/checkout@v4` e `actions/setup-go@v5` com `go-version: '1.25'`

### T-05.1.2 — Configurar job de testes multiplataforma

O teste de aceitação (T-01.1.6) executa o binário real via `os/exec`, exigindo runner nativo de cada plataforma. Estruturar um job `test` separado do job de build:

- Definir matrix de runners: `ubuntu-latest`, `windows-latest`, `macos-latest`
- Para cada runner, executar em sequência:
  1. `go vet ./...`
  2. `go test ./...` (inclui o teste de aceitação do comando `version`)
- Este job não gera artefatos; seu único objetivo é garantir que o código passa em todas as plataformas

### T-05.1.3 — Configurar job de cross-compilation

Job separado do de testes, responsável pelos artefatos distribuíveis:

- Roda em um único runner (`ubuntu-latest`)
- Depende do job `test` (`needs: test`) — só executa se todos os testes passarem
- Para cada plataforma de DT-03, executar:
  ```
  GOOS=<os> GOARCH=<arch> go build -o dist/assinatura-<os>-<arch> ./cmd/assinatura
  ```
- Para Windows, o binário deve ter extensão `.exe`

### T-05.1.4 — Publicar artefatos do workflow

- Usar `actions/upload-artifact@v4` para disponibilizar os binários como artifacts de cada execução
- Um único artifact por plataforma, nomeado conforme DT-04 (sem versão no nome do artifact; versão vai no release)

---

## US-05.2 — Publicação de releases com versionamento semântico

### T-05.2.1 — Criar workflow de release

- Criar `.github/workflows/release.yml`
- Trigger: `push` de tags no padrão `v*` (ex.: `v0.1.0`)
- O workflow tem três jobs em sequência: `test` → `build` → `publish`

### T-05.2.2 — Job `test`: testes de aceitação nas 3 plataformas

- Reutilizar a mesma estrutura do job `test` de `build.yml` (matrix: `ubuntu-latest`, `windows-latest`, `macos-latest`)
- Executar `go vet ./...` e `go test ./...` em cada runner
- O release só avança se todos os testes passarem nas 3 plataformas (`needs: test`)

### T-05.2.3 — Job `build`: gerar binários com versão injetada

- Depende do job `test` (`needs: test`)
- Roda em `ubuntu-latest`
- Extrair a versão da tag via `${{ github.ref_name }}` (ex.: `v0.1.0`)
- Para cada plataforma de DT-03, compilar com `-ldflags "-X main.version=<tag>"`
- Nomear binários conforme DT-04: `assinatura-<tag>-<os>-<arch>[.exe]`
- Gerar `checksums.txt` com SHA256 de cada binário no formato:
  ```
  <hash>  assinatura-v0.1.0-linux-amd64
  <hash>  assinatura-v0.1.0-windows-amd64.exe
  ...
  ```
- Usar `actions/upload-artifact@v4` para publicar os binários e `checksums.txt` como artifact — necessário para o job `publish` acessá-los, pois jobs rodam em VMs separadas

### T-05.2.4 — Job `publish`: publicar no GitHub Releases

- Depende do job `build` (`needs: build`)
- Usar `actions/download-artifact@v4` para baixar os binários e `checksums.txt` gerados pelo job `build`
- Usar `softprops/action-gh-release@v2` para criar o release automaticamente
- Anexar todos os binários e `checksums.txt` ao release (DT-05)
- Usar o corpo da tag como descrição do release (release notes)
- Requer permissão `contents: write` no workflow

### T-05.2.5 — Validar o fluxo completo

- Criar tag `v0.1.0` no repositório
- Confirmar que os três jobs (`test` → `build` → `publish`) executam com sucesso
- Confirmar que os artefatos estão disponíveis no GitHub Releases com `checksums.txt`

---

## Definição de Pronto (DoD) da Sprint 1

- [ ] `go build ./...` passa sem erros localmente
- [ ] `go vet ./...` passa sem warnings
- [ ] `assinatura version` exibe a versão correta
- [ ] Workflow de build (`build.yml`) executa com sucesso em push para `main`
- [ ] Binários para as 3 plataformas (DT-03) são gerados como artifacts
- [ ] Workflow de release (`release.yml`) executa ao criar uma tag `v*`
- [ ] Release `v0.1.0` publicado no GitHub com binários e `checksums.txt`
