%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONFIGURATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of steps in the BKM algorithm
N        = 64;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% E-MODE
% E = bkm(E1,L1,E-mode,N)
% E = E1 * exp(L1) - 2^-N
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Real exponentail test
% ---------------------
%
% Calculate the real valued exponential of a vector between L1_low and L1_high
% with KL steps.
% Convergence range
% L1 € R1 = [-0.829802...; +0.868876...] + j * 0.749780 * [-1; 1]
%
% Inputs
%
KL       = 100;
L1_low   = -1.20;
L1_high  = 0.85;
E1_mul   = 1;
%
% Outputs
%
%  * L1 = linspace(L1_low, L1_high, KL)
%  * exp_L1 = E1_mul * exp(L1)
%  * err_exp_L1 the error
%  * mean_exp_L1 mean correct bits
%  * std_exp_L1 standard deviation of correct bits
%  * Plot of L1 vs bkm(E1, L1, E-mode, N)
%  * Plot of L1 vs error of bkm(E1, L1, E-mode, N)

%
% Complex exponentail test
% ---------------------
%
% Calculate the complex valued exponential of a vector inside the rectagle formed by
% [L1_low_r; L1_high_r] + j * [L1_low_i; L1_high_i] with KL steps for each direction
% i.e.: L1_c = L1_r + j * L1_i is a KLxKL matrix
% Convergence range
% L1 € R1 = [-0.829802...; +0.868876...] + j * 0.749780 * [-1; 1]
%
% Inputs
%
L1_low_r = -0.80;
L1_high_r= +0.80;
L1_low_i = -pi*15/64; % ~ -0.736...
L1_high_i= +pi*15/64; % ~ +0.736...
E1_mul_r = 1.00;
E1_mul_i = 0.00;
%
% Outputs
%
%  * L1_r = linspace(L1_low_r, L1_high_r, KL)
%  * L1_i = linspace(L1_low_i, L1_high_i, KL)
%  * L1_c = ndgrid(L1_r, L1_i)
%  * exp_L1_c = E1_mul_c * exp(L1_c)
%  * err_exp_L1_c the error
%  * mean_exp_L1_c mean correct bits
%  * std_exp_L1_c standard deviation of correct bits
%  * Plot of L1_c vs real part of exp bkm
%  * Plot of L1_c vs imag part of exp bkm
%  * Plot of L1_c vs real part of error of exp bkm
%  * Plot of L1_c vs imag part of error of exp bkm
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L-MODE
% L = bkm(E1,L1,L-mode,N)
% L = L1 + log(L1) - 2^-N
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Real logarithm test
% ---------------------
%
% Calculate the real valued logarithm of a vector between E1_low and E1_high
% with KE steps.
% Convergence range
% E1 € T  = { x,y € R / 0.64 <= x <= 1.4 and -2/5 x <= y <= 2/5 x }
%
% Inputs
%
KE       = 100;
E1_low   = 0.45;
E1_high  = 3.45;
L1_off   = 0.00;
%
% Outputs
%
%  * E1 = linspace(E1_low, E1_high, KE)
%  * log_E1 = L1_off + log(E1)
%  * err_log_E1 the error
%  * mean_log_E1 mean correct bits
%  * std_log_E1 standard deviation of correct bits
%  * Plot of E1 vs log bkm
%  * Plot of E1 vs error of log bkm

%
% Complex logarithm test
% ---------------------
%
% Calculate the complex valued logarithm of a vector inside the rectagle formed by
% [E1_low_r; E1_high_r] + j * [E1_low_i; E1_high_i] with KE steps for each direction
% i.e.: E1_c = E1_r + j * E1_i is a KExKE matrix
% Convergence range
% E1 € T  = { x,y € R / 0.64 <= x <= 1.4 and -2/5 x <= y <= 2/5 x }
%
% Inputs
%
E1_low_r = 0.60;
E1_high_r= 1.25;
E1_low_i = -E1_low_r  * 2/5;  % ~ -0.260
E1_high_i= +E1_high_r * 2/5;  % ~ +0.560
L1_off_r = 1.00;
L1_off_i = 0.00;
%
% Outputs
%
%  * E1_r = linspace(E1_low_r, E1_high_r, KE)
%  * E1_i = linspace(E1_low_i, E1_high_i, KE)
%  * E1_c = ndgrid(E1_r, E1_i)
%  * log_E1_c = L1_off_c + log(E1_c)
%  * err_log_E1_c the error
%  * mean_log_E1_c mean correct bits
%  * std_log_E1_c standard deviation of correct bits
%  * Plot of E1_c vs real part of log bkm
%  * Plot of E1_c vs imag part of log bkm
%  * Plot of E1_c vs real part of error of log bkm
%  * Plot of E1_c vs imag part of error of log bkm
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST REAL EXPONENTIAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% L1 es de 1xKL
L1       = linspace(L1_low, L1_high, KL);

% E = bkm(E1,L1,E-mode,N)
% E = E1 * exp(L1) - 2^-N
[E, L, d, err] = bkm(E1_mul, L1, 'E-mode', N);

exp_L1      = E(:,:,N+1);
err_exp_L1  = err(:,:,N+1);
bit_exp_L1  = -log2(abs(err_exp_L1));
bit_exp_L1  ( bit_exp_L1 == Inf ) = 64;
mean_exp_L1 = mean(bit_exp_L1)
std_exp_L1  = std(bit_exp_L1)

figure(1)
clf
hold on
grid on
plot(L1, exp_L1,  'b')
plot(L1, exp(L1), 'g')

figure(2)
clf
hold on
grid on
plot(L1, err_exp_L1, 'b' )
plot([L1_low L1_high], [1 1]*+2^-53, '-k')
plot([L1_low L1_high], [1 1]*-2^-53, '-k')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST REAL LOGARITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% E1 es de 1xKE
E1       = linspace(E1_low, E1_high, KE);

% L = bkm(E1,L1,L-mode,N)
% L = L1 + ln(E1) - 2^-N
[E, L, d, err] = bkm(E1, L1_off, 'L-mode', N);

log_E1      = L(:,:,N+1);
err_log_E1  = err(:,:,N+1);
bit_log_E1  = -log2(abs(err_log_E1));
bit_log_E1  ( bit_log_E1 == Inf ) = 64;
mean_log_E1 = mean(bit_log_E1)
std_log_E1  =  std(bit_log_E1)

figure(3)
clf
hold on
grid on
plot(E1, log_E1,  'b')
plot(E1, log(E1), 'g')

figure(4)
clf
hold on
grid on
plot(E1, err_log_E1, 'b')
plot([E1_low E1_high], [1 1]*+2^-53, '-k')
plot([E1_low E1_high], [1 1]*-2^-53, '-k')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST COMPLEX EXPONENTIAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% L1 es de 1xKL
L1_r     = linspace(L1_low_r, L1_high_r, KL);
L1_i     = linspace(L1_low_i, L1_high_i, KL);
E1_mul_c = E1_mul_r + j * E1_mul_i;

[LL1_r, LL1_i] = ndgrid(L1_r, L1_i);
L1_c     = LL1_r + j * LL1_i;


% E = bkm(E1,L1,E-mode,N)
% E = E1 * exp(L1) - 2^-N
[E, L, d, err] = bkm(E1_mul_c, L1_c, 'E-mode', N);

exp_L1_c       = E(:,:,N+1);
exp_L1_r       = real(exp_L1_c);
exp_L1_i       = imag(exp_L1_c);
err_exp_L1_c   = err(:,:,N+1);
err_exp_L1_r   = real(err_exp_L1_c);
err_exp_L1_i   = imag(err_exp_L1_c);
bit_exp_L1_r   = -log2(abs(err_exp_L1_r));
bit_exp_L1_i   = -log2(abs(err_exp_L1_i));
bit_exp_L1_r   ( bit_exp_L1_r == Inf ) = 64;
bit_exp_L1_i   ( bit_exp_L1_i == Inf ) = 64;
mean_exp_L1_r  = mean(mean(bit_exp_L1_r));
mean_exp_L1_i  = mean(mean(bit_exp_L1_i));
std_exp_L1_r   = std(std(bit_exp_L1_r));
std_exp_L1_i   = std(std(bit_exp_L1_i));
mean_exp_L1_c  = mean_exp_L1_r + j * mean_exp_L1_i
std_exp_L1_c   = std_exp_L1_r  + j * std_exp_L1_i

figure(5)
clf
mesh(L1_r, L1_i, exp_L1_r)
grid on
hold on
mesh(L1_r, L1_i, real(exp(L1_c)) )

figure(6)
clf
mesh(L1_r, L1_i, err_exp_L1_r)
grid on

figure(7)
clf
mesh(L1_r, L1_i, exp_L1_i)
grid on
hold on
mesh(L1_r, L1_i, imag(exp(L1_c)) )

figure(8)
clf
mesh(L1_r, L1_i, err_exp_L1_i)
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST COMPLEX LOGARITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% E1 es de 1xKE
E1_r     = linspace(E1_low_r, E1_high_r, KE);
E1_i     = linspace(E1_low_i, E1_high_i, KE);

[EE1_r, EE1_i] = ndgrid(E1_r, E1_i);
E1_c     = EE1_r + j * EE1_i;

L1_off_c = L1_off_r + j * L1_off_i;

% L = bkm(E1,L1,L-mode,N)
% L = L1 + log(E1) - 2^-N
[E, L, d, err] = bkm(E1_c, L1_off_c, 'L-mode', N);

log_E1_c       = L(:,:,N+1);
log_E1_r       = real(log_E1_c);
log_E1_i       = imag(log_E1_c);
err_log_E1_c   = err(:,:,N+1);
err_log_E1_r   = real(err_log_E1_c);
err_log_E1_i   = imag(err_log_E1_c);
bit_log_E1_r   = -log2(abs(err_log_E1_r));
bit_log_E1_i   = -log2(abs(err_log_E1_i));
bit_log_E1_r   ( bit_log_E1_r == Inf ) = 64;
bit_log_E1_i   ( bit_log_E1_i == Inf ) = 64;
mean_log_E1_r  = mean(mean(bit_log_E1_r));
mean_log_E1_i  = mean(mean(bit_log_E1_i));
std_log_E1_r   = std(std(bit_log_E1_r));
std_log_E1_i   = std(std(bit_log_E1_i));
mean_log_E1_c  = mean_log_E1_r + j * mean_log_E1_i
std_log_E1_c   = std_log_E1_r  + j * std_log_E1_i

log_E1_plot_c  = L1_off_c + log(E1_c);
log_E1_plot_r  = real(log_E1_plot_c);
log_E1_plot_i  = imag(log_E1_plot_c);

figure(9)
clf
mesh(E1_r, E1_i, log_E1_r)
grid on
hold on
mesh(E1_r, E1_i, log_E1_plot_r)

figure(10)
clf
mesh(E1_r, E1_i, err_log_E1_r)
grid on

figure(11)
clf
mesh(E1_r, E1_i, log_E1_i)
grid on
hold on
mesh(E1_r, E1_i, log_E1_plot_i)

figure(12)
clf
grid on
mesh(E1_r, E1_i, err_log_E1_i)
