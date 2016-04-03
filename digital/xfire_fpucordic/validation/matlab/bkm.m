function [E,L,err]=bkm(E1, L1, bkm_mode = 'E', N = 64)
% Runs the N steps BKM algorithm for the specified mode with inputs E1 and L1.
%
% These are the steps:
%
%     E_{n+1} = E_n * ( 1 + d_n * 2^-n )
%     L_{n+1} = L_n - ln( 1 + d_n * 2-n )
%
% With n = 1,2,...,N, j^2 = -1 y d_n € {0, +-1, +-j, +-1+-j }
% E1 and L1 are row complex vectors within the convergence range.
% For E-mode the converge range is:
%
%     L1 € R1 = [-0.829802...; +0.868876...] + j * 0.749780 * [-1; 1]
%
% After N iterations we have:
%
%     E_{N+1} --> E1 * exp(L1)
%     L_{N+1} --> 0
%
% For L-mode the converge range is:
%
%     Old way from BKM94
%     E1 € T  = { x,y € R /  1/2 <= x <= 1.3 and   -x/2 <= y <= x/2 }
%
%     New way from newBKM
%     E1 € T  = { x,y € R / 0.64 <= x <= 1.4 and -2/5 x <= y <= 2/5 x }
%     TODO: fix references
%
% After N iterations we have:
%
%     E_{N+1} --> 1
%     L_{N+1} --> L1 + ln(E1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Initialize variables
   if ( strcmp(bkm_mode,'E') || strcmp(bkm_mode,'E-mode') )
      bkm_mode = 'E';
   elseif ( strcmp(bkm_mode,'L') || strcmp(bkm_mode,'L-mode') )
      bkm_mode = 'L';
   else
      display 'Error: Unrecognized bkm_mode argument.'
      exit
   end

   % Find out E1 and L1 lengths
   KE = length(E1);
   KL = length(L1);

   % EE1 and LL1 are size KLxKE
   [EE1, LL1] = meshgrid(E1, L1);

   % E and L are size KLxKExN+1
   E = zeros(KL,KE,N+1);
   L = zeros(KL,KE,N+1);

   E(:,:,1) = EE1;
   L(:,:,1) = LL1;


   % Iterate on n
   for n=(1:N);

      d_n         = get_d_n( n, E(:,:,n), L(:,:,n), bkm_mode );

      E(:,:,n+1)  = E(:,:,n) .*   (1 + d_n * 2^-n);
      L(:,:,n+1)  = L(:,:,n) - log(1 + d_n * 2^-n);

   endfor

   % Calculate error vs ideal value
   if ( bkm_mode == 'E' )
      E_ideal  = EE1.* exp(LL1);
      %err     = ( E(:,:,N+1) - E_ideal ) ./ E_ideal;
      %err     = ( E(:,:,N+1) - E_ideal ) ;
      err      = ( E - E_ideal ) ;
   elseif ( bkm_mode == 'L' )
      L_ideal  = LL1 + log(EE1);
      %err     = ( L(:,:,N+1) - L_ideal ) ./ L_ideal;
      %err     = ( L(:,:,N+1) - L_ideal ) ;
      err      = ( L - L_ideal ) ;
   else
      err = -1;
   end

endfunction

function dn = get_d_n( n, En, Ln, bkm_mode )

   [KL, KE] = size(En);

   drn = din = zeros(KL,KE);

   if ( bkm_mode == 'E' )

      % Truncate 2^n * Lx after the 3rd fractional digit
      Lrn = fix(real(Ln)*2^n*2^3)/2^3;

      % Truncate 2^n * Ly after the 4th fractional digit
      Lin = fix(imag(Ln)*2^n*2^4)/2^4;

      drn(Lrn <= -5/8              ) = -1;
      drn(Lrn >= -1/2 && Lrn <= 1/4) =  0;
      drn(Lrn >=  3/8              ) = +1;

      din(Lin <= -13/16            ) = -1;
      din(Lin >= -3/4 && Lin <= 3/4) =  0;
      din(Lin >=  13/16            ) = +1;

   elseif ( bkm_mode == 'L' )

      % Get the new sequence
      En
      en  = 2^n * (En-1)

      % Truncate real and imaginary parts after their 4th fractional digit
      ern = fix(real(en)*2^4)/2^4
      ein = fix(imag(en)*2^4)/2^4

      drn(ern <= -1/2              ) = +1;
      drn(ern >  -1/2 && ern <= 1/2) =  0;
      drn(ern >   1/2              ) = -1;

      din(ein <= -1/2              ) = +1;
      din(ein >  -1/2 && ein <= 1/2) =  0;
      din(ein >   1/2              ) = -1;

   end

   dn = drn + j * din
   display ''

end
