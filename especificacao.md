# Sistema Runner - Trabalho Prático

## 1. Visão geral

Este documento define o trabalho prático da disciplina de Implementação e Integração do Bacharelado em Engenharia de Software (2026). O trabalho visa proporcionar aos estudantes a oportunidade de prática de construção de software por meio do desenvolvimento do *Sistema Runner*.

Em tempo, este trabalho prático proposto é de interesse real da Secretaria de Estado de Saúde de Goiás (SES) e da Universidade Federal de Goiás (UFG), que realizam um esforço conjunto na definição e implementação de uma plataforma de interoperabilidade de dados em saúde.

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

### US-01: Invocar Assinador via CLI

**Como** usuário do Sistema Runner  
**Quero** executar comandos de assinatura digital através da linha de comandos  
**Para que** eu possa invocar a aplicação **assinador.jar** (doravante, Assinador) sem conhecer os detalhes técnicos de configuração Java

**Critérios de aceitação:**
- [ ] O CLI deve aceitar comandos para criação e validação de assinatura
- [ ] O CLI deve invocar o Assinador com os parâmetros fornecidos
- [ ] O CLI deve exibir o resultado da operação de forma legível


### US-02: Simular Assinatura Digital com Validação de Parâmetros

**Como** usuário do Sistema Runner  
**Quero** que o Assinador valide rigorosamente os parâmetros de entrada antes de simular uma operação de assinatura digital  
**Para que** eu receba feedback imediato sobre erros de parâmetros, garantindo que apenas requisições bem formadas sejam processadas

**Critérios de aceitação:**
- [ ] O Assinador deve validar todos os parâmetros conforme especificações FHIR
- [ ] O Assinador deve simular criação de assinatura retornando resposta pré-construída quando parâmetros válidos
- [ ] O Assinador deve simular validação de assinatura retornando resultado pré-determinado
- [ ] O Assinador deve suportar interação com dispositivo criptográfico (token/smart card) via interface PKCS#11
- [ ] O Assinador deve retornar mensagens de erro claras quando parâmetros forem inválidos



**Modos de execução do Assinador:**
- **Modo local (CLI)**: a aplicação é invocada diretamente via linha de comandos. Cada execução realiza o ciclo completo de inicialização da JVM e carga da aplicação (*cold start*), sendo adequado para execuções esporádicas ou scripts de automação.
- **Modo servidor (HTTP)**: a aplicação é iniciada uma única vez e permanece em execução, aguardando requisições. Este modo elimina o overhead de inicialização nas chamadas subsequentes (*warm start*), oferecendo menor latência e maior throughput para cenários com múltiplas requisições.

### US-03: Gerenciar Ciclo de Vida do Simulador do HubSaúde

**Como** usuário do Sistema Runner  
**Quero** iniciar, parar e monitorar o Simulador do HubSaúde (**simulador.jar**) através do CLI  
**Para que** eu possa gerenciar o ciclo de vida do Simulador sem conhecer os comandos Java subjacentes

**Critérios de aceitação:**
- [ ] O CLI deve permitir iniciar o Simulador
- [ ] O CLI deve permitir parar o Simulador
- [ ] O CLI deve exibir o status atual do Simulador
- [ ] O Simulador (simulador.jar) não faz parte do escopo de desenvolvimento deste sistema


### US-04: Provisionar JDK Automaticamente

**Como** usuário do Sistema Runner  
**Quero** que o sistema baixe e configure automaticamente o JDK necessário quando este não estiver disponível  
**Para que** eu possa utilizar o Assinador e o Simulador sem precisar instalar ou configurar o Java manualmente

**Critérios de aceitação:**
- [ ] O sistema deve detectar se o JDK está presente na máquina
- [ ] O sistema deve baixar o JDK compatível quando ausente
- [ ] O sistema deve configurar o JDK baixado para uso pelo Assinador e Simulador
- [ ] O download deve funcionar nas três plataformas suportadas


### US-05: Disponibilizar Binários Multiplataforma

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


## 6. Integração entre Aplicações

### 6.1. Fluxo de Criação de Assinatura

```
Usuário → assinatura → assinador.jar → assinatura → Usuário

1. Usuário: Executa comando para criar assinatura
2. assinatura: valida entrada do usuário
3. assinatura: invoca assinador.jar com parâmetros
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
3. assinatura: invoca assinador.jar com parâmetros
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

Devem ser confeccionados e disponibilizado ao longo da disciplina
no repositório correspondente (GitHub).

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
     - `assinatura-windows-amd64.exe` (Windows)
     - `assinatura-linux-amd64` (Linux)
     - `assinatura-darwin-amd64` (macOS)
   - Distribuídos via **GitHub Releases**
   - Cada release deve conter checksums (SHA256) para verificação de integridade
   - Versionamento semântico (SemVer) para controle de releases

## 8. Considerações de Implementação

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

## 9. Referências

1. **Especificações FHIR - Segurança**
   - [Caso de Uso: Criar Assinatura](https://fhir.saude.go.gov.br/r4/seguranca/caso-de-uso-criar-assinatura.html)
   - [Caso de Uso: Validar Assinatura](https://fhir.saude.go.gov.br/r4/seguranca/caso-de-uso-validar-assinatura.html)

2. **Modelo C4 para Visualização de Arquitetura**
   - [C4 Model](https://c4model.com/)
   - Nível 1: Diagrama de Contexto
   - Nível 2: Diagrama de Contêiner

3. **Boas Práticas de CLI**
   - Mensagens claras e consistentes
   - Tratamento adequado de erros
   - Documentação de help integrada

