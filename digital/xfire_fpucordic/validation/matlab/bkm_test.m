N = 64;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST REAL EXPONENTIAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% L1 es de 1xKL
KL       = 100;
L1_low   = -1.20;
L1_high  = 0.85;
L1       = linspace(L1_low, L1_high, KL);

% E = bkm(E1,L1,E-mode,N)
% E = E1 * exp(L1) - 2^-N
[E, L, d, err] = bkm(1, L1, 'E-mode', N);

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
KE       = 100;
E1_low   = 0.45;
E1_high  = 3.45;
E1       = linspace(E1_low, E1_high, KE);

% L = bkm(E1,L1,L-mode,N)
% L = L1 + ln(E1) - 2^-N
[E, L, d, err] = bkm(E1, 0, 'L-mode', N);

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
KL       = 100;
% Convergence range
% L1 € R1 = [-0.829802...; +0.868876...] + j * 0.749780 * [-1; 1]
L1_low_r = -0.80;
L1_high_r= +0.80;
L1_low_i = -pi*15/64; % ~ +0.736...
L1_high_i= +pi*15/64; % ~ -0.736...
L1_low_i = +0.746;
L1_high_i= -0.746;
L1_r     = linspace(L1_low_r, L1_high_r, KL);
L1_i     = linspace(L1_low_i, L1_high_i, KL);

[LL1_r, LL1_i] = ndgrid(L1_r, L1_i);
L1_c     = LL1_r + j * LL1_i;


% E = bkm(E1,L1,E-mode,N)
% E = E1 * exp(L1) - 2^-N
[E, L, d, err] = bkm(1, L1_c, 'E-mode', N);

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
