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
camargos = load('datasets/01-camargos.txt');  % Vetor 82 x 12 (1971 - 2012)
furnas   = load('datasets/02-furnas.txt');    % Vetor 82 x 12 (1971 - 2012)

P_camargos_t_dt = [];
P_camargos_t = [];
P_furnas_t_dt = [];
P_furnas_t = [];
Tcamargos = [];
Tfurnas = [];

for i = 2:1:40
    P_camargos_t_dt = [P_camargos_t_dt camargos(i-1,:)'];
    P_camargos_t    = [P_camargos_t    camargos(i,:)'];
    P_furnas_t_dt   = [P_furnas_t_dt   furnas(i-1,:)'];
    P_furnas_t      = [P_furnas_t      furnas(i,:)'];
    
    Tcamargos       = [Tcamargos       camargos(i+1,:)'];
    Tfurnas         = [Tfurnas         furnas(i+1,:)'];
end

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
net.trainParam.time       = 240;
net.trainParam.lr         = 0.2;
net.trainParam.min_grad   = 10^-8;
net.trainParam.max_fail   = 1000;

[net, tr] = train(net, P, T);

%% 6) Simular as respostas de saída da rede MLP.

% 6.1 - Resultados da Simulação
xS = 1:1:(42*12);
PsA = [camargos(1,:)'; camargos(2, :)'; furnas(1, :)'; furnas(2, :)'];
Ms = PsA;
PsM = [camargos(2, :)'; furnas(2, :)'];

Ms2 = [];
Ms1 = [];

for i = 1:1:41
    PsD = sim(net, PsA);
    %Ms = [Ms PsD];
    % Ms1 = [Ms1 PsD(1, :)]
    Ms1 = [Ms1 PsD(1:12, :)];
    Ms2 = [Ms2 PsD(13:24, :)];
    
    PsA = [PsM(1:12, :); PsD(1:12, :); PsM(13:24, :); PsD(13:24, :)]
    PsM = PsD;
end

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
hold on

yS1 = [];
Ms1 = [camargos(1, :)' Ms1];
for i = 1:1:42
    yS1 = [yS1 Ms1(:,i)'];
end
plot(xS, yS1, ':m');
hold off

pause()

XfurnasP = [];
for i = 1:1:41
    XfurnasP = [XfurnasP furnas(i,:)];
end
XfurnasF = furnas(42,:);
plot(xP, XfurnasP, 'b', xF, XfurnasF, 'r');
xlabel('Meses');
ylabel('Vazão');
title('Vazão do Rio Furnas');
grid
hold on

yS2 = [];
Ms2 = [furnas(1, :)' Ms2];
for i = 1:1:42
    yS2 = [yS2 Ms2(:,i)'];
end
plot(xS, yS2, ':m');
hold off



