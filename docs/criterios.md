# Algumas orientações básicas...

## A. Princípios transversais

- **Rastreabilidade** spec → issue/PR → commit → código → teste. Pergunta para sua reflexão: a cadeia está navegável em ambos os sentidos (do requisito ao teste e vice-versa)? Caso algum elo esteja ausente, por quê?
- **Single source of truth**: não duplicar especificação, design ou instruções genéricas que pertencem ao repositório upstream (upstream: https://github.com/kyriosdata/runner); referenciar via link com commit/tag fixo. Pergunta para sua reflexão: caso tenha duplicado, por quê? Se fez a referência, usou link com commit/tag fixo ou `main`? (lembre-se que `main` pode mudar, quebrando a rastreabilidade; commit ou tag, não).
- **Reprodutibilidade**: qualquer pessoa clona, roda um comando, obtém build e testes verdes. Pergunta para sua reflexão: por que não usou o GitHub Actions para validar isso?
- **Falhar bem**: erros explícitos, códigos de saída coerentes, mensagens esclarecedoras (o quê? Por quê? Como resolver?). Pergunta para sua reflexão: se não fez assim, por quê?
- **Decisões registradas** (ADRs curtos) onde houve escolha não óbvia: porta padrão, estratégia de descoberta de instância, parser de CLI ou outro. Para sua reflexão: se não criou nenhuma ADR, por quê?

## B. Organização do repositório

- Estrutura coerente com a natureza do projeto (multi-módulo: CLI + JAR).
- `.gitignore` adequado por stack; **zero** artefatos versionados (`__pycache__/`, `target/`, `.idea/`, binários, `.DS_Store`).
- `LICENSE` presente e compatível com as dependências.
- Sem documentos que pertencem ao repositório da especificação. O que sobra deve ser **específico desta implementação** proposta pelos autores.
- Nomenclatura consistente: idioma único em paths, sem acentos/espaços, padrão camelCase, PascalCase, snake_case coerente.

## C. Documentação (mínima, específica, viva)

- README como contrato do projeto: o que é, como gerar executáveis, como executar o artefato resultante, como executar os testes, como contribuir, status atual. 
- Referência à especificação por link com commit/tag fixo (não `main`), evitando deriva.
- ADRs curtos (1 página) para decisões relevantes. Para sua reflexão: talvez você não saiba o que seja ADR e, neste caso, por que não pesquisou? Por que não investiu para conhecer? Por que não perguntou ao professor?
- `plano.md`/`roadmap.md` só existem se refletirem o trabalho real, com datas e ligados a issues; caso contrário, remover.


## D. Qualidade de código

- Clareza acima de esperteza: funções curtas, responsabilidades únicas, baixo acoplamento entre transporte (HTTP/subprocess), domínio (assinar/validar) e interface (CLI).
- Fronteiras explícitas: o contrato CLI<->JAR (parâmetros, formato de saída, códigos de erro) é uma API — deve estar documentado e testado, não inferido.
- Aderência ao estilo da linguagem. Exigir via CI (GitHub Actions), não por revisão manual.
- Tipagem (type hints, generics) usada com intenção, não decorativamente.
- Sem `catch (Throwable)` genéricos engolindo erro.
- Logs estruturados em vez de `print` / `System.out`.
- Sem segredos, caminhos absolutos, IPs ou portas hardcoded fora de configuração.
- Encoding UTF-8 declarado; *line endings* tratados (`.gitattributes`).

## E. Requisitos funcionais e de integração

Avaliados como comportamento observável, não como "código existe".

### E1. Invocação local do `assinador.jar`

- Executáveis funcionam independente do diretório atual a partir do qual são invocados.
- Passagem de argumentos preserva espaços, acentos, aspas.
- Propaga *exit code* e separa `stdout` (resultado) de `stderr` (diagnóstico).

### E2. Invocação via HTTP (modo servidor)

- Idempotência de start: detecta instância viva (não só "porta ocupada" — *health check* real) e reutiliza.
- Porta padrão configurável; falha clara quando a porta está tomada por outro processo.
- Shutdown controlado por endpoint/sinal, em qualquer porta indicada.
- Auto-shutdown por inatividade com janela configurável; teste comprovando que o timer reinicia a cada requisição.
- Modo servidor é o padrão; modo local deve ser explicitamente ativado.
- Tratamento explícito de timeout, conexão recusada, resposta malformada.

### E3. Validação de parâmetros

- Feita dentro do `assinador.jar` (autoridade única), não replicada no CLI.

- Mensagens distinguem erro do usuário de erro do sistema; códigos de saída diferentes.

### E4. Simulador do HubSaúde
- Ciclo de vida (start/stop/status) com *health check* e *readiness*; não confundir "processo subiu" com "pronto para receber requisição".

### E6. Portabilidade real

- Funciona em Windows e Linux comprovado em CI.


## F. Build, dependências, supply chain

- Build reproduzível.
- Versões mínimas declaradas e verificadas em runtime com erro amigável.
- Dependências mínimas e justificadas; sem libs abandonadas ou com CVEs conhecidas.
- Distribuição do JAR: artefato único, com `Main-Class` correto, sem dependências externas no classpath do usuário.

## G. Testes

- Pirâmide saudável: muitos unitários, alguns de integração, poucos end-to-end.
- Testes de contrato CLI <-> JAR: subprocess real e HTTP real, em ambos os modos.
- Cenários negativos como cidadãos de primeira classe: porta ocupada, JAR ausente, JVM ausente, timeout, payload inválido, *race* no start.
- Sem testes flaky tolerados; quando inevitável, isolados e marcados.
- Cobertura como sinal, não meta — relatório publicado, sem fetichismo de número.

## H. Engenharia de processo (Git/GitHub)

- Commits atômicos, mensagens no imperativo, idealmente Conventional Commits.
- PRs pequenos, revisáveis, ligados a issues que referenciam as histórias de usuário.
- CI obrigatório: lint + build + testes em Windows e Linux, falha bloqueia merge.
- Tags/releases semânticas coerentes com `release.json`; changelog gerado, não escrito à mão.
- *Hygiene*: sem branches mortas, sem PRs abertos há muito tempo.

## I. Operabilidade

- `--help` que ensina (com exemplos), não que lista flags.
- Versão acessível via `--version` retornando algo rastreável (tag + SHA curto).
- Logs em nível ajustável; modo `--verbose` / `--quiet` previsível.

