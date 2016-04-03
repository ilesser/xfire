N = 64;
KE = 100;
KL = 100;

% E1 es de 1xKE
E1_low  = 0.45;
E1_high = 3.45;
E1 = linspace(E1_low, E1_high, KE);

[E, L, d, err] = bkm(E1, 0, 'L-mode', N);

log_E1   = L(:,:,N+1);
err_E1   = err(:,:,N+1);
err_E1_r = abs(real(err_E1));
err_E1_i = abs(imag(err_E1));

bit_E1_r = -log2(err_E1_r);
bit_E1_i = -log2(err_E1_i);

bit_E1_r( bit_E1_r == Inf ) = 64;
bit_E1_i( bit_E1_i == Inf ) = 64;

mean_E1_r= mean(bit_E1_r);
mean_E1_i= mean(bit_E1_i);
std_E1_r =  std(bit_E1_r);
std_E1_i =  std(bit_E1_i);

mean_E1_ = mean_E1_r + j * mean_E1_i
std_E1_  =  std_E1_r + j *  std_E1_i


figure(1)
clf
hold on
grid on
plot(E1, log_E1,  'b')
plot(E1, log(E1), 'g')

figure(2)
clf
hold on
grid on
plot(E1, err_E1_r, 'b')
plot(E1, err_E1_i, 'r')
plot([E1_low E1_high], [1 1]*+2^-53, '-k')
plot([E1_low E1_high], [1 1]*-2^-53, '-k')



% L1 es de 1xKL
L1_low  = -1.20;
L1_high = 0.85;
L1 = linspace(L1_low, L1_high, KL);

[E, L, d, err] = bkm(1, L1, 'E-mode', N);

exp_L1   = E(:,:,N+1);
err_L1   = err(:,:,N+1);
err_L1_r = abs(real(err_L1));
err_L1_i = abs(imag(err_L1));

bit_L1_r = -log2(err_L1_r);
bit_L1_i = -log2(err_L1_i);

bit_L1_r( bit_L1_r == Inf ) = 64;
bit_L1_i( bit_L1_i == Inf ) = 64;

mean_L1_r= mean(bit_L1_r);
mean_L1_i= mean(bit_L1_i);
std_L1_r = std(bit_L1_r);
std_L1_i = std(bit_L1_i);

mean_L1_ = mean_L1_r + j * mean_L1_i
std_L1_  = std_L1_r  + j * std_L1_i

figure(3)
clf
hold on
grid on
plot(L1, exp_L1,  'b')
plot(L1, exp(L1), 'g')

figure(4)
clf
hold on
grid on
plot(L1, err_L1_r, 'b' )
plot(L1, err_L1_i, 'r' )
plot([L1_low L1_high], [1 1]*+2^-53, '-k')
plot([L1_low L1_high], [1 1]*-2^-53, '-k')
