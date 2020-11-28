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

%% Função Original
% Vetores x e y
x = 0:.1:10;
y = 0:.1:10;

% Malha bidimensional do par ordenado (x,y)
[X, Y] = meshgrid(x,y);

% Variável dependente Z definida no domínio da malha
Z      = X .* sin(4*X) + 1.1 * Y .* sin(2*Y);

% Plot da malha com a função
mesh(X,Y,Z);
title('Função a ser Interpolada Pela Rede Neura;');
xlabel('Eixo X');
ylabel('Eixo Y');
zlabel('Eixo Z');
grid on;
hold on;
pause();

%% Treinamento
% Número total de padrões de treinamento
dim  = 10000;

% Valores aleatórios de x no domínio [0, 10]
Xrna = 10 * rand(1, dim);

% Valores aleatórios de y no domínio [0, 10]
Yrna = 10 * rand(1, dim);

% Função Z
Zrna = Xrna .* sin(4 * Xrna) + 1.1 * Yrna .* sin(2 * Yrna);

% Plot
plot3(Xrna, Yrna, Zrna, '.b');
title('Treinamento com 10000 Pontos');
P = [ Xrna; Yrna ]
T = Zrna;

%% Fase 2: Construção da Rede MLP
net = feedforwardnet(30);
net = configure(net, P, T);

%% Fase 3: Pré-Processamento
% 3.1 Normalização dos padrões de treinamento de entrada/saída entre 0 e 1
net.inputs{1}.processParams{2}.ymin  = 0;
net.inputs{1}.processParams{2}.ymax  = 1;
net.outputs{2}.processParams{2}.ymin = 0;
net.outputs{2}.processParams{2}.ymax = 1;

disp('net.inputs{1}.processFcns');
net.inputs{1}.processFcns
disp('net.inputs{1}.processParams{2}');
net.inputs{1}.processParams{2}

disp('net.outputs{2}.processFcns');
net.outputs{2}.processFcns
disp('net.outputs{2}.processParams{2}');
net.outputs{2}.processParams{2}
pause();

% 3.2 Divindindo os dados em três conjuntos
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.70;
net.divideParam.valRatio   = 0.15;
net.divideParam.testRatio  = 0.15;

% 3.3 Inicializando os Pesos da Rede
net = init(net);

%% Fase 4:
net.trainParam.showWindow = true;
net.layers{1}.dimensions  = 30;
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
