# Sistema Runner

Especificação do trabalho prático da disciplina Implementação e Integração (2026-01)

- [Especificação](especificacao.md)
- [Design](design.md)
- Forneça o seu nome e o repositorio no github usado exclusivamente para o registro das atividades da disciplina na [planilha](https://docs.google.com/spreadsheets/d/1sfYDNnBnBCWHJvyM-Lk8g2DQpvrXalRi1dLH4LL5uHU/edit?gid=0#gid=0). Se grupo, máximo de 2 membros, repita a URL do repositório.

# O que está rolando... (desde 11/03/2026)

- O Princípio de Kerckhoffs diz que: "um sistema criptográfico deve permanecer seguro mesmo que tudo sobre o sistema seja público, exceto a chave privada".

# O que está rolando... (desde 10/03/2026)

- No primeiro encontra a [especificação](https://github.com/kyriosdata/runner/blob/v0.0.1/contexto.md) continha, por exemplo, requisitos sendo tratados como objetivos específicos, logo no início. Isso tinha que mudar. Na versão [melhorada](https://github.com/kyriosdata/runner/blob/v0.0.2/contexto.md), as seções foram alteradas e requisitos foram definidos na forma de user stories.

- Contudo, tenho 100% de certeza que ainda há muito para melhorar, inclusive na compreensão do próprio problema, antes mesmo até de trabalhar com uma estratégia como [SMART](https://thebaguide.com/blog/a-good-requirement-is-a-smart-requirement/) ou [INVEST](https://www.boost.co.nz/blog/2021/10/invest-criteria) para ajudar na caracterização dos requisitos. 

- Na versão v0.0.2 vemos critérios de aceitação, o que está alinhado com o BDD (Behavior Driven Development). Você pode consultar BDD na perspectiva de uma ferramenta concreta e real, o [Cucumber](https://cucumber.io/docs/).

- Apesar dos critérios, ainda não há uma definição clara de "done" para cada requisito, o que é fundamental. Esta definição de "done" é chamada, muitas vezes, de DoD (Definition of Done). Não ter ainda esta definição é natural, pois os requisitos ainda não atendem ao DoR (Definition of Ready), ou seja, ainda não estão prontos, conforme já mencionado.

- Quando olhamos para o [documento](https://github.com/kyyriosdata/runner/blob/v0.0.2/contexto.md), vemos que ele reúne requisitos e design. Em consequência, vamos dividir isso em dois documentos na v0.0.3. 

- Em tempo, conforme o SWEBOK, o que é considerado construção depende do modelo de ciclo de vida adotado, por exemplo, em modelos mais lineares, construção é precedida por requisitos e design, e sucedida por testes. Embora em muitos casos inclua codificação e depuração, também envolve planejamento, projeto detalhado, testes de unidade e testes de integração. 
