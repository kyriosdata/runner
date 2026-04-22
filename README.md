# Sistema Runner

Especificação do trabalho prático da disciplina Implementação e Integração (2026-01). Esta é a orientação para o que precisa ser feito:

- [Especificação](especificacao.md)
- [Design](design.md)
- [Plano de implementação](docs/plano-revisitado-v2.md)
- [Sprint 1](./docs/sprint-1-tasks.md)

# O que está acontecendo... 

- Temos uma especificação e um projeto inicial (fornecidos acima).
- Foi considerado "pronto". Então partimos para um [plano preliminar](./docs/plano-preliminar.md). Apenas um esboço inicial, especulação, brainstorming inicial.
- Ao fazer uma análise do plano preliminar encontramos, naturalmente, oportunidades de melhoria. Por exemplo, a especificação contém "épicos", são "gigantes", que precisam ser divididos em histórias menores, com entregáveis claros. No entanto, não quis alterar os requisitos iniciais. Então o plano foi revisado. O plano revisado é apresentado [aqui](./docs/plano-revisitado.md). Até aqui tudo humano, mas ainda ficam claras as oportunidades de melhoria.
- O ChatGPT com um prompt visando ajudar a dividir as histórias e organizá-las em sprints, contemplando o que está no plano revisitado resultou no [Plano Revisitado #2](./docs/plano-revisitado-v2.md). Eu teria levado muito, muito mais tempo para fazer o mesmo, mas também não faria igual. De qualquer forma, é uma versão que serve como novo ponto de partida para o planejamento da primeira iteração (sprint). 
- Em essência, o [plano revisitado](./docs/plano-revisitado.md) refinou os requisitos (épicos) em itens menores com entregáveis claros, e o [Plano Revisitado #2](./docs/plano-revisitado-v2.md) formalizou esses itens como histórias de usuário organizadas em sprints orientadas a valor. Ou seja, um esforço de engenharia de requisitos e parte de gerenciamento de projeto.
- Estes ajustes permitem agora que o planejamento da construção possa ser realizado com a identificação de tarefas operacionais.


# O que está rolando... (desde 18/03/2026)

- Agora é o momento do planejamento da construção, ou pelo menos da primeira iteração. O que você vai fazer?
- Veja [aqui](./docs/planejamento.md) alguma orientação.

# O que está rolando... (desde 11/03/2026)

- O Princípio de Kerckhoffs diz que: "um sistema criptográfico deve permanecer seguro mesmo que tudo sobre o sistema seja público, exceto a chave privada".

# O que está rolando... (desde 10/03/2026)

- No primeiro encontra a [especificação](https://github.com/kyriosdata/runner/blob/v0.0.1/contexto.md) continha, por exemplo, requisitos sendo tratados como objetivos específicos, logo no início. Isso tinha que mudar. Na versão [melhorada](https://github.com/kyriosdata/runner/blob/v0.0.2/contexto.md), as seções foram alteradas e requisitos foram definidos na forma de user stories.

- Contudo, tenho 100% de certeza que ainda há muito para melhorar, inclusive na compreensão do próprio problema, antes mesmo até de trabalhar com uma estratégia como [SMART](https://thebaguide.com/blog/a-good-requirement-is-a-smart-requirement/) ou [INVEST](https://www.boost.co.nz/blog/2021/10/invest-criteria) para ajudar na caracterização dos requisitos. 

- Na versão v0.0.2 vemos critérios de aceitação, o que está alinhado com o BDD (Behavior Driven Development). Você pode consultar BDD na perspectiva de uma ferramenta concreta e real, o [Cucumber](https://cucumber.io/docs/).

- Apesar dos critérios, ainda não há uma definição clara de "done" para cada requisito, o que é fundamental. Esta definição de "done" é chamada, muitas vezes, de DoD (Definition of Done). Não ter ainda esta definição é natural, pois os requisitos ainda não atendem ao DoR (Definition of Ready), ou seja, ainda não estão prontos, conforme já mencionado.

- Quando olhamos para o [documento](https://github.com/kyyriosdata/runner/blob/v0.0.2/contexto.md), vemos que ele reúne requisitos e design. Em consequência, vamos dividir isso em dois documentos na v0.0.3. 

- Em tempo, conforme o SWEBOK, o que é considerado construção depende do modelo de ciclo de vida adotado, por exemplo, em modelos mais lineares, construção é precedida por requisitos e design, e sucedida por testes. Embora em muitos casos inclua codificação e depuração, também envolve planejamento, projeto detalhado, testes de unidade e testes de integração. 
