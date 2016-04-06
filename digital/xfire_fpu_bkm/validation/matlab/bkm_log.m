function [L,err]=bkm_log(E1, N = 64)

   % L = bkm(E1,L1,L-mode,N)
   % L = L1 + log(E1) - 2^-N
   [~, L_bkm, ~, err_bkm] = bkm(E1, 0, 'L-mode', N);
   % L = bkm(E1,0,L-mode,N)
   % L = log(E1) - 2^-N

   L     = L_bkm(:,:,N+1);
   err   = err_bkm(:,:,N+1);

end
