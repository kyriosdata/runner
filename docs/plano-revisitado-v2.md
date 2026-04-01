# Plano Revisado #2

## Premissas

- CLIs serão desenvolvidos em **Go** (1.25), por nativamente lidar com cross-compiling e as funcionalidades exigidas serem bem suportadas pela biblioteca padrão.
- O **assinador.jar** será desenvolvido em **Java 21**, por restrição de projeto.
- Estratégia **iterativa e incremental**, organizada em **4 sprints de 1 semana**.
- Cada sprint entrega valor ao usuário ou remove riscos técnicos relevantes.
- As histórias abaixo são subdivisões dos épicos US-01 a US-05 da [especificação](../especificacao.md), nomeadas como `US-XX.Y` indicando a história de origem.

## Rastreabilidade Épicos → Histórias

| Épico | Descrição | Histórias derivadas |
|-------|-----------|---------------------|
| US-01 | Invocar assinador.jar via CLI | US-01.1, US-01.2, US-01.3, US-01.4, US-01.5, US-01.6, US-01.7, US-01.8, US-01.9 |
| US-02 | Simular assinatura digital com validação | US-02.1, US-02.2, US-02.3, US-02.4, US-02.5 |
| US-03 | Gerenciar Ciclo de Vida do Simulador | US-03.1, US-03.2, US-03.3, US-03.4 |
| US-04 | Provisionar JDK Automaticamente | US-04.1 |
| US-05 | Disponibilizar binários multiplataforma | US-05.1, US-05.2, US-05.3 |

---

## Sprint 1 — Fundação e Entrega Contínua

**Objetivo:** Estabelecer a infraestrutura de desenvolvimento e entrega contínua. Ao final, o primeiro executável do CLI está disponível para download no GitHub Releases.

**Valor entregue:** Toda contribuição de código passa por CI e gera artefatos prontos para uso. Base sólida para iterações futuras.

### US-01.1 — Estrutura base do CLI em Go

**Como** usuário do Sistema Runner,
**quero** que o projeto CLI esteja estruturado com organização de pacotes e build funcional,
**para que** o desenvolvimento possa progredir de forma organizada e incremental.

**Critérios de aceitação:**
- [ ] Projeto Go inicializado com `go mod init github.com/kyriosdata/assinatura`
- [ ] Instalar ferramenta para cli em Go `go install github.com/spf13/cobra-cli@latest`
- Prompt: acrescente ao projeto que usa o Cobra a opção version, desta forma, quando for executado, deve exibir a versão corrente da aplicação.
- [ ] Estrutura de pacotes definida e documentada
- [ ] Aplicação compila e executa nas três plataformas (Windows, Linux, macOS)
- [ ] Comando `assinatura version` exibe a versão atual do CLI

### US-05.1 — Pipeline CI/CD multiplataforma

**Como** desenvolvedor do Sistema Runner,
**quero** que alterações no repositório disparem automaticamente a compilação para Windows, Linux e macOS,
**para que** binários atualizados estejam sempre disponíveis após cada mudança.

**Critérios de aceitação:**
- [x] GitHub Actions configurado com workflow de build
- [x] Cross-compilation para `windows/amd64`, `linux/amd64` e `darwin/amd64`
- [x] Build executado a cada push na branch principal
- [x] Artefatos de build disponíveis como artifacts do workflow

### US-05.2 — Publicação de releases com versionamento semântico

**Como** usuário do Sistema Runner,
**quero** baixar binários pré-compilados para minha plataforma a partir do GitHub Releases,
**para que** eu possa utilizar o sistema sem necessidade de compilação, com versionamento claro.

**Critérios de aceitação:**
- [ ] Tags de versão seguem SemVer (ex.: `v0.1.0`)
- [ ] Workflow de release gera binários nomeados por plataforma
- [ ] Binários publicados automaticamente no GitHub Releases ao criar tag
- [ ] Nome dos artefatos segue convenção: `assinatura-<versão>-<os>-<arch>`

---

## Sprint 2 — Assinatura Digital Simulada (modo local)

**Objetivo:** Entregar o fluxo completo ponta-a-ponta: o usuário executa um comando no CLI e obtém uma assinatura simulada ou validação, via invocação local do assinador.jar.

**Valor entregue:** O caso de uso principal funciona. O usuário cria e valida assinaturas digitais simuladas via CLI, sem configurar Java manualmente.

### US-02.1 — Simulação de criação de assinatura digital

**Como** usuário do Sistema Runner,
**quero** que o assinador.jar retorne uma assinatura simulada quando receber parâmetros válidos,
**para que** eu possa testar o fluxo de assinatura sem infraestrutura criptográfica real.

**Critérios de aceitação:**
- [ ] Interface `SignatureService` definida com métodos `sign` e `validate`
- [ ] Implementação `FakeSignatureService` retorna assinatura pré-construída para parâmetros válidos
- [ ] Resposta simulada inclui os campos esperados conforme especificação
- [ ] Testes unitários cobrem o cenário de sucesso

### US-02.2 — Validação de parâmetros de criação de assinatura

**Como** usuário do Sistema Runner,
**quero** que o assinador.jar valide rigorosamente os parâmetros de criação de assinatura,
**para que** eu receba feedback imediato e claro sobre erros antes da operação ser processada.

**Critérios de aceitação:**
- [ ] Todos os parâmetros obrigatórios são verificados (presença e formato)
- [ ] Mensagens de erro indicam qual parâmetro está inválido e o motivo
- [ ] Parâmetros inválidos são rejeitados antes de qualquer processamento
- [ ] Testes unitários cobrem todos os cenários de validação

### US-02.3 — Simulação e validação de parâmetros de validação de assinatura

**Como** usuário do Sistema Runner,
**quero** que o assinador.jar valide os parâmetros de validação de assinatura e retorne resultado pré-determinado,
**para que** eu possa testar o fluxo de validação com feedback claro sobre parâmetros incorretos.

**Critérios de aceitação:**
- [ ] Parâmetros de validação são verificados (presença e formato)
- [ ] Resultado pré-determinado (válido/inválido) retornado baseado em critérios simples
- [ ] Mensagens de erro claras para parâmetros inválidos
- [ ] Testes unitários cobrem cenários de sucesso e falha

### US-01.2 — Parsing de comandos e parâmetros no CLI

**Como** usuário do Sistema Runner,
**quero** executar comandos `sign` e `validate` com parâmetros via linha de comandos,
**para que** eu possa solicitar operações de assinatura de forma intuitiva.

**Critérios de aceitação:**
- [ ] CLI aceita o comando `sign` com os parâmetros necessários
- [ ] CLI aceita o comando `validate` com os parâmetros necessários
- [ ] Mensagem de ajuda (`--help`) documenta os comandos e parâmetros disponíveis
- [ ] Parâmetros ausentes ou inválidos geram mensagem de erro orientativa
- [ ] Testes cobrem o parsing de comandos e parâmetros

### US-01.3 — Invocação do assinador.jar no modo local

**Como** usuário do Sistema Runner,
**quero** que o CLI invoque o assinador.jar diretamente via `java -jar` com os parâmetros fornecidos,
**para que** eu possa criar e validar assinaturas sem executar comandos Java manualmente.

**Critérios de aceitação:**
- [ ] CLI localiza o `java` disponível (provisionado ou do sistema)
- [ ] CLI constrói e executa o comando `java -jar assinador.jar` com parâmetros corretamente mapeados
- [ ] Saída do assinador.jar é capturada e repassada ao usuário
- [ ] Erros de execução (ex.: JDK ausente, jar não encontrado) são tratados com mensagens claras
- [ ] Testes de integração validam o fluxo CLI → assinador.jar

### US-01.4 — Exibição legível de resultados

**Como** usuário do Sistema Runner,
**quero** que o CLI apresente o resultado das operações de forma legível e estruturada,
**para que** eu compreenda facilmente o resultado da assinatura ou validação.

**Critérios de aceitação:**
- [ ] Resultado de criação de assinatura é formatado de forma legível
- [ ] Resultado de validação de assinatura indica claramente se é válida ou inválida
- [ ] Erros são apresentados com mensagem descritiva e orientação para correção
- [ ] Saída é adequada para uso em terminal (não requer pós-processamento)

### US-04.1 — Detecção e provisionamento automático do JDK

**Como** usuário do Sistema Runner,
**quero** que o sistema detecte se o JDK compatível está presente e, caso não esteja, baixe e configure automaticamente,
**para que** eu possa utilizar o Assinador sem instalar o Java manualmente.

**Critérios de aceitação:**
- [ ] Sistema verifica se JDK 21 está disponível no `PATH` ou em diretório gerenciado (`~/.hubsaude/`)
- [ ] Se ausente, JDK é baixado automaticamente da distribuição adequada para a plataforma (Windows, Linux, macOS)
- [ ] JDK baixado é armazenado em `~/.hubsaude/jdk/` para reuso
- [ ] Download não é repetido se JDK já estiver provisionado
- [ ] Testes cobrem detecção de JDK presente e ausente nas três plataformas

---

## Sprint 3 — Modo Servidor e Material Criptográfico

**Objetivo:** O assinador.jar funciona como servidor HTTP. O CLI gerencia seu ciclo de vida e realiza invocações via HTTP. Suporte a dispositivo criptográfico via PKCS#11 é integrado.

**Valor entregue:** Modo de execução com menor latência disponível. Suporte a token/smart card funcional.

### US-02.4 — Endpoints HTTP do assinador.jar

**Como** usuário do Sistema Runner,
**quero** que o assinador.jar exponha endpoints HTTP `/sign` e `/validate`,
**para que** o CLI possa invocá-lo via requisições HTTP no modo servidor.

**Critérios de aceitação:**
- [ ] `SignatureController` implementado com endpoints `POST /sign` e `POST /validate`
- [ ] Endpoints reutilizam a mesma lógica de validação e simulação do modo CLI
- [ ] Respostas HTTP seguem estrutura consistente (sucesso e erro)
- [ ] Testes de integração validam os endpoints

### US-02.5 — Integração com dispositivo criptográfico via PKCS#11

**Como** usuário do Sistema Runner,
**quero** que o assinador.jar suporte interação com dispositivo criptográfico (token/smart card) via PKCS#11,
**para que** eu possa utilizar material criptográfico real ou simulado nas operações de assinatura.

**Critérios de aceitação:**
- [ ] Integração com PKCS#11 via `SunPKCS11` provider
- [ ] Testes de integração utilizando SoftHSM2 (ou simulador equivalente)
- [ ] Comportamento adequado quando dispositivo não está disponível (mensagem clara)
- [ ] Documentação do setup necessário para uso com dispositivo criptográfico

### US-01.5 — Iniciar assinador.jar no modo servidor

**Como** usuário do Sistema Runner,
**quero** que o CLI inicie o assinador.jar no modo servidor usando a porta padrão,
**para que** o assinador.jar fique disponível para requisições HTTP com menor latência.

**Critérios de aceitação:**
- [ ] CLI inicia o assinador.jar como processo em background na porta padrão
- [ ] PID e porta do processo são registrados em `~/.hubsaude/` para gestão posterior
- [ ] Feedback é exibido ao usuário confirmando que o servidor iniciou
- [ ] Porta pode ser personalizada via parâmetro `--port`

### US-01.6 — Invocar assinador.jar via HTTP

**Como** usuário do Sistema Runner,
**quero** que o CLI envie requisições HTTP ao assinador.jar no modo servidor por padrão,
**para que** eu tenha menor latência nas operações, eliminando o overhead de cold start.

**Critérios de aceitação:**
- [ ] CLI envia requisições HTTP para os endpoints `/sign` e `/validate`
- [ ] Modo servidor é utilizado por padrão quando há instância em execução
- [ ] Fallback para modo local quando servidor não está disponível (ou conforme flag `--local`)
- [ ] Testes de integração validam o fluxo CLI → HTTP → assinador.jar

### US-01.7 — Detectar instância do assinador.jar em execução

**Como** usuário do Sistema Runner,
**quero** que o CLI detecte se já existe uma instância do assinador.jar em execução e a reutilize,
**para que** não sejam criadas instâncias duplicadas desnecessariamente.

**Critérios de aceitação:**
- [ ] CLI consulta `~/.hubsaude/` para verificar processo registrado
- [ ] Verificação de health check HTTP confirma que o processo está respondendo
- [ ] Se instância ativa é encontrada, CLI a reutiliza em vez de iniciar nova
- [ ] Se processo registrado não responde, é considerado inativo

### US-01.8 — Interromper execução do assinador.jar

**Como** usuário do Sistema Runner,
**quero** interromper a execução do assinador.jar em uma porta específica ou na porta padrão,
**para que** eu tenha controle sobre os processos em execução no meu sistema.

**Critérios de aceitação:**
- [ ] Comando `assinatura stop` encerra o assinador.jar na porta padrão
- [ ] Parâmetro `--port` permite especificar a porta do processo a encerrar
- [ ] Feedback é exibido confirmando o encerramento
- [ ] Registro em `~/.hubsaude/` é atualizado após encerramento

### US-01.9 — Agendar interrupção do assinador.jar por inatividade

**Como** usuário do Sistema Runner,
**quero** agendar a interrupção automática do assinador.jar após um período sem interação,
**para que** recursos do sistema sejam liberados automaticamente quando não estiverem em uso.

**Critérios de aceitação:**
- [ ] Parâmetro `--timeout <minutos>` define tempo máximo de inatividade
- [ ] Após o período sem requisições, assinador.jar é encerrado automaticamente pelo CLI ou pelo próprio servidor
- [ ] Mecanismo de timeout é documentado no help do CLI

---

## Sprint 4 — Simulador do HubSaúde e Segurança de Artefatos

**Objetivo:** Gestão completa do Simulador do HubSaúde via CLI. Artefatos distribuídos com checksums e assinatura criptográfica para garantir integridade.

**Valor entregue:** Sistema Runner completo. Todos os casos de uso funcionais. Artefatos verificáveis e seguros.

### US-03.1 — Iniciar o Simulador via CLI

**Como** usuário do Sistema Runner,
**quero** iniciar o Simulador do HubSaúde através do CLI,
**para que** eu possa gerenciá-lo sem conhecer os comandos Java subjacentes.

**Critérios de aceitação:**
- [ ] Comando `simulador start` inicia o simulador.jar
- [ ] CLI verifica se as portas necessárias estão disponíveis antes de iniciar
- [ ] Se o simulador.jar não estiver disponível localmente, é baixado automaticamente (ver US-03.4)
- [ ] Feedback exibido ao usuário sobre o status de inicialização

### US-03.2 — Parar e monitorar o Simulador

**Como** usuário do Sistema Runner,
**quero** parar o Simulador e consultar seu status atual,
**para que** eu tenha visibilidade e controle sobre o ciclo de vida do Simulador.

**Critérios de aceitação:**
- [ ] Comando `simulador stop` encerra o Simulador
- [ ] Comando `simulador status` exibe se o Simulador está em execução ou não
- [ ] Informações de processo (PID, porta) são registradas em `~/.hubsaude/`
- [ ] Encerramento limpo do processo com tratamento adequado de erros

### US-03.3 — Estrutura base do CLI "simulador" em Go

**Como** usuário do Sistema Runner,
**quero** um CLI dedicado para o Simulador com estrutura e organização próprias,
**para que** a gestão do Simulador tenha interface independente e clara.

**Critérios de aceitação:**
- [ ] Projeto CLI `simulador` segue a mesma estrutura do CLI `assinatura`
- [ ] Comandos `start`, `stop` e `status` definidos
- [ ] Pipeline CI/CD gera binários multiplataforma do CLI `simulador`
- [ ] Binários publicados no GitHub Releases junto com o CLI `assinatura`

### US-03.4 — Obter simulador.jar dinamicamente

**Como** usuário do Sistema Runner,
**quero** que o CLI baixe automaticamente a versão mais recente do simulador.jar do GitHub Releases,
**para que** eu sempre utilize a versão atualizada sem necessidade de download manual.

**Critérios de aceitação:**
- [ ] CLI consulta GitHub Releases para identificar a versão mais recente do simulador.jar
- [ ] Download automático quando simulador.jar não está disponível localmente
- [ ] Opção `--source <url>` permite indicar URL alternativa para download
- [ ] Versão já baixada não é baixada novamente (cache local em `~/.hubsaude/`)
- [ ] Verificação de integridade do download (checksum)

### US-05.3 — Checksums SHA256 e assinatura de artefatos com Cosign

**Como** usuário do Sistema Runner,
**quero** que os binários distribuídos incluam checksums SHA256 e assinatura via Cosign,
**para que** eu possa verificar a integridade e autenticidade dos artefatos baixados.

**Critérios de aceitação:**
- [ ] Cada release inclui arquivo de checksums SHA256 para todos os binários
- [ ] Artefatos assinados com Cosign (identidade OIDC + transparency log)
- [ ] Cada artefato acompanhado de `.sig` e `.pem` conforme especificação
- [ ] Processo de assinatura automatizado no pipeline CI/CD
- [ ] Documentação de como verificar artefatos com `cosign verify-blob`

---

## Resumo de Sprints

| Sprint | Foco | Histórias | Resultado principal |
|--------|------|-----------|---------------------|
| 1 | Fundação e Entrega Contínua | US-01.1, US-05.1, US-05.2 | CLI base + CI/CD + Releases |
| 2 | Assinatura Simulada (modo local) | US-02.1, US-02.2, US-02.3, US-01.2, US-01.3, US-01.4, US-04.1 | Fluxo ponta-a-ponta funcional |
| 3 | Modo Servidor e PKCS#11 | US-02.4, US-02.5, US-01.5, US-01.6, US-01.7, US-01.8, US-01.9 | Servidor HTTP + material criptográfico |
| 4 | Simulador e Segurança | US-03.1, US-03.2, US-03.3, US-03.4, US-05.3 | Sistema completo e seguro |
