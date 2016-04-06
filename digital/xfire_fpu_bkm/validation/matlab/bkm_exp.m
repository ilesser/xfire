function [E,err]=bkm_exp(L1, N = 64)

   % E = bkm(E1,L1,E-mode,N)
   % E = E1 * exp(E1) - 2^-N
   [E_bkm, ~, ~, err_bkm] = bkm(1, L1, 'E-mode', N);
   % E = bkm(1,L1,E-mode,N)
   % E = exp(L1) - 2^-N

   E     = E_bkm(:,:,N+1);
   err   = err_bkm(:,:,N+1);

end

