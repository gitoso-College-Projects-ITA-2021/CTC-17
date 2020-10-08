# (CTC-17) Projeto de Melhoria Iterativa e de Satisfação de Restrições

## <a name='Cadernoscontendoaimplementaofinal'></a>Cadernos contendo a implementação final
- [Parte 1: N-Rainhas](n-queens.ipynb)
- [Parte 2: Máximo de função](max-function.ipynb)

---

## <a name='Descriodasatividades'></a>Descrição das atividades

<!-- vscode-markdown-toc -->
* [1. Objetivo](#Objetivo)
* [2. Descrição do Trabalho](#DescriodoTrabalho)
	* [2.1 Melhoria Iterativa](#MelhoriaIterativa)
		* [2.1.1 N-Rainhas](#N-Rainhas)
		* [2.2.2 Máximo de função](#Mximodefuno)
	* [2.2 Satisfação de Restrições](#SatisfaodeRestries)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->


## <a name='Objetivo'></a>1. Objetivo
Exercitar e fixar conhecimentos adquiridos sobre Resolução de Problemas através de Busca de Melhoria Iterativa (onde o destino é a solução, não o caminho) e sobre Problema de Satisfação de Restrições

## <a name='DescriodoTrabalho'></a>2. Descrição do Trabalho

### <a name='MelhoriaIterativa'></a>2.1 Melhoria Iterativa

#### <a name='N-Rainhas'></a>2.1.1 N-Rainhas
Crie um sistema capaz de resolver o problema das N-Rainhas através de busca de melhoria iterativa (hill climbing ou têmpera simulada) para N com os seguintes valores 10, 20 e 25. Tabele os tempos de processamento para obter uma solução.

#### <a name='Mximodefuno'></a>2.2.2 Máximo de função
Usando um algoritmo distinto do item 2.1, determine o máximo global da função abaixo. (Resoluções analíticas não são aceitáveis). Você encontrou algum ponto de máximo local ? Qual(is)?

### <a name='SatisfaodeRestries'></a>2.2 Satisfação de Restrições
Forneça pelo uma modelagem de problema de satisfação de restrições para a alocação de horário de aulas de um semestre de uma turma com _d_ disciplinas, _p_ professores, _s_ salas e horários de segunda a sexta de 8 as 12h. Cada professor tem uma lista de disciplinas que pode ministrar. Uma solução é aceitável se respeitar estas restrições e as demais óbvias, por exemplo: um professor não pode ministrar duas disciplinas no mesmo tempo e nem uma sala pode ser usada por duas disciplinas distintas ao mesmo tempo. A modelagem deve incluir a lista de variáveis, seus domínios e as restrições formalmente definidas. (A solução deste problema consta apenas no relatório entregue para o professor).