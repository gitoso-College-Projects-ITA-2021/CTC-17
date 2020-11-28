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
camargoos = load('datasets/01-camargos.txt');  % Vetor 82 x 12 (1971 - 2012)
furnaas   = load('datasets/02-furnas.txt');    % Vetor 82 x 12 (1971 - 2012)

camargos = reshape(camargoos, 1, []);
furnas = reshape(furnaas, 1, []);

P_camargos_t_dt = [];
P_camargos_t = [];
P_furnas_t_dt = [];
P_furnas_t = [];
Tcamargos = [];
Tfurnas = [];

P_camargos_t_dt = camargos(:, 1:982);
P_camargos_t    = camargos(:, 2:983);
P_furnas_t_dt   = furnas(:, 1:982);
P_furnas_t      = furnas(:, 2:983);

Tcamargos       = camargos(:, 3:984);
Tfurnas         = furnas(:, 3:984);


P = [P_camargos_t_dt; P_camargos_t; P_furnas_t_dt; P_furnas_t];
T = [Tcamargos; Tfurnas];

%% 2) Construção da Rede MLP
algorithm = 'trainlm';
net_layer = [20];
net = feedforwardnet(net_layer, algorithm);
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
%net.layers{1}.dimensions  = 20;
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';
net.performFcn            = 'mse';
net.trainFcn              = 'trainlm';
net.trainParam.epochs     = 10000;
net.trainParam.time       = 60;
net.trainParam.lr         = 0.2;
net.trainParam.min_grad   = 10^-8;
net.trainParam.max_fail   = 1000;

[net, tr] = train(net, P, T);

%% 6) Simular as respostas de saída da rede MLP.

% 6.1 - Resultados da Simulação
xS = 1:1:(82*12-1);
PsA = [camargos(1,1)'; camargos(1, 2)'; furnas(1, 2)'; furnas(1, 2)'];
Ms = PsA;
PsM = [camargos(1, 2)'; furnas(1, 2)'];

Ms2 = [];
Ms1 = [];

for i = 1:1:982
    PsD = sim(net, PsA);
    %Ms = [Ms PsD];
    % Ms1 = [Ms1 PsD(1, :)]
    Ms1 = [Ms1 PsD(1, 1)];
    Ms2 = [Ms2 PsD(2, 1)];
    
    PsA = [PsM(1, 1); PsD(1, 1); PsM(2, 1); PsD(2, 1)];
    PsM = PsD;
end

xP = 1:1:(81*12);
XcamargosP = camargos(:, 1:972);
xF = (81*12)+1:1:82*12;
XcamargosF = camargos(:, 973:end);
plot(xP, XcamargosP, 'b', xF, XcamargosF, 'r');
xlabel('Meses');
ylabel('Vazão');
title('Vazão do Rio Camargo');
grid
hold on

yS1 = [];
Ms1 = [camargos(1,1)' Ms1];
plot(xS, Ms1, ':m');
hold off

pause()

xP = 1:1:(81*12);
XfurnasP = furnas(:, 1:972);
xF = (81*12)+1:1:82*12;
XfurnasF = furnas(:, 973:end);
plot(xP, XfurnasP, 'b', xF, XfurnasF, 'r');
xlabel('Meses');
ylabel('Vazão');
title('Vazão do Rio Furnas');
grid
hold on

yS2 = [];
Ms2 = [furnas(1,1)' Ms2];
plot(xS, Ms2, ':m');
hold off



