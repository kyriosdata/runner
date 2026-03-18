## Após apresentação do problema
Os requisitos, ou uma especificação preliminar do Sistema Runner está disponível. Também há decisões arquiteturais (temos um diagrama de contexto e um diagrama de contêineres) esclarecendo como organizar o sistema. Estes diagramas seguem o Modelo C4 (busque por modelo C4 e encontrará referências). 

Discutimos muito sobre uma “visão do sistema runner”, o professor foi enfático ao dizer que a especificação está INCOMPLETA. Por exemplo, há ênfase em requisitos funcionais, nenhum requisito não funcional (requisito de qualidade) foi fornecido. Por exemplo, se observamos a norma ISO 25010, veremos que não há requisitos de desempenho, consumo de recursos, portabilidade e outros. Sugerimos até o uso de estratégias como o SMART e o INVEST como instrumento para “melhorar” a qualidade da especificação. Também são úteis, neste contexto, abordagens mais formais como a ISO/IEC/IEEE 29148:2018, quando trata de requisitos desejáveis em uma boa especificação de requisitos de software, por comodidade, fornecidos abaixo:


| Atributo | Pergunta central |
|---|---|
| Correto | Cada requisito reflete com precisão o que o sistema deve fazer? |
| Não-ambíguo | Cada requisito tem uma única interpretação possível? |
| Completo | Todos os cenários, entradas, saídas e restrições estão cobertos? |
| Consistente | Nenhum requisito contradiz outro? |
| Classificado por importância/estabilidade | Há priorização (ex: must/should/may)? |
| Verificável | É possível criar um teste para cada requisito? |
| Modificável | A estrutura permite alterar requisitos sem efeitos colaterais? |
| Rastreável | Cada requisito tem origem identificável e pode ser rastreado ao design/teste? |


## Qual o próximo passo?

Antes da construção, você e/ou seu grupo deve ter ao menos uma definição clara do problema, requisitos estabelecidos e uma arquitetura definida (mesmo que parcialmente). Foi assumido, talvez equivocadamente, que há detalhes suficientes, caso contrário, é preciso esclarecer com o professor.

Como especificações raramente chegam completas, inclusive nas disciplinas de construção de software, muitos projetos adotam uma abordagem iterativa e incremental, permitindo que decisões sejam refinadas à medida que conhecimento é adquirido sobre o projeto ao longo do tempo.

Vamos supor que você adotou um processo iterativo e incremental. Nesse caso, o passo seguinte é o planejamento. O que você fará? Para a resposta você terá que definir o design detalhado, depois vai codificar (implementação propriamente dita), criar testes de unidade (se não forem feitos antes, por exemplo, TDD), revisar e refatorar, concluindo a iteração. 

Essa é a construção, ou melhor, um modelo de como construir:

- Design detalhado
- Implementação
- Criar testes de unidade
- Revisar 
- Refatorar

No planejamento, talvez uma das primeiras atividades seja preparar o ambiente, o que em geral já está disponível em uma empresa de software que trabalha em um nicho específico. Talvez você já tenha o seu e, independente do problema, vai seguir com ele (ALERTA). Isso porque uma das decisões é a linguagem de programação a ser utilizada. As convenções de programação (estilo de codificação e outros). Vocês já estão com a indicação do uso do GitHub, mas práticas precisam ser estabelecidas, branches para features, revisão seguida de merge (se aprovada), por exemplo. Talvez você já tenha definido tudo isso e vá direto para a primeira iteração com foco em alguma funcionalidade. Se afirmativo, ok, o que você fará na próxima iteração? Talvez definir o design detalhado ou investigar uma determinada proposta de implementação do CLI, um deles, dado que você não sabe ainda se sua estratégia irá funcionar.
