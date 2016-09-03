function [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N, WD, WC, WI, file_name)
%-------------------------------------------------------------------------------
% Generates the BKM lut constants.
%
% [lut_x, lut_y, lut_u, lut_v]=bkm_lut()
% [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N)
% [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N, WD)
% [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N, WD, WC)
% [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N, WD, WC, WI)
% [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N, WD, WC, WI, file_name)
%
%  Default values
%     N           = 64;    BKM steps.
%     WD          = 73;    Data channel word size.
%     WC          = 21;    Control channel word size.
%     WI          = 11;    Integer word size.
%     file_name   = '../../rtl/source/lut_constants.vh';
%
%
%
%
%
%     TODO: add doc
%
%-------------------------------------------------------------------------------

   % Version and date
   version = '1.1';
   version_date = 'Saturday 03 September 2016';

   % Initialize variables
   % Fill in unset optional values.
   switch nargin
      case 0
         N           = 64;
         WD          = 73;
         WC          = 21;
         WI          = 11;
         file_name   = '../../rtl/source/lut_constants.vh';
      case 1
         WD          = 73;
         WC          = 21;
         WI          = 11;
         file_name   = '../../rtl/source/lut_constants.vh';
      case 2
         WC          = 21;
         WI          = 11;
         file_name   = '../../rtl/source/lut_constants.vh';
      case 3
         WI          = 11;
         file_name   = '../../rtl/source/lut_constants.vh';
      case 4
         file_name   = '../../rtl/source/lut_constants.vh';
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

   % lo llevo a [-1;1)
   lut_x_hex = lut_x / 2^(WI-1);
   lut_y_hex = lut_y / 2^(WI-1);
   lut_u_hex = lut_u / 2^(WI-1);
   lut_v_hex = lut_v / 2^(WI-1);
   % lo llevo a [0;2)
   lut_x_hex = lut_x_hex + (lut_x_hex < 0) * 2;
   lut_y_hex = lut_y_hex + (lut_y_hex < 0) * 2;
   lut_u_hex = lut_u_hex + (lut_u_hex < 0) * 2;
   lut_v_hex = lut_v_hex + (lut_v_hex < 0) * 2;

   % si quiero WD bits esto lo lleva a [0; 2^WD)
   lut_x_hex = lut_x_hex * 2^(WD-1);
   lut_y_hex = lut_y_hex * 2^(WD-1);

   % si quiero WC bits esto lo lleva a [0; 2^WC)
   lut_u_hex = lut_u_hex * 2^(WC-1);
   lut_v_hex = lut_v_hex * 2^(WC-1);

   lut_x_hex = fix(lut_x_hex);
   lut_y_hex = fix(lut_y_hex);
   lut_u_hex = fix(lut_u_hex);
   lut_v_hex = fix(lut_v_hex);

   %     -0.69315 <= lut_x <= 0.45815        ---+
   %        -pi/4 <= lut_y <= pi/4 = 0.7854     |----> 3 bits for integer part   ==>  -4,-3,-2,-1,0,1,2,3
   %     -2.77260 <= lut_u <= 2.00              |----> 53 bits for decimal part  ==>   0 .... 1-2^-53
   %          -pi <= lut_v <= pi = 3.1416    ---+
   %---------------------------------------------------------------

   %---------------------------------------------------------------
   % Write them to a file
   %---------------------------------------------------------------
   fid = fopen(file_name, 'w');

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
   z_hex_size = ceil(WD/4);      %  73 bits -->  73/4 = 18.25 < 19
   z_csd_size = ceil(2*WD/4);    % 146 bits --> 146/4 = 36.50 < 37
   fprintf( fid, '//\n');
   fprintf( fid, '//\n');
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   fprintf( fid, '// This LUT uses %d bits which represent %d CSD digits. \n', 2*WD, WD);
   fprintf( fid, '// They are represented by %d hexadecimal digits. \n', z_csd_size);
   fprintf( fid, '// After the LUT value you have the digital representation in %d hexadecimal digits. \n', z_hex_size);
   fprintf( fid, '// Bear in mind that the first hexa digit is only 1 bit wide.\n');
   fprintf( fid, '// Since we use %d bits for the integer part then the first 3,5 hexa digits represent the integer part. \n', WI);
   fprintf( fid, '// The rest %2.1f hexa digits represent the fractional part.\n', z_hex_size-3.5 );
   fprintf( fid, '// Example:\n');
   for x=2.^(WI-n');
      fprintf( fid, "//sign X[4\'bXXXX] [XX] = %d\'h %s;  // %s %+6.16f\n", ...
                                             2*WD, ...
                                                      dec2csd_hex( x, WI, WD-WI , z_csd_size ) , ...
                                                            dec2hex( fix(x*2^(WD-WI)), z_hex_size ), ...
                                                                  x );
   end
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   fprintf( fid, '//\n');

   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign X[4\'b%s] [%02d] = %d\'h %s;  // %s %+6.16f", dec2bin(i-1, 4), n-1, 2*WD, dec2csd_hex( lut_x(n, i), WI, WD-WI , z_csd_size ) , dec2hex( lut_x_hex(n,i), z_hex_size ), lut_x(n,i) );
         fprintf( fid, ' = 0.5 * ln( 1 + % d * 2^(-%d+1) + (% d^2+% d^2) * 2^(-2*%d) )', real(d(i)), n, real(d(i)), imag(d(i)), n );
         fprintf( fid, '   n = %2d   d_n = %s \n', n, num2str(d(i)) );
      end
   end

   fprintf( fid, '//\n');
   fprintf( fid, '//\n');
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   fprintf( fid, '// This LUT uses %d bits which represent %d CSD digits. \n', 2*WD, WD);
   fprintf( fid, '// They are represented by %d hexadecimal digits. \n', z_csd_size);
   fprintf( fid, '// After the LUT value you have the digital representation in %d hexadecimal digits. \n', z_hex_size);
   fprintf( fid, '// Bear in mind that the first hexa digit is only 1 bit wide.\n');
   fprintf( fid, '// Since we use %d bits for the integer part then the first 3,5 hexa digits represent the integer part. \n', WI);
   fprintf( fid, '// The rest %2.1f hexa digits represent the fractional part.\n', z_hex_size-3.5 );
   fprintf( fid, '// Example:\n');
   for x=2.^(WI-n');
      fprintf( fid, "//sign X[4\'bXXXX] [XX] = %d\'h %s;  // %s %+6.16f\n", ...
                                             2*WD, ...
                                                      dec2csd_hex( x, WI, WD-WI , z_csd_size ) , ...
                                                            dec2hex( fix(x*2^(WD-WI)), z_hex_size ), ...
                                                                  x );
   end
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   fprintf( fid, '//\n');

   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign Y[4\'b%s] [%02d] = %d\'h %s;  // %+6.16f", dec2bin(i-1, 4), n-1, 2*WD, dec2csd_hex( lut_y(n,i), WI, WD-WI , z_csd_size ) , lut_y(n,i) );
         fprintf( fid, ' = % d * atan( 1 / ( % d + 2^%d ) )', imag(d(i)), real(d(i)), n );
         fprintf( fid, '   n = %2d   d_n = %s \n', n, num2str(d(i)) );
      end
   end

   % TODO: write a header for lut_u
   % First 6 hex digits are the integer part 
   w_hex_size = ceil(WC/4); % 21 bits -->  21/4 = 5.25 < 6

   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign u[4\'b%s] [%02d] = %d\'h %s;  // %+6.16f", dec2bin(i-1, 4), n-1, WC, dec2hex( lut_u_hex(n,i), w_hex_size ) , lut_u(n,i) );
         fprintf( fid, ' = 2^%2d * ln( 1 + % d * 2^(-%2d+1) + (% d^2+% d^2) * 2^(-2*%2d) )', n, real(d(i)), n, real(d(i)), imag(d(i)), n );
         fprintf( fid, '   n = %2d   d_n = %s \n', n, num2str(d(i)) );
      end
   end

   % TODO: write a header for lut_v
   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign v[4\'b%s] [%02d] = %d\'h %s;  // %+6.16f", dec2bin(i-1, 4), n-1, WC, dec2hex( lut_v_hex(n,i), w_hex_size ) , lut_v(n,i) );
         fprintf( fid, ' = 2^(%d+1) * % d * atan( 1 / ( % d + 2^%d ) )', n, imag(d(i)), real(d(i)), n );
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
