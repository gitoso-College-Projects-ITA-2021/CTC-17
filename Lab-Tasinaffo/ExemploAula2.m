%% Header
  
%    +----------------------------------------+
%    | Instituto Tecnológico de Aeronáutica   |
%    | CTC-17: Laboratório I                  |
%    | Alunos:                                |
%    |    - Gianluigi Dal Toso                |
%    |    - Lucas Alberto Bilobran Lema       |
%    +----------------------------------------+


% Limpar Variáveis e Tela
clear all
clc


%% 1) Padrões de Entrada e Saída
P = [ -1 -1  2  2;  0  5  0  5 ]
T = [ -1 -1  1  1];

%% 2) Construção da Rede MLP
net = feedforwardnet(3);
net = configure(net, P, T);

%% 3) Dividir Padrões

net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 1.00;
net.divideParam.valRation  = 0.00;
net.divideParam.testRatio  = 0.00;

%% 4) Inicializando os Pesos da Rede
net = init(net);

%% 5) Treinando a Rede Neural
net.trainParam.showWindow = true;
net.layers{1}.dimensions  = 3;
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';
net.performFcn            = 'mse';
net.trainFcn              = 'trainlm';
net.trainParam.epochs     = 10000;
net.trainParam.time       = 120;
net.trainParam.lr         = 0.2;
net.trainParam.min_grad   = 10^-8;
net.trainParam.max_fail   = 1000;

[net, tr] = train(net, P, T);

%% 6) Simular as respostas de saída da rede MLP.

a = sim(net, P);

%% Fase 5: Testando a Rede Neural
aux = size(X);
for i = 1:1:aux(1)
    for j = 1:1:aux(2)
        Paux = [X(i,j) Y(i,j)]';
        Zteste(i,j) = net(Paux);
    end
end
figure(1);
hold off;
plot3(Xrna, Yrna, Zrna, '.r');
hold on;
mesh(X, Y, Zteste);
grid

%% Fase 6: Não copiei ... =(
