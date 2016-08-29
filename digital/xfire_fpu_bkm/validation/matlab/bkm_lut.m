function [lut_r, lut_i]=bkm_lut(N,W,max_val)
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Initialize variables
   % Fill in unset optional values.
   switch nargin
      case 0
         N        = 64;
         W        = 64;
         max_val  = 4;
      case 1
         W        = 64;
         max_val  = 4;
      case 2
         max_val  = 4;
   end

   if ( W > 0 && W <= 8 )
      lut_class = 'int8';
   elseif ( W > 8  && W <= 16 )
      lut_class = 'int16';
   elseif ( W > 16 && W <= 32 )
      lut_class = 'int32';
   elseif ( W > 32 && W <= 64 )
      lut_class = 'int64';
   end


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Calculate the real part of the LUT
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   n  = (1:N)';

   % The posible values for d are {0, +-1} + j {0, +-1}
   % d = dr + j di
   % being dr the real part and di the imaginary part
   d  = [ -1 -1-j -1+j  0  -j  +j  +1  +1-j +1-j];

   % real( ln(1+2^(-n)*d) = (1/2) * ln( 1 + dr * 2^(-n+1) - ( dr^2 + di^2 ) * 2^(-2n) )

   % real( ln(1+2^(-n)*( 1+j)) = real( ln(1+2^(-n)*( 1-j))
   % real( ln(1+2^(-n)*( 0+j)) = real( ln(1+2^(-n)*( 0-j))
   % real( ln(1+2^(-n)*(-1+j)) = real( ln(1+2^(-n)*(-1-j))
   % real( ln(1+2^(-n)*( 0+0)) = 1 for all n

   % Since the real part has simmetry with respecto to di
   % we could reduce these values to:
   d  = [ -1 -1+j  0 +j  +1  +1-j];

   dr = real(d);
   di = imag(d);

   lut_r_float = (1/2) * log( 1 + 2.^(-n+1) * dr +  2.^(-2*n) * (dr.^2 + di.^2) );

   % If n > N/2 then real( ln(1+2^(-n)*d) = dr * 2^-n with only 1 bit of error

   lut_r = (lut_r_float / max_val * 2^(W-1));

   lut_r = cast( lut_r, lut_class);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Calculate the real part of the LUT
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % The posible values for d are {0, +-1} + j {0, +-1}
   % d = dr + j di
   % being dr the real part and di the imaginary part
   d  = [ -1 -1-j -1+j  0  -j  +j  +1  +1-j +1-j];

   % imag( ln(1+2^(-n)*d) = di * atan( (2^-n)/(1+dr*2^-n) )

   % Since the imaginary part only depends on dr (we can invert the result in the hardware)
   % we could reduce these valures to:
   d = [-1 0 1];

   lut_i_float = atan( 2.^(-n)*ones(1,3)./(1+2.^(-n)*d) );


   % If n > N/2 then imag( ln(1+2^(-n)*d) = 2^-n with only 1 bit of error

   lut_i = (lut_i_float / max_val * 2^(W-1));

   lut_i = cast( lut_i, lut_class);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %TODO: write them to a file
   % ln_lut_c es de NxD
   %ln_lut_c = log( 1 + 2.^(-n) * d );

   %ln_lut_x = real(ln_lut_c);
   %ln_lut_y = imag(ln_lut_c);
   %ln_lut_r = (1/2) * log( 1 + 2.^(-n+1) * dx +  2.^(-2*n) * (dx.^2 + dy.^2) );
   %ln_lut_i = atan( 2.^(-n)./(1+dx*2.^(-n)) ) * dy;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
