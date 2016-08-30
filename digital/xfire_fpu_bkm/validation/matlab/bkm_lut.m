function [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N, WD, WC, WI)
%-------------------------------------------------------------------------------
% Generates the BKM lut constants.
%
%     TODO: add doc
%
%-------------------------------------------------------------------------------

   % Version and date
   version = '1.0';
   version_date = 'Monday 29 August 2016';

   % Initialize variables
   % Fill in unset optional values.
   switch nargin
      case 0
         N        = 64;
         WD       = 73;
         WC       = 21;
         WI       = 11;
      case 1
         WD       = 73;
         WC       = 21;
         WI       = 11;
      case 2
         WC       = 21;
         WI       = 11;
      case 3
         WI       = 11;
   end

   %---------------------------------------------------------------
   % Calculate the LUT
   %---------------------------------------------------------------
   n  = (1:N)';

   % the posible values for d are {0, +-1} + j {0, +-1}
   d  = [ 0 1 -0 -1 j 1+j j -1+j 0 1 -0 -1 -j 1-j -j -1-j];

   % TODO: implement this to reduce memory space
   % Since the real part has simmetry with respecto to di
   % we could reduce these values to:
   %d  = [ -1 -1+j  0 +j  +1  +1-j];

   lut   = log(1+2.^-n*d);
   lut_x = real(lut);
   lut_y = imag(lut);
   lut_u = lut_x .* repmat( 2.^(n+1), 1, length(d) );
   lut_v = lut_y .* repmat( 2.^(n+1), 1, length(d) );

   %     -0.69315 <= lut_x <= 0.45815        ---+
   %        -pi/4 <= lut_y <= pi/4 = 0.7854     |----> 3 bits for integer part   ==>  -4,-3,-2,-1,0,1,2,3
   %     -2.77260 <= lut_u <= 2.00              |----> 53 bits for decimal part  ==>   0 .... 1-2^-53
   %          -pi <= lut_v <= pi = 3.1416    ---+
   %---------------------------------------------------------------

   %---------------------------------------------------------------
   % Write them to a file
   %---------------------------------------------------------------
   fid = fopen('../../rtl/source/lut_constants.vh', 'w');

   % Write a header
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   fprintf( fid, '//\n');
   fprintf( fid, '// BKM LUT automatically generated on %s\n', strftime ("%r (%Z) %A %e %B %Y", localtime (time ())) );
   fprintf( fid, '// using the bkm_lut.m function. Version = %s, from %s.\n', version, version_date );
   fprintf( fid, '// Parameters:\n');
   fprintf( fid, '// Number of steps of the algorithm:   N  = %d\n', N);
   fprintf( fid, '// Word size of the data channel:      WD = %d\n', WD);
   fprintf( fid, '// Word size of the control channel:   WC = %d\n', WC);
   fprintf( fid, '// Integer word size:                  WI = %d\n', WI);
   fprintf( fid, '//\n');
   fprintf( fid, '//--------------------------------------------------------------------------------\n');

   % TODO: write a header for lut_x
   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign X[4\'b%s] [%02d] = %d\'h %037s;  // %+6.16f", dec2bin(i-1, 4), n, 2*WD, dec2csd_hex( lut_x(n, i), WI, WD-WI , 37 ) , lut_x(n,i) );
         fprintf( fid, ' = 0.5 * ln( 1 + % d * 2^(-%d+1) + (% d^2+% d^2) * 2^(-2*%d) )', real(d(i)), n, real(d(i)), imag(d(i)), n );
         fprintf( fid, '   n = %2d   d_n = %s \n', n, num2str(d(i)) );
      end
   end

   % TODO: write a header for lut_y
   % TODO: this one has "Insufficient precision to represent this number! if n>=64"
   %        porque al hacer la cuenta csdigit() necesita al menos 64 bits de precision
   %        entnoces lo q hay q hacer es convertir con 64 bits de precision y despues tomar los primeros WD-WI
   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign Y[4\'b%s] [%02d] = %d\'h %037s;  // %+6.16f", dec2bin(i-1, 4), n, 2*WD, dec2csd_hex( lut_y(n,i), WI, WD-WI , 37 ) , lut_y(n,i) );
         fprintf( fid, ' = % d * atan( 1 / ( % d + 2^%d ) )', imag(d(i)), real(d(i)), n );
         fprintf( fid, '   n = %2d   d_n = %s \n', n, num2str(d(i)) );
      end
   end

   % TODO: write a header for lut_u
   % TODO: this one has "Insufficient precision to represent this number! > 12"
   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign u[4\'b%s] [%02d] = %d\'h %07s;  // %+6.16f", dec2bin(i-1, 4), n, WC, dec2csd_hex( lut_u(n,i), WI, WC-WI , 7 ) , lut_u(n,i) );
         fprintf( fid, ' = 2^%2d * ln( 1 + % d * 2^(-%2d+1) + (% d^2+% d^2) * 2^(-2*%2d) )', n, real(d(i)), n, real(d(i)), imag(d(i)), n );
         fprintf( fid, '   n = %2d   d_n = %s \n', n, num2str(d(i)) );
      end
   end

   % TODO: write a header for lut_v
   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign v[4\'b%s] [%02d] = %d\'h %07s;  // %+6.16f", dec2bin(i-1, 4), n, WC, dec2csd_hex( lut_v(n,i), WI, WC-WI , 7 ) , lut_v(n,i) );
         fprintf( fid, ' = 2^%d * % d * atan( 1 / ( % d + 2^%d ) )', n, imag(d(i)), real(d(i)), n );
         fprintf( fid, '   n = %2d   d_n = %s \n', n, num2str(d(i)) );
      end
   end

   fclose(fid);
   %---------------------------------------------------------------
end

function [dx_bin, dy_bin]=get_d(i)

   str = dec2bin(i, 4);
   dy_bin = str(1:2);
   dx_bin = str(3:4);

end
