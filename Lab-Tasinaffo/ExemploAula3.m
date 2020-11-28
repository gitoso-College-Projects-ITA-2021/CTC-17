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
camargos = load('datasets/01-camargos.txt');  % Vetor 42 x 17 (1971 - 2012)

Pcamargos = [];
Tcamargos = [];

for i = 1:1:40
    Pcamargos = [Pcamargos camargos(i,:)'];
    Tcamargos = [Tcamargos camargos(i+1,:)'];
end

P = [Pcamargos];
T = [Tcamargos];

%% 2) Construção da Rede MLP
net = feedforwardnet(30);
net = configure(net, P, T);

%% 3) Dividir Padrões

net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 1.00;
net.divideParam.valRatio   = 0.00;
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
net.trainParam.time       = 240;
net.trainParam.lr         = 0.2;
net.trainParam.min_grad   = 10^-8;
net.trainParam.max_fail   = 1000;

[net, tr] = train(net, P, T);

%% 6) Simular as respostas de saída da rede MLP.

% 6.1 - Padrões de treinamento
xP = 1:1:(41*12);
xF = (41*12)+1:1:42*12;

XcamargosP = [];
for i = 1:1:41
    XcamargosP = [XcamargosP camargos(i,:)];
end
XcamargosF = camargos(42,:);
plot(xP, XcamargosP, 'b', xF, XcamargosF, 'r');
xlabel('Meses');
ylabel('Vazão');
title('Vazão do Rio Camargo');
grid

% 6.2 - Resultados da Simulação
hold on
xS = 1:1:(42*12);
PsA = camargos(1,:)';
Ms = PsA;
for i = 1:1:41
    PsD = sim(net, PsA);
    Ms = [Ms PsD];
    PsA = PsD;
end
yS = [];
for i = 1:1:42
    yS = [yS Ms(:,i)'];
end
plot(xS, yS, ':m');