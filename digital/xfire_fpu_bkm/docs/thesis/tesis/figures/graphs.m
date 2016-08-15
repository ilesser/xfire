%------------------------------------------------------------------------------
% Nombre:		graphs.m
% Autor/es:		Federico Camarda
% Fecha:		20/04/2015
% Descripcion:	Gráficos de resultados de tesis.
%------------------------------------------------------------------------------

% Se inicializa el sistema.
clc;                % Se borra la terminal.
clear all;  		% Se borran las variables.
close all;      	% Se cierran archivos y ventanas abiertas.

% Graphs default parameters.
width  = 7.0;       % Width in inches
height = 4.5;       % Height in inches
lw     = 8;         % LineWidth
msz    = 6;         % MarkerSize

% Figure's properties.
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz

% Set the default Size for display
defpos = get(0,'defaultFigurePosition');
set(0,'defaultFigurePosition', [defpos(1) defpos(2) width*100, height*100]);

% Set the defaults for saving/printing to a file
set(0,'defaultFigureInvertHardcopy','on'); % This is the default anyway
set(0,'defaultFigurePaperUnits','inches'); % This is the default anyway
defsize = get(gcf, 'PaperSize');
left = (defsize(1)- width)/2;
bottom = (defsize(2)- height)/2;
defsize = [left, bottom, width, height];
set(0, 'defaultFigurePaperPosition', defsize);

%------------------------------------------------------------------------------
%  Parametros de sintesis de FPGA. Cada columna del vector responde a los
%         resultados para 8 bits, 10 bits, 12 bits y 14 bits.
%------------------------------------------------------------------------------

% Bits.
bits_index          = [ 8 , 12 , 16 ];

% Max. Operation Clock in MHz:
max_clock_virtex7   = [ 133.806, 121.522, 119.202 ];
max_clock_artix7    = [ 104.461, 89.314, 87.563   ];
max_clock_spartan6  = [ 74.425, 71.398, 70.332    ];
max_clock_spartan3E = [ 41.120, 39.336, 39.503    ];

figure(1);
hold on;
plot(bits_index, max_clock_virtex7,   '-s',  'Color',[0,0.7,0.9]);
plot(bits_index, max_clock_artix7,    '--s', 'Color',[0.9,0.7,0]);
plot(bits_index, max_clock_spartan6,  ':s',  'Color',[0.1,0.7,0.3]);
plot(bits_index, max_clock_spartan3E, '-.s', 'Color',[0.9,0,0.3]);
hold off;
grid on;
grid minor;
title('Maximum Clock');
legend('Virtex7', 'Artix7', 'Spartan6', 'Spartan3E');
ylabel('Frequency [MHz]');
xlabel('Word Width [Bits]');
print -depsc C05-max_clock.eps

% Max. Operation Clock in MHz:
for i = 1:3
   throughput_virtex7(i)   = max_clock_virtex7(i) / (11 + bits_index(i) * 7);
   throughput_artix7(i)    = max_clock_artix7(i) / (11 + bits_index(i) * 7);
   throughput_spartan6(i)  = max_clock_spartan6(i) / (11 + bits_index(i) * 7);
   throughput_spartan3E(i) = max_clock_spartan3E(i) / (11 + bits_index(i) * 7);
end

figure(2);
hold on;
plot(bits_index, throughput_virtex7,   '-s',  'Color',[0,0.7,0.9]);
plot(bits_index, throughput_artix7,    '--s', 'Color',[0.9,0.7,0]);
plot(bits_index, throughput_spartan6,  ':s',  'Color',[0.1,0.7,0.3]);
plot(bits_index, throughput_spartan3E, '-.s', 'Color',[0.9,0,0.3]);
hold off;
grid on;
grid minor;
title('Throughput');
legend('Virtex7', 'Artix7', 'Spartan6', 'Spartan3E');
ylabel('Throughput [MSamples / s]');
xlabel('Word Width [Bits]');
print -depsc C05-throughput.eps

% Update delay in mili seconds.
delay_virtex7   = 1 ./ throughput_virtex7;
delay_artix7    = 1 ./ throughput_artix7;
delay_spartan6  = 1 ./ throughput_spartan6;
delay_spartan3E = 1 ./ throughput_spartan3E;

figure(3);
hold on;
plot(bits_index, delay_virtex7,   '-s',  'Color',[0,0.7,0.9]);
plot(bits_index, delay_artix7,    '--s', 'Color',[0.9,0.7,0]);
plot(bits_index, delay_spartan6,  ':s',  'Color',[0.1,0.7,0.3]);
plot(bits_index, delay_spartan3E, '-.s', 'Color',[0.9,0,0.3]);
hold off;
grid on;
grid minor;
title('Update delay');
legend('Virtex7', 'Artix7', 'Spartan6', 'Spartan3E','Location','northwest');
ylabel('Update delay [\mus]');
xlabel('Word Width [Bits]');
print -depsc C05-delay.eps

% Latency in mili seconds.
latency_virtex7   = 8 ./ throughput_virtex7;
latency_artix7    = 8 ./ throughput_artix7;
latency_spartan6  = 8 ./ throughput_spartan6;
latency_spartan3E = 8 ./ throughput_spartan3E;

figure(4);
hold on;
plot(bits_index, latency_virtex7,   '-s',  'Color',[0,0.7,0.9]);
plot(bits_index, latency_artix7,    '--s', 'Color',[0.9,0.7,0]);
plot(bits_index, latency_spartan6,  ':s',  'Color',[0.1,0.7,0.3]);
plot(bits_index, latency_spartan3E, '-.s', 'Color',[0.9,0,0.3]);
hold off;
grid on;
grid minor;
title('Latency');
legend('Virtex7', 'Artix7', 'Spartan6', 'Spartan3E','Location','northwest');
ylabel('Latency [\mus]');
xlabel('Word Width [Bits]');
print -depsc C05-latency.eps

% 4 input LUTs
luts_virtex7   = [ 2257, 2619, 3560 ];
luts_artix7    = [ 2218, 2640, 3554 ];
luts_spartan6  = [ 2309, 2699, 3564 ];
luts_spartan3E = [ 3539, 5299, 7053 ];

figure(5);
hold on;
plot(bits_index, luts_virtex7,   '-s',  'Color',[0,0.7,0.9]);
plot(bits_index, luts_artix7,    '--s', 'Color',[0.9,0.7,0]);
plot(bits_index, luts_spartan6,  ':s',  'Color',[0.1,0.7,0.3]);
plot(bits_index, luts_spartan3E, '-.s', 'Color',[0.9,0,0.3]);
hold off;
grid on;
grid minor;
title('Number of Xilinx LUTs used');
legend('Virtex7', 'Artix7', 'Spartan6', 'Spartan3E','Location','northwest');
ylabel('LUTs');
xlabel('Word Width [Bits]');
print -depsc C05-luts.eps

% flip flops.
ff_virtex7   = [ 2323, 3076, 4119 ];
ff_artix7    = [ 2612, 3172, 4269 ];
ff_spartan6  = [ 2647, 3184, 4313 ];
ff_spartan3E = [ 1211, 1793, 2310 ];

figure(6);
hold on;
plot(bits_index, ff_virtex7,   '-s',  'Color',[0,0.7,0.9]);
plot(bits_index, ff_artix7,    '--s', 'Color',[0.9,0.7,0]);
plot(bits_index, ff_spartan6,  ':s',  'Color',[0.1,0.7,0.3]);
plot(bits_index, ff_spartan3E, '-.s', 'Color',[0.9,0,0.3]);
hold off;
grid on;
grid minor;
title('Number of Flip Flops used');
legend('Virtex7', 'Artix7', 'Spartan6', 'Spartan3E','Location','northwest');
ylabel('FFs');
xlabel('Word Width [Bits]');
print -depsc C05-ffs.eps

% Slices.
slices_virtex7   = [ 636,  967,  1306 ];
slices_artix7    = [ 1002, 1036, 1783 ];
slices_spartan6  = [ 794,  1004, 1329 ];
slices_spartan3E = [ 1903, 2856, 3813 ];

figure(7);
hold on;
plot(bits_index, slices_virtex7,   '-s',  'Color',[0,0.7,0.9]);
plot(bits_index, slices_artix7,    '--s', 'Color',[0.9,0.7,0]);
plot(bits_index, slices_spartan6,  ':s',  'Color',[0.1,0.7,0.3]);
plot(bits_index, slices_spartan3E, '-.s', 'Color',[0.9,0,0.3]);
hold off;
grid on;
grid minor;
title('Number of Slices used');
legend('Virtex7', 'Artix7', 'Spartan6', 'Spartan3E','Location','northwest');
ylabel('Slices');
xlabel('Word Width [Bits]');
print -depsc C05-slices.eps

% % Obtencion del numero de iteraciones.
% fid = fopen('hardware_result_matlab.dat', 'rb');
% fseek(fid, 0, 'eof');
% fileSize = ftell(fid);
% frewind(fid);
% data = fread(fid, fileSize, 'uint8');
% numLines = sum(data == 10) + 1
% fclose(fid);
% 
% % Numero de iteraciones.
% I = (numLines-1)/7;
% 
% % Indice.
% index = [1:I];

%------------------------------------------------------------------------------
%                     Resultados de computo de matrices.
%------------------------------------------------------------------------------

%% Lectura de vectores de entrada para 16 bits.
%for i=1:I
%   input_vector_16(1,:,i)=dlmread('input_vector.dat',' ',[(i-1)*7 0 (i-1)*7+6 0]);
%end
%
%% Lectura de matriz con resultados de software para 16 bits.
%for i=1:I
%   soft_matrix_16(:,:,i)=dlmread('software_result_matlab.dat',' ',[(i-1)*7 0 (i-1)*7+6 6]);
%end
%
%% Lectura de matriz con resultados de hardware para 16 bits.
%for i=1:I
%   hard_matrix_16(:,:,i)=dlmread('hardware_result_matlab.dat',' ',[(i-1)*7 0 (i-1)*7+6 6]);
%end

% Computo de matriz de error para 16 bits.
%error_matrix_16 = soft_matrix_16 - hard_matrix_16;

% Gráfico del error maximo.
%error_max_16 = max(max(error_matrix_16));
%figure;
%plot((1:I),error_max_16);

% Grafico de valor maximo de ciclos de clock.
%figure;
%plot(bits,max_clock_virtex7,'-.s',...
%     bits, max_clock_kintex7,'-.s',...
%     bits, max_clock_artix7,'-.s',...
%     bits, max_clock_spartan6,'-.s',...
%     'LineWidth',2,...
%     'MarkerFaceColor',[0.5,0.5,0.5],...
%     'MarkerEdgeColor',[0.1,0.1,0.1])
%     %'MarkerSize',5)
%title('Máximo valor de Clock');
%xlabel('N° de bits de ancho de palabra');
%ylabel('Valor [mSeg]');

