# Sistema Runner - Trabalho Prático

## 1. Visão geral

Este documento define o contexto e escopo do trabalho prático da disciplina de Implementação e Integração do Bacharelado em Engenharia de Software (2026). O trabalho visa proporcionar aos estudantes a oportunidade de prática de construção de software por meio do desenvolvimento do *Sistema Runner*.

## 2. Objetivo do Sistema Runner

Facilitar o acesso à funcionalidade de execução de aplicações Java via linha de comandos. 

## 3. Objetivos específicos

1. Permitir que os usuários possam executar aplicações Java sem necessidade de conhecer detalhes de configuração ou instalação do ambiente Java. Em particular, as aplicações que fazem parte do Sistema Runner. 

2. Fornecer uma interface de linha de comandos (CLI) simples e intuitiva para interação com as aplicações Java, permitindo que os usuários possam executar comandos específicos para cada aplicação. Desta forma, ocultando a complexidade de configuração ou facilitando o acesso às funcionalidades sem necessidade de conhecimento técnico aprofundado.


## 4. Requisitos do Sistema Runner

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


### 4.1. Aplicação assinatura

Interface via linha de comandos (console) para interação com usuários humanos.

**Características:**
- Multiplataforma (Windows, Linux e macOS)
- Interface de linha de comandos (CLI - Command Line Interface)
- Integra-se com a aplicação assinador.jar
- Fornece uma interface amigável para usuários humanos acessarem funcionalidades de assinatura digital

**Responsabilidades:**
- Receber comandos do usuário
- Validar consistência sintática dos parâmetros de entrada do usuário
- Invocar a aplicação assinador.jar com os parâmetros
- Apresentar resultados ao usuário de forma legível

### 4.2. Aplicação assinador.jar

Aplicação Java que valida parâmetros de entrada e simula a criação e validação de assinaturas digitais.

**Características:**
- Implementada em Java (arquivo .jar)
- Não realiza assinatura digital real (nem cria nem valida, apenas simula)
- Valida parâmetros de entrada
- Retorna respostas pré-construídas
- Suporta dois modos de execução:
  - **Modo local (CLI)**: a aplicação é invocada diretamente via linha de comandos. Cada execução realiza o ciclo completo de inicialização da JVM e carga da aplicação (*cold start*), sendo adequado para execuções esporádicas ou scripts de automação.
  - **Modo servidor (HTTP)**: a aplicação é iniciada uma única vez e permanece em execução, aguardando requisições. Este modo elimina o overhead de inicialização nas chamadas subsequentes (*warm start*), oferecendo menor latência e maior throughput para cenários com múltiplas requisições.

**Responsabilidades:**
- Validar parâmetros recebidos para operações de criação e validação de assinatura
- Reagir corretamente na presença de falhas (parâmetros inválidos)
- Em caso de sucesso na validação:
  - Para **criação de assinatura**: retornar uma assinatura previamente construída (simulada)
  - Para **validação de assinatura**: retornar indicação de sucesso ou falha no formato esperado
- Garantir que todos os parâmetros estejam corretos antes de processar

## 5. Funcionalidades

### 5.1. Criar assinatura digital (simulação)

**Entrada:**
- Referência: [caso-de-uso-criar-assinatura.html](https://fhir.saude.go.gov.br/r4/seguranca/caso-de-uso-criar-assinatura.html)

**Processamento:**
1. Validar todos os parâmetros recebidos
2. Verificar formato e completude dos dados
3. Se válido: retornar assinatura pré-construída
4. Se inválido: retornar mensagem de erro apropriada

**Saída:**
- Sucesso: assinatura digital simulada (pré-construída)
- Falha: mensagem de erro indicando o problema

### 5.2. Validar assinatura digital (simulação)

**Entrada:**
- Referência: [caso-de-uso-validar-assinatura.html](https://fhir.saude.go.gov.br/r4/seguranca/caso-de-uso-validar-assinatura.html)

**Processamento:**
1. Validar todos os parâmetros recebidos
2. Verificar formato da assinatura e dados associados
3. Se válido: retornar resultado simulado (sucesso/falha)
4. Se inválido: retornar mensagem de erro apropriada

**Saída:**
- Sucesso: Indicação se a assinatura é válida ou inválida (simulado)
- Falha: Mensagem de erro indicando o problema

## 6. Requisitos técnicos

### 6.1. Aplicação assinatura

**Requisitos funcionais:**
- RF01: Deve funcionar em Windows, Linux e macOS
- RF02: Deve fornecer interface via linha de comandos
- RF03: Deve validar entrada do usuário antes de invocar assinador.jar
- RF04: Deve apresentar resultados de forma legível ao usuário
- RF05: Deve tratar erros e apresentar mensagens apropriadas

**Requisitos não-funcionais:**
- RNF01: Deve ser fácil de instalar e executar
- RNF02: Deve ter documentação clara de uso
- RNF03: Mensagens de erro devem ser claras e acionáveis

### 6.2. Aplicação assinador.jar

**Requisitos funcionais:**
- RF01: Deve validar rigorosamente todos os parâmetros de entrada
- RF02: Deve implementar operação de criação de assinatura (simulada)
- RF03: Deve implementar operação de validação de assinatura (simulada)
- RF04: Deve retornar erros claros quando parâmetros são inválidos
- RF05: Deve seguir as especificações FHIR para parâmetros

**Requisitos não-funcionais:**
- RNF01: Deve ser executável em qualquer sistema com JVM
- RNF02: Deve ter tratamento robusto de erros
- RNF03: Deve retornar resultados em formato estruturado

## 7. Integração entre Aplicações

### 7.1. Fluxo de Criação de Assinatura

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

### 7.2. Fluxo de Validação de Assinatura

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

### 7.3. Tratamento de erros

Em qualquer ponto do fluxo, erros devem ser:
- Capturados apropriadamente
- Propagados de forma estruturada
- Apresentados ao usuário de forma clara
- Incluir informação suficiente para correção

## 8. Parâmetros de entrada

Os parâmetros para as operações de criação e validação de assinatura digital estão definidos de forma precisa nas especificações FHIR:

### 8.1. Parâmetros para criar Assinatura
- **Referência**: https://fhir.saude.go.gov.br/r4/seguranca/caso-de-uso-criar-assinatura.html
- **Descrição**: define todos os parâmetros necessários para solicitar a criação de uma assinatura digital

### 8.2. Parâmetros para validar Assinatura
- **Referência**: https://fhir.saude.go.gov.br/r4/seguranca/caso-de-uso-validar-assinatura.html
- **Descrição**: define todos os parâmetros necessários para solicitar a validação de uma assinatura digital

## 9. Escopo 

### 9.1. O que ESTÁ no Escopo

- ✅ Desenvolvimento da aplicação assinatura (CLI multiplataforma)
- ✅ Desenvolvimento da aplicação assinador.jar
- ✅ Integração entre as duas aplicações
- ✅ Validação rigorosa de parâmetros
- ✅ Simulação de criação de assinatura
- ✅ Simulação de validação de assinatura
- ✅ Tratamento de erros e exceções
- ✅ Testes das funcionalidades
- ✅ Documentação de uso

### 9.2. O que NÃO ESTÁ no Escopo

- ❌ Implementação real de assinatura digital criptográfica
- ❌ Integração com autoridades certificadoras
- ❌ Armazenamento persistente de assinaturas
- ❌ Interface gráfica (GUI - Graphical User Interface)
- ❌ API web ou serviços REST
- ❌ Autenticação de usuários
- ❌ Geração real de certificados digitais

## 10. Entregáveis

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

## 11. Considerações de Implementação

### 11.1. Simulação

Como o sistema **simula** operações de assinatura digital:
- **Para criação**: Prepare assinaturas de exemplo pré-construídas que podem ser retornadas quando os parâmetros são válidos
- **Para validação**: Implemente lógica simples que sempre retorna um resultado pré-determinado (válido/inválido) baseado em critérios simples
- **Foco na validação**: A maior parte do esforço deve estar em validar corretamente os parâmetros de entrada

### 11.2. Padrões de Qualidade

- Código limpo e bem organizado
- Tratamento adequado de exceções
- Testes com boa cobertura
- Documentação clara
- Mensagens de erro úteis

## 12. Referências

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

