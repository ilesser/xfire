function [E,L,err]=bkm(E1,L1,bkm_mode,N)
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

   % Calculate ln() and atan() LUTs
   %n = (1:N-1)';
   %D = 9;
   %d  = [0 1 1+j j -1+j -1 -1-j -j 1-j]';
   %dx = real(d);
   %dy = imag(d);

   %ln_lut   = (1/2) * log( 1 + 2.^(-n+1) * dx +  2.^(-2*n) * (dx.^2 + dy.^2) );
   %
   %atan_lut = zeros(N,9);
   %
   %for i=1:D;
   %   atan_lut(:,i) = dy(i) * atan( 2.^(-n) ./ (1 + dx(i) * 2.^(-n) ) );
   %endfor

   % Initialize variables
   if ( strcmp(bkm_mode,"E") || strcmp(bkm_mode,"E-mode") )
      bkm_mode = "E";
      K  = length(L1);
      %E1 = ones(1,K) * E1;
   end
   if ( strcmp(bkm_mode,"L") || strcmp(bkm_mode,"L-mode") )
      bkm_mode = "L";
      K  = length(E1);
      %L1 = ones(1,K) * L1;
   end

   E = zeros(N+1,K);
   L = zeros(N+1,K);

   E(1,:) = E1;
   L(1,:) = L1;

   % Iterate on n
   for n=(1:N);

      d_n      = get_d_n( n, E(n,:), L(n,:), bkm_mode );

      E(n+1,:)   = E(n,:) .*   (1 + d_n * 2^-n);
      L(n+1,:)   = L(n,:) - log(1 + d_n * 2^-n);

   endfor


   E_ideal = E1.* exp(L1);
   L_ideal = L1 + log(E1);

   err_E   = ( E(N+1,:) - E_ideal ) ./ E_ideal;
   err_L   = ( L(N+1,:) - L_ideal ) ./ L_ideal;

   if ( bkm_mode == "E" )
      err = err_E;
   elseif ( bkm_mode == "L" )
      err = err_L;
   else
      err = -1;
   end
endfunction





function dn = get_d_n( n, En, Ln, bkm_mode )


   if ( bkm_mode == "E" )

      dxn = zeros(1, length(Ln));
      dyn = zeros(1, length(Ln));

      % Truncate 2^n * Lx after the 3rd fractional digit
      Lxn = fix(real(Ln)*2^n*2^3)/2^3;

      % Truncate 2^n * Ly after the 4th fractional digit
      Lyn = fix(imag(Ln)*2^n*2^4)/2^4;

      dxn(Lxn <= -5/8              ) = -1;
      dxn(Lxn >= -1/2 && Lxn <= 1/4) = 0;
      dxn(Lxn >=  3/8              ) =  1;

      dyn(Lyn <= -13/16            ) = -1;
      dyn(Lyn >= -3/4 && Lyn <= 3/4) = 0;
      dyn(Lyn >=  13/16            ) =  1;

   elseif ( bkm_mode == "L" )

      dxn = zeros(length(En), 1);
      dyn = zeros(length(En), 1);

      % Get the new sequence
      En  = 2^n * (En-1);

      % Truncate real and imaginary parts after their 4th fractional digit
      Exn = fix(real(En)*2^4)/2^4;
      Eyn = fix(imag(En)*2^4)/2^4;

      if     ( Exn <= -1/2 )
         dxn = 1;
      elseif ( Exn > -1/2 && Exn <= 1/2 )
         dxn = 0;
      elseif ( Exn > 1/2 )
         dxn = -1;
      end

      if     ( Eyn <= -1/2 )
         dyn = 1;
      elseif ( Eyn > -1/2 && Eyn <= 1/2 )
         dyn = 0;
      elseif ( Eyn > 1/2 )
         dyn = -1;
      end

   end

   dn = dxn + j * dyn;

end
