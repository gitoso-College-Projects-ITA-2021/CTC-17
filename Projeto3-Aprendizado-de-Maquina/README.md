# (CTC-17) Projeto de Aprendizado de Máquina

## <a name='CadernoscontendoaimplementaofinalWIP'></a>Cadernos contendo a implementação final
- [Previsão do nível de acidentes industriais](decision-tree.ipynb)

---

## <a name='Descriodasatividades'></a>Tabela de Conteúdos

<!-- vscode-markdown-toc -->
* [1. Objetivo](#Objetivo)
* [2. Descrição do Trabalho e Base de Dados](#DescriodoTrabalhoeBasedeDados)
	* [2.1 Acidentes de Trabalho em instalações de Manufatura](#AcidentesdeTrabalhoeminstalaesdeManufatura)
	* [ 2.2. Classificador baseado em árvore de decisão](#2.2.Classificadorbaseadoemrvorededeciso)
	* [2.3. Classificador a priori](#Classificadorapriori)
	* [2.4. Análise Comparativa](#AnliseComparativa)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->


## <a name='Objetivo'></a>1. Objetivo
Exercitar e fixar conhecimentos adquiridos sobre Aprendizado de Máquina utilizando árvores de decisão através de programação de algoritmos clássicos, utilizando uma base de dados de fonte diversa e que necessita pre-processamento.

## <a name='DescriodoTrabalhoeBasedeDados'></a>2. Descrição do Trabalho e Base de Dados

### <a name='AcidentesdeTrabalhoeminstalaesdeManufatura'></a>2.1 Acidentes de Trabalho em instalações de Manufatura

O dataset é composto de registro de acidentes em 12 diferentes instalações em três diferentes paises. Cada linha é a ocorrência de um acidente, e conta com as seguintes colunas:

**Columns description**:
* Data: timestamp or time/date information
* Countries: which country the accident occurred (anonymized)
* Local: the city where the manufacturing plant is located (anonymized)
* Industry sector: which sector the plant belongs to (Mining, metals,Others)
* Accident level: from I to VI, it registers how severe was the accident (I means not severe ...VI most severe)
* Potential Accident Level: Depending on the Accident Level, the database also registers how severe the accident could have been (due to other factors involved in the accident)
* Genre: if the person is male of female
* Employee or Third Party: if the injured person is an employee or a third party
* Critical Risk: some description of the risk involved in the accident

**Opção 2**: Selecionar a sua escolha um dataset com no mínimo 5000 instâncias e 5 variáveis para classificação binária
ou multi-classe. Descrever o dataset e o objetivo esperado. Há diversas fontes de dados na Internet tais como Kaggle
([www.kaggle.com](www.kaggle.com)) ou [https://archive.ics.uci.edu/ml/index.php](https://archive.ics.uci.edu/ml/index.php).

### <a name='2.2.Classificadorbaseadoemrvorededeciso'></a> 2.2. Classificador baseado em árvore de decisão 
Utilizando a base de dados fornecida, criar um classificador baseado em árvore de decisão que classifique uma  entrada classifique o nível do acidente (Accident Level), com base nas informações disponíveis nas outras colunas. Separe 80% das linha para treinamento e as demais para teste. Discuta quais variáveis valem a pena ou não participarem  da árvore, elimine as variáveis que vc esteja certo que não colaboram para a classificação. Descreva este processamento  dos dados para prepará-los para os algoritmos. Utilize o algoritmo ID3 ou uma versão deste melhorada, programe sem  utilizar frameworks que implementam árvores de decisão, mas você pode usar framework com estrutura de dados para  árvores.

### <a name='Classificadorapriori'></a>2.3. Classificador a priori
Crie um classificador a priori, isto é que não usa nenhuma informação. Este classificador aponta como classificação a média truncada ou a moda das classificações dos acidentes (ou instâncias).

### <a name='AnliseComparativa'></a>2.4. Análise Comparativa
Compare os dois classificadores utilizando: taxa de acerto, matriz de confusão, erro quadrático médio e estatística kappa. Discuta qual classificador entre os dois (2.2 ou 2.3) é melhor. Proponha alguma alteração no classificador construído no item 2.2 que poderia torná-lo um classificador ainda melhor.