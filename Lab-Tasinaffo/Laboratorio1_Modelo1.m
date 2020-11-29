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


% 1) Padrões de Entrada e Saída
camargoos = load('datasets/01-camargos.txt');  % Vetor 82 x 12 (1971 - 2012)
furnaas   = load('datasets/02-furnas.txt');    % Vetor 82 x 12 (1971 - 2012)

camargos = reshape(camargoos', 1, []);
furnas = reshape(furnaas', 1, []);

P_camargos_t_dt = [];
P_camargos_t = [];
P_furnas_t_dt = [];
P_furnas_t = [];
Tcamargos = [];
Tfurnas = [];

N = size(camargos, 2);

P_camargos_t_dt = camargos(1, 1:N-2);
P_camargos_t    = camargos(1, 2:N-1);
P_furnas_t_dt   = furnas  (1, 1:N-2);
P_furnas_t      = furnas  (1, 2:N-1);

Tcamargos       = camargos(1, 3:N);
Tfurnas         = furnas  (1, 3:N);

P = [P_camargos_t_dt; P_camargos_t; P_furnas_t_dt; P_furnas_t];
T = [Tcamargos; Tfurnas];

% Casos que serão testados
casos = [];

% data.alg   = 'trainlm';
% data.arch  = [20];
% data.title = 'Modelo_1_(6-20-2)_LM';
% casos = [casos data];
% 
% data.alg   = 'trainlm';
% data.arch  = [20 30 25];
% data.title = 'Modelo_2_(6-20-30-25-2)_LM';
% casos = [casos data];
% 
% data.alg   = 'trainrp';
% data.arch  = [54];
% data.title = 'Modelo_3_(6-54-2)_RB';
% casos = [casos data];
% 
% data.alg   = 'traincgp';
% data.arch  = [135];
% data.title = 'Modelo_4_(6-135-2)_PRCG';
% casos = [casos data];
% 
% data.alg   = 'trainbr';
% data.arch  = [200];
% data.title = 'Modelo_5_(6-200-2)_BR';
% casos = [casos data];

data.alg   = 'trainbfg';
data.arch  = [12 24 48 24 12 6];
data.title = 'Modelo_6_(6-12-24-48-12-6-2)_BFGfPr';
casos = [casos data];

figure('position', [0, 0, 1000, 500])

for k = 1:1:size(casos, 2)
    
    % 2) Construção da Rede MLP
    algorithm = casos(1, k).alg;
    net_layer = [casos(1, k).arch];

    net = feedforwardnet(net_layer, algorithm);
    net = configure(net, P, T);

    % 3) Dividir Padrões

    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 0.80;
    net.divideParam.valRatio   = 0.10;
    net.divideParam.testRatio  = 0.10;

    % 4) Inicializando os Pesos da Rede
    net = init(net);

    % 5) Treinando a Rede Neural
    net.trainParam.showWindow = true;
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'purelin';
    net.performFcn            = 'mse';
    net.trainFcn              = algorithm;
    net.trainParam.epochs     = 10000;
    net.trainParam.time       = 120;
    net.trainParam.lr         = 0.2;
    net.trainParam.min_grad   = 10^-8;
    net.trainParam.max_fail   = 1000;

    [net, tr] = train(net, P, T);

    % 6) Simular as respostas de saída da rede MLP.

    % 6.1 - Resultados da Simulação

    % PsA = [camargos(1, 1); camargos(1, 2); furnas(1, 1); furnas(1, 2)];
    % PsM = [camargos(1, 2); furnas(1, 2)];
    % 
    % Ms1 = [];
    % Ms2 = [];
    % 
    % for i = 1:1:N-2
    %     PsD = sim(net, PsA);
    %     Ms1 = [Ms1 PsD(1, 1)];
    %     Ms2 = [Ms2 PsD(2, 1)];
    %     
    %     PsA = [PsM(1, 1); PsD(1, 1); PsM(2, 1); PsD(2, 1)];
    %     PsM = PsD;
    % end

    Ms1 = [];
    Ms2 = [];


    for i = 2:1:N-1
        PsA = [camargos(1, i-1); camargos(1, i); furnas(1, i-1); furnas(1, i)];
        PsD = sim(net, PsA);
        Ms1 = [Ms1 PsD(1, 1)];
        Ms2 = [Ms2 PsD(2, 1)];
    end

    xP = 1:1:N-12;
    XcamargosP = camargos(:, 1:N-12);
    xF = (N-12)+1:1:N;
    XcamargosF = camargos(:, (N-12)+1:N);
    plot(xP, XcamargosP, 'b', xF, XcamargosF, 'r');
    xlabel('Meses');
    ylabel('Vazão');
    title('Vazão do Rio Camargo');
    grid
    hold on

    xS = 3:1:N;
    plot(xS, Ms1, ':m');
    hold off
    saveas(gcf, sprintf('%s-camargo.png', casos(1, k).title));
    
    xP = N-50:1:N-12;
    XfurnasP = furnas(1, N-50:N-12);
    xF = (N-12)+1:1:N;
    XfurnasF = furnas(1, (N-12)+1:N);
    plot(xP, XfurnasP, 'b', xF, XfurnasF, 'r');
    xlabel('Meses');
    ylabel('Vazão');
    title('Vazão do Rio Camargo');
    grid
    hold on

    xS = N-50:1:N;
    plot(xS, Ms2(1,N-52:N-2), ':m');
    hold off
    saveas(gcf, sprintf('%s-camargo-zoom.png', casos(1, k).title));

    xP = 1:1:N-12;
    XfurnasP = furnas(1, 1:N-12);
    xF = (N-12)+1:1:N;
    XfurnasF = furnas(1, (N-12)+1:N);
    plot(xP, XfurnasP, 'b', xF, XfurnasF, 'r');
    xlabel('Meses');
    ylabel('Vazão');
    title('Vazão do Rio Furnas');
    grid
    hold on

    xS = 3:1:N;
    Ms2 = [Ms2];
    plot(xS, Ms2, ':m');
    hold off
    saveas(gcf, sprintf('%s-furnas.png', casos(1, k).title));
    
    xP = N-50:1:N-12;
    XfurnasP = furnas(1, N-50:N-12);
    xF = (N-12)+1:1:N;
    XfurnasF = furnas(1, (N-12)+1:N);
    plot(xP, XfurnasP, 'b', xF, XfurnasF, 'r');
    xlabel('Meses');
    ylabel('Vazão');
    title('Vazão do Rio Furnas');
    grid
    hold on

    xS = N-50:1:N;
    plot(xS, Ms2(1,N-52:N-2), ':m');
    hold off
    saveas(gcf, sprintf('%s-furnas-zoom.png', casos(1, k).title));
    
    plotperform(tr)
    saveas(gcf, sprintf('%s-performance.png', casos(1, k).title));
   end
