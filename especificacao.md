# Sistema Runner - Trabalho Prático

## 1. Visão geral

Este documento define o trabalho prático da disciplina de Implementação e Integração do Bacharelado em Engenharia de Software (2026). O trabalho visa proporcionar aos estudantes a oportunidade de prática de construção de software por meio do desenvolvimento do *Sistema Runner* útil para integradores da Plataforma HubSaúde.

Em tempo, este trabalho prático proposto é de interesse real da Secretaria de Estado de Saúde de Goiás (SES) e da Universidade Federal de Goiás (UFG), que realizam um esforço conjunto na definição e implementação da plataforma HubSaúde de interoperabilidade de dados em saúde.

## 2. Objetivo do Sistema Runner

Facilitar o acesso à funcionalidade de execução de aplicações Java via linha de comandos. 

## 3. Objetivos específicos

1. Permitir que os usuários possam executar aplicações Java sem necessidade de conhecer detalhes de configuração ou instalação do ambiente Java. Em particular, as aplicações que fazem parte do Sistema Runner. 

2. Fornecer uma interface de linha de comandos (CLI) simples e intuitiva para interação com as aplicações Java, permitindo que os usuários possam executar comandos específicos para cada aplicação. Desta forma, ocultando a complexidade de configuração ou facilitando o acesso às funcionalidades sem necessidade de conhecimento técnico aprofundado.


## 4. Escopo 

### 4.1. O que ESTÁ no Escopo

- ✅ Desenvolvimento da aplicação assinatura (CLI multiplataforma)
- ✅ Desenvolvimento da aplicação assinador.jar (Java)
- ✅ Integração entre as duas aplicações
- ✅ Validação rigorosa de parâmetros pelo assinador.jar
- ✅ Simulação de criação de assinatura (assinador.jar)
- ✅ Simulação de validação de assinatura (assinador.jar)
- ✅ Tratamento de erros dos parâmetros e exceções (assinador.jar)
- ✅ Desenvolvimento da aplicação simulador (CLI multiplataforma)
- ✅ Testes 
- ✅ Documentação de uso

### 4.2. O que NÃO ESTÁ no Escopo

- ❌ Implementação real de assinatura digital criptográfica
- ❌ Implementação real de validação de assinatura digital criptográfica
- ❌ Integração com autoridades certificadoras
- ❌ Armazenamento persistente de assinaturas
- ❌ Interface gráfica (GUI - Graphical User Interface)
- ❌ Autenticação de usuários
- ❌ Geração de certificados digitais

## 5. Requisitos funcionais do Sistema Runner

Os requisitos funcionais são expressos na forma de histórias de usuário (user stories).

### US-01: Invocar assinador.jar via CLI

**Como** usuário do Sistema Runner  
**Quero** executar comandos de assinatura digital através da linha de comandos  
**Para que** eu possa invocar a aplicação **assinador.jar** (doravante, Assinador) sem conhecer os detalhes técnicos de configuração Java, tanto para assinar quanto para validar assinaturas digitais.

**Critérios de aceitação:**
- [ ] O CLI deve aceitar comandos para criação e validação de assinatura
- [ ] O CLI deve invocar o assinador.jar com os parâmetros fornecidos
- [ ] O CLI deve permitir a invocação direta do assinador.jar (modo local/CLI)
- [ ] O CLI deve permitir a invocação do assinador.jar via HTTP (modo servidor)
- [ ] O CLI deve exibir o resultado da operação de forma legível
- [ ] O CLI deve iniciar o assinador.jar no modo servidor usando a porta padrão quando não orientado de forma diferente
- [ ] O CLI deve detectar se instância do assinador.jar já está em execução no modo servidor e usar essa instância, se não orientado de forma diferente. 
- [ ] O CLI deve fazer uso do assinador.jar no modo servidor quando não orientado para usar o modo local
- [ ] O CLI deve interromper a execução do assinador.jar na porta padrão ou outra indicada.
- [ ] O CLI deve permitir a requisição de interrupção programada do assinador.jar após o número de minutos fornecidos sem interação

**Modos de invocação do Assinador:**
- **Invocação direta ou local (CLI)**: o CLI invoca o assinador.jar diretamente via linha de comandos. Cada execução realiza o ciclo completo de inicialização da JVM e carga da aplicação (*cold start*), sendo adequado para execuções esporádicas ou scripts de automação.
- **Invocação via HTTP (servidor)**: o assinador.jar é iniciado e permanece em execução, aguardando requisições HTTP. O CLI envia requisições ao assinador.jar neste modo, eliminando o overhead de inicialização nas chamadas subsequentes (*warm start*), oferecendo menor latência e maior throughput para cenários com múltiplas requisições.


### US-02: Simular assinatura digital com validação de parâmetros

**Como** usuário do Sistema Runner  
**Quero** que o assinador.jar valide rigorosamente os parâmetros de entrada antes de simular uma operação de assinatura digital  
**Para que** eu receba feedback imediato sobre erros de parâmetros, garantindo que apenas requisições bem formadas sejam aceitas

**Critérios de aceitação:**
- [ ] O assinador.jar deve validar todos os parâmetros conforme especificações (veja seção de referências abaixo)
- [ ] O assinador.jar deve simular a criação de assinatura retornando resposta pré-construída quando parâmetros válidos
- [ ] O assinador.jar deve simular validação de assinatura retornando resultado pré-determinado
- [ ] O assinador.jar deve suportar interação com dispositivo criptográfico (token/smart card) via interface PKCS#11
- [ ] O assinador.jar deve retornar mensagens de erro claras quando parâmetros forem inválidos


### US-03: Gerenciar Ciclo de Vida do Simulador do HubSaúde

**Como** usuário do Sistema Runner  
**Quero** iniciar, parar e monitorar o Simulador do HubSaúde (**simulador.jar**) através do CLI  
**Para que** eu possa gerenciar o ciclo de vida do Simulador sem conhecer os comandos Java subjacentes

**Critérios de aceitação:**
- [ ] O CLI deve verificar se a porta padrão, empregada pelo Simulador, 8443, está disponível antes de tentar iniciá-lo.
- [ ] O CLI deve permitir iniciar o Simulador.
- [ ] O CLI deve permitir parar o Simulador (endpoint /shutdown).
- [ ] O CLI deve exibir o status atual do Simulador (ou que não está em execução). O status pode ser obtido via endpoint /api/info.
- [ ] O Simulador (simulador.jar) deve ser obtido dinamicamente pelo CLI, baixando a versão mais recente disponível no repositório da disciplina (GitHub Releases).
- [ ] O CLI deve baixar o JRE caso não esteja disponível no diretório .hubsaude a partir do Eclipse Temurin (Adoptium).
- [ ] O CLI não deve baixar o Simulador (simulador.jar) se a versão mais recente já estiver disponível localmente.

Uma estratégia:
- Busca release.json (URL fixa e conhecida) no próprio repositório (branch main).
- Compara versões com o que está instalado localmente
- Baixa apenas o que mudou

```json
{
  "jar": {
    "url": "https://github.com/kyriosdata/assinador/releases/latest/download/assinador.jar",
    "version": "1.2.0"
  },
  "jre": {
    "windows_x64": "https://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jre/hotspot/normal/eclipse",
    "linux_x64":   "https://api.adoptium.net/v3/binary/latest/21/ga/linux/x64/jre/hotspot/normal/eclipse",
    "mac_x64":     "https://api.adoptium.net/v3/binary/latest/21/ga/mac/x64/jre/hotspot/normal/eclipse"
  }
}
```

### US-04: Provisionar JDK Automaticamente

**Como** usuário do Sistema Runner  
**Quero** que o sistema baixe e configure automaticamente o JDK necessário quando este não estiver disponível  
**Para que** eu possa utilizar o Assinador e o Simulador sem precisar instalar ou configurar o Java manualmente

**Critérios de aceitação:**
- [ ] O sistema deve detectar se o JDK está presente na máquina (na versão exigida)
- [ ] O sistema deve baixar o JDK compatível quando ausente
- [ ] O sistema deve disponibilizar o JDK baixado para uso próprio ou seja, pelo Assinador e Simulador
- [ ] O download deve funcionar nas três plataformas


### US-05: Disponibilizar binários multiplataforma

**Como** usuário do Sistema Runner  
**Quero** baixar uma versão pré-compilada do CLI para minha plataforma (Windows, Linux ou macOS)  
**Para que** eu possa utilizar o sistema imediatamente sem necessidade de compilação

**Critérios de aceitação:**
- [ ] Disponibilizar binário para Windows (amd64)
- [ ] Disponibilizar binário para Linux (amd64)
- [ ] Disponibilizar binário para macOS (amd64)
- [ ] Distribuir via GitHub Releases
- [ ] Incluir checksums SHA256 para verificação de integridade
- [ ] Utilizar versionamento semântico (SemVer)


## 6. Integração entre aplicações

A aplicação **assinatura** (CLI) se comunica com o **assinador.jar** por dois mecanismos:

- **Invocação direta**: `assinatura` executa `assinador.jar` via linha de comandos (ex.: `java -jar assinador.jar ...`)
- **Invocação via HTTP**: `assinatura` envia requisições HTTP para o `assinador.jar` em execução como servidor

O fluxo lógico é o mesmo em ambos os modos, diferindo apenas no mecanismo de comunicação.

### 6.1. Fluxo de Criação de Assinatura

```
Usuário → assinatura → assinador.jar → assinatura → Usuário

1. Usuário: Executa comando para criar assinatura
2. assinatura: valida entrada do usuário
3. assinatura: invoca assinador.jar (diretamente ou via HTTP)
4. assinador.jar: valida parâmetros
5. assinador.jar: retorna assinatura simulada
6. assinatura: formata resultado
7. assinatura: apresenta ao usuário
```

### 6.2. Fluxo de Validação de Assinatura

```
Usuário → assinatura → assinador.jar → assinatura → Usuário

1. Usuário: Executa comando para validar assinatura
2. assinatura: valida entrada do usuário
3. assinatura: invoca assinador.jar (diretamente ou via HTTP)
4. assinador.jar: valida parâmetros
5. assinador.jar: retorna resultado simulado
6. assinatura: formata resultado
7. assinatura: apresenta ao usuário
```

### 6.3. Tratamento de erros

Em qualquer ponto do fluxo, erros devem ser:
- Capturados apropriadamente
- Propagados de forma estruturada
- Apresentados ao usuário de forma clara
- Incluir informação suficiente para correção

## 7. Entregáveis

Devem ser confeccionados e disponibilizados:

1. **Código-fonte da aplicação assinatura**
   - Implementação completa
   - Compatível com Windows, Linux e macOS
   - Código bem documentado

2. **Código-fonte da aplicação assinador.jar**
   - Implementação em Java
   - Validação completa de parâmetros
   - Simulação das operações

3. **Testes**
   - Testes unitários
   - Testes de integração
   - Casos de teste para cenários de erro
   - Testes de aceitação baseados nos critérios definidos

4. **Documentação**
   - Manual de usuário para assinatura
   - Documentação técnica da integração
   - Exemplos de uso
   - Guia de instalação

5. **Especificação (este documento)**
   - Contexto e escopo definidos
   - Diagramas C4
   - Requisitos documentados

6. **Artefatos executáveis**
   - Binários pré-compilados para as três plataformas suportadas:
     - `assinatura-1.0.0-windows-amd64.exe` (Windows)
     - `assinatura-1.0.0-linux-amd64.AppImage` (Linux)
     - `assinatura-1.0.0-macos-amd64.dmg` (macOS)
     - `simulador-1.0.0-windows-amd64.exe` (Windows)
     - `simulador-1.0.0-linux-amd64.AppImage` (Linux)
     - `simulador-1.0.0-macos-amd64.dmg` (macOS)
   - Distribuídos via **GitHub Releases**
   - Cada release deve conter assinatura dos artefatos publicados, conforme a seção abaixo.
   - Observe que é usado SemVer para versionamento, então a versão 1.0.0 é apenas um exemplo e deve ser atualizada conforme o desenvolvimento avança.

7. **Código fonte do Simulador do HubSaúde**
   - Implementação completa
   - Código bem documentado
   - Compatível com Windows, Linux e macOS

## 8. Considerações de implementação

### 8.1. Simulação

Como o sistema **simula** operações de assinatura digital:
- **Para criação**: Prepare assinaturas de exemplo pré-construídas que podem ser retornadas quando os parâmetros são válidos
- **Para validação**: Implemente lógica simples que sempre retorna um resultado pré-determinado (válido/inválido) baseado em critérios simples
- **Foco na validação**: A maior parte do esforço deve estar em validar corretamente os parâmetros de entrada

### 8.2. Padrões de Qualidade

- Código limpo e bem organizado
- Tratamento adequado de exceções
- Testes com boa cobertura
- Documentação clara
- Mensagens de erro úteis


## 9. Integridade e assinatura de artefatos

Para garantir a autenticidade e a integridade dos binários distribuídos, todos os artefatos publicados nas releases do projeto devem ser assinados criptograficamente utilizando **Cosign**, parte do ecossistema **Sigstore**.

Esse mecanismo permite que qualquer usuário verifique de forma independente a origem e a integridade dos artefatos distribuídos, reduzindo riscos de ataques à cadeia de suprimentos de software (*software supply chain*).

### 9.1 Requisito de assinatura

Todos os artefatos distribuídos nas releases do projeto **DEVEM ser assinados utilizando Cosign**.

O processo de assinatura deve utilizar identidade baseada em **OIDC** e registrar a assinatura no *transparency log* do Sigstore.

### 9.2 Arquivos obrigatórios na release

Para cada artefato distribuído, os seguintes arquivos devem ser publicados na release:

```

<artefato>
<artefato>.sig
<artefato>.pem
```

Exemplo:

```
assinatura-1.0.0-linux-amd64.AppImage
assinatura-1.0.0-linux-amd64.AppImage.sig
assinatura-1.0.0-linux-amd64.AppImage.pem
```

### 9.3 Verificação dos artefatos

Os usuários podem verificar a autenticidade de um artefato utilizando o comando `cosign`.

Exemplo:

```bash
cosign verify-blob \
  --certificate assinatura-1.0.0-linux-amd64.AppImage.pem \
  --signature assinatura-1.0.0-linux-amd64.AppImage.sig \
  assinatura-1.0.0-linux-amd64.AppImage
```

Se a verificação for bem-sucedida, o Cosign indicará que a assinatura é válida.

### 9.4 Automação

A assinatura dos artefatos **DEVE ser realizada automaticamente pelo pipeline de CI/CD** durante a criação da release, garantindo consistência e reduzindo o risco de erros manuais.

### 9.5 Justificativa

A assinatura dos artefatos distribuídos proporciona:

* verificação da autenticidade dos binários
* proteção contra adulteração dos artefatos
* rastreabilidade da origem do software
* maior segurança para usuários e integradores

Essa abordagem segue práticas modernas de segurança para **cadeia de suprimentos de software** (*software supply chain security*).

## 10. Referências

1. **Especificações FHIR - Segurança**
   - [Caso de Uso: Criar Assinatura](https://fhir.saude.go.gov.br/r4/seguranca/caso-de-uso-criar-assinatura.html)
   - [Caso de Uso: Validar Assinatura](https://fhir.saude.go.gov.br/r4/seguranca/caso-de-uso-validar-assinatura.html)

2. **Modelo C4 para Visualização de Arquitetura**
   - [C4 Model](https://c4model.com/)
   - Nível 1: [Diagrama de Contexto](./diagramas/imagens/contexto.svg)
   - Nível 2: [Diagrama de Contêiner](./diagramas/imagens/conteineres.svg)

3. **Boas Práticas de CLI**
   - Mensagens claras e consistentes
   - Tratamento adequado de erros
   - Documentação de help integrada
