# Plano (revisado em 24/03/2026)

- CLIs serão feitos em Go por nativamente lidar com cross-compiling e funcionalidades usadas são "básicas" (Go 1.25).
- O assinador.jar será, por restrição de projeto, feito em Java (versão adotada 21).
- A estratégia de implementação adotada é iterativa e incremental, com organização do trabalho em sprints. Essa abordagem viabiliza entregas progressivas de valor, refinamento contínuo da solução e adaptação ao longo do desenvolvimento, mantendo um nível reduzido de formalidade compatível com o porte do projeto.

**Para gerar valor ou remover riscos, é preciso organizar as sprints abaixo. Notei que as histórias registradas estão amplas, então é necessário dividi-las, com entregáveis claros. Um primeiro esforço foi feito, conforme abaixo.**

Sprint 1 (Duração: 1 semana)

- US-01X Criar CLI "Hello World" em Go, com estrutura de projeto e organização de pacotes definida. Resultado: aplicação CLI que exibe "Hello World" quando executada, com estrutura de projeto organizada e documentada.
 
- US-01X e US-02X Configurar pipelines CI/CD. Resultado: CLI criado e pipelines configurados e prontos. Qualdo alteração é feita no CLI, pipeline é executado e executáveis são disponibilizados para download no GitHub Releases.
 
- US-01X Protótipo Go que esclarece como lidar com parâmetros (cli), possivelmente usando [Cobra](https://cobra.dev/), como lidar com processos (iniciar, monitorar, finalizar) e como efetuar requisições http. Resultado: protótipo funcional que pode ser usado como base para o desenvolvimento do CLI.

- US-01X e US-03X Definição do processo de startup dos CLIs. Resultado: definição clara do processo de startup, incluindo a sequência de operações, dependências e tratamento de erros.

Sprint 2 (Duração: 1 semana)

- US-01X Definir a interface `SignatureService` com os métodos `sign(conforme definidos acima)` e `validate(conforme definidos acima)`. A implementação desta interface `SignatureService` é a implementação da simulação a ser realizada pela classe `FakeSignatureService`.

- US-02X Experimentação com Material Criptográfico via Java usando SunPKCS11 para esta finalidade. Talvez exista um simulador útil para testes.  Para simulação um indicação é [SoftHSM2](https://github.com/softhsm/SoftHSMv2). Resultado: definir e validar proposta de item de software que interage com material criptográfico (não inclui implementação). 

- US-02X Implementação da integração com material criptográfico. Resultado: implementação funcional que pode ser usada para assinatura e validação de documentos, inclui testes de integração via SoftHSM2 ou similar.

Sprint 3 (Duração: 1 semana)

- US-01X Identificar os parâmetros necessários tanto para criação quanto para validação de assinatura digital. Resultado: todos os itens de dados necessários são identificados.

- US-01X Realizar o _design_ dos parâmetros. Como fornecê-los? Quais os flags? Arquivo? Resultado: definição clara de como os parâmetros serão fornecidos e utilizados.

- US-03X Ambientação com o Simulador. Resultado: compreensão clara do funcionamento do Simulador, apenas o suficiente para gestão do processo correspondente. 

- US-01X e US-02X Produção da estrutura base da aplicação Go, a ser usada em ambos os CLIs. Resultado: estrutura base da aplicação Go, incluindo organização de pacotes, configuração de logging e outras funcionalidades comuns.

- US-01X e US-02X Implementação de operações em Go usadas em ambos os CLIS, por exemplo, gerenciamento de processos, requisições http, manipulação de arquivos, download, verificação de integridade e descompactação de arquivos, detecção de portas. Resultado: implementação funcional dessas operações, com testes unitários e de integração. Estas operações devem cobrir as necessidades de startup (processo definido anteriormente).
  
Sprint 4 (Duração: 1 semana)

- US-01X e US-02X O modo server é melhor descrito como uma aplicação web, que oferece endpoints para assinatura e validação de documentos. Ou seja, é necessário um controller `SignatureController` com a definição dos endpoints. Na foto são definidos `/sign` e `/validate`.
 
- US-01X e US-02X Definição do banco de dados. Visa armazenar os dados necessários como o runtime Java empregado pelo CLI, a porta empregada pelo processo em execução, o PID do processo em execução e outras. Isso pressupõe o uso de um diretório, por exemplo, `.hubsaude` na home dir do usuário em questão, dentro deste diretório onde depositar o runtime java descompactado, o arquivo contendo informações sobre processos, e outras.

- US-03X Iniciar o simulador coma opção `--source` indicando a partir de onde o simulador.jar deve ser baixado, em detrimento da versão hardwired embutida no próprio simulador. Resultado: o simulador é iniciado e baixa o jar conforme a url indicada pela opção `--source`. Esta versão é armazenada em área temporária e empregada apenas para iniciar a aplicação.
 
- US-01X e US-02X Implementação do processo de inicialização (Startup). Resultado: os CLIs são iniciados adequadamente mesmo em vários cenários distintos, por exemplo, com ou sem runtime Java disponível, com ou sem simulador disponível, etc. O processo de startup deve ser robusto e lidar adequadamente com erros e situações inesperadas. Exige testes de integração abrangentes para validar o comportamento em diferentes cenários.
 
