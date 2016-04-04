function [E,L,d,err]=bkm(E1, L1, bkm_mode , N )
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
   % Fill in unset optional values.
   switch nargin
      case 0
         E1       = 0;
         L1       = 0;
         bkm_mode = 'E';
         N        = 64;
      case 1
         L1       = 0;
         bkm_mode = 'E';
         N        = 64;
      case 2
         bkm_mode = 'E';
         N        = 64;
      case 3
         N        = 64;
   end


   % Check for bkm_mode
   if ( strcmp(bkm_mode,'E') || strcmp(bkm_mode,'E-mode') )
      bkm_mode = 'E';
   elseif ( strcmp(bkm_mode,'L') || strcmp(bkm_mode,'L-mode') )
      bkm_mode = 'L';
   else
      error('%s is not a recognized bkm_mode. You can use {E, E-mode, L, L-mode}',bkm_mode)
   end

   if( isvector(E1) )
      if( isvector(L1) )
         % If both of them are vectores then I have to create the matrix
         K1 = length(E1);
         K2 = length(L1);
         % EE1 and LL1 are size KExKL = K1xK2
         [EE1, LL1] = ndgrid(E1, L1);
      else
         if( length(E1) > 1 )
            % If L1 is a matrix and E1 a vector
            error('Cannot use a matrix and a vector.\n')
            exit
         else
            % If L1 is a matrix and E1 is a number
            [K1, K2]  = size(L1);
            EE1 = E1 * ones(K1,K2);
            LL1 = L1;
         end
      end
   else
      if( length(L1) > 1 )
            % If E1 is a matrix and L1 a vector
            error('Cannot use a matrix and a vector.\n')
            exit
      else
         % If E1 is a matrix and L1 is a number
         [K1, K2]  = size(E1);
         EE1 = E1;
         LL1 = L1 * ones(K1,K2);
      end

   end

   % d is size K1xK2xN
   d = zeros(K1,K2,N);

   % E and L are size K1xK2xN+1
   E = zeros(K1,K2,N+1);
   L = zeros(K1,K2,N+1);

   % Initialize first step
   E(:,:,1) = EE1;
   L(:,:,1) = LL1;


   % Iterate on n
   for n=(1:N);

      d(:,:,n)    = get_d_n( n, E(:,:,n), L(:,:,n), bkm_mode );

      E(:,:,n+1)  = E(:,:,n) .*   (1 + d(:,:,n) * 2^-n);
      L(:,:,n+1)  = L(:,:,n) - log(1 + d(:,:,n) * 2^-n);

   end

   % Disable broadcasting warning to calculate the error
   %warning ("off", "Octave:broadcast");

   % Calculate error vs ideal value
   if ( bkm_mode == 'E' )
      E_ideal  = repmat( EE1.* exp(LL1), [1 1 N+1]);
      err      = ( E - E_ideal ) ;
   elseif ( bkm_mode == 'L' )
      L_ideal  = repmat( LL1 + log(EE1), [1 1 N+1]);
      err      = ( L - L_ideal ) ;
   end

   % Enable broadcasting warning again
   %warning ("on", "Octave:broadcast");

end

function dn = get_d_n( n, En, Ln, bkm_mode )

   [K1, K2] = size(En);

   drn = zeros(K1,K2);
   din = zeros(K1,K2);

   if ( bkm_mode == 'E' )

      % Truncate 2^n * Lx after the 3rd fractional digit
      Lrn = fix(real(Ln)*2^n*2^3)/2^3;

      % Truncate 2^n * Ly after the 4th fractional digit
      Lin = fix(imag(Ln)*2^n*2^4)/2^4;

      drn(Lrn <= -5/8              ) = -1;
      drn(Lrn >= -1/2 & Lrn <= 1/4 ) =  0;
      drn(Lrn >=  3/8              ) = +1;

      din(Lin <= -13/16            ) = -1;
      din(Lin >= -3/4 & Lin <= 3/4 ) =  0;
      din(Lin >=  13/16            ) = +1;

   elseif ( bkm_mode == 'L' )

      % Get the new sequence
      En;
      en  = 2^n * (En-1);

      % Truncate real and imaginary parts after their 4th fractional digit
      ern = fix(real(en)*2^4)/2^4;
      ein = fix(imag(en)*2^4)/2^4;

      drn(ern <= -1/2              ) = +1;
      drn(ern >  -1/2 & ern <= 1/2 ) =  0;
      drn(ern >   1/2              ) = -1;

      din(ein <= -1/2              ) = +1;
      din(ein >  -1/2 & ein <= 1/2 ) =  0;
      din(ein >   1/2              ) = -1;

   end

   dn = drn + j * din;

end
