function [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N, W, WI, file_name)
%-------------------------------------------------------------------------------
% Generates the BKM lut constants.
%
% [lut_x, lut_y, lut_u, lut_v]=bkm_lut()
% [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N)
% [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N, W)
% [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N, W, WI)
% [lut_x, lut_y, lut_u, lut_v]=bkm_lut(N, W, WI, file_name)
%
%  Default values
%     N           = 64;    BKM steps.
%     W           = 64;    Word size.
%     WI          = 11;    Integer word size.
%     file_name   = '../../rtl/source/lut_constants.vh';
%
%     TODO: add doc
%
%-------------------------------------------------------------------------------
% History
%
% 08-09-2016   -  Changed inputs to N, W, WI and filename.
% 05-09-2016   -  Fixed bug 14.
%
%-------------------------------------------------------------------------------

   %---------------------------------------------------------------
   % Version and date
   %---------------------------------------------------------------
   version = '1.2';
   version_date = 'Saturday 08 September 2016';

   %---------------------------------------------------------------
   % Initialize variables
   % Fill in unset optional values.
   %---------------------------------------------------------------
   switch nargin
      case 0
         N           = 64;
         W           = 64;
         WI          = 11;
         file_name   = '../../rtl/source/lut_constants.vh';
      case 1
         W           = 64;
         WI          = 11;
         file_name   = '../../rtl/source/lut_constants.vh';
      case 2
         WI          = 11;
         file_name   = '../../rtl/source/lut_constants.vh';
      case 3
         file_name   = '../../rtl/source/lut_constants.vh';
   end

   %---------------------------------------------------------------
   % Data channel parameters
   %---------------------------------------------------------------
   UGD = 2; % This was calculated outside and its fixed
   LGD = ceil(log2(W));
   WDI = UGD + WI;
   WDF = W - WI + LGD;
   WD  = WDI + WDF;


   %---------------------------------------------------------------
   % Control channel parameters
   %---------------------------------------------------------------
   UGC = 3; % This was calculated outside and its fixed
   LGC = ceil(log2(WI+4));
   WCI = UGC + WI;
   WCF = 4 + LGC;
   WC  = WCI + WCF;

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
   lut_x_hex = lut_x / 2^(WDI-1);
   lut_y_hex = lut_y / 2^(WDI-1);
   lut_u_hex = lut_u / 2^(WCI-1);
   lut_v_hex = lut_v / 2^(WCI-1);
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

   % -------------------------------------------------------------------------------------------------------------------
   % Generation and parameters information
   % -------------------------------------------------------------------------------------------------------------------
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   fprintf( fid, '//\n');
   fprintf( fid, '// BKM LUT automatically generated on %s\n', strftime ("%r (%Z) %A %e %B %Y", localtime (time ())) );
   fprintf( fid, '// using the bkm_lut.m function. Version = %s, from %s.\n', version, version_date );
   fprintf( fid, '// Parameters:\n');
   fprintf( fid, '// Number of steps of the algorithm:            N     = %d\n', N);
   fprintf( fid, '// Word size:                                   W     = %d\n', W );
   fprintf( fid, '// Integer word size:                           WI    = %d\n', WI);
   fprintf( fid, '// Data channel upper guard bits:               UGD   = %d\n', UGD);
   fprintf( fid, '// Integer word size of the data channel:       WDI   = %d\n', WDI);
   fprintf( fid, '// Fractional word size of the data channel:    WDF   = %d\n', WDF);
   fprintf( fid, '// Data channel lower guard bits:               LGD   = %d\n', LGD);
   fprintf( fid, '// Word size of the data channel:               WD    = %d\n', WD);
   fprintf( fid, '// Control channel upper guard bits:            UGC   = %d\n', UGC);
   fprintf( fid, '// Integer word size of the control channel:    WDI   = %d\n', WCI);
   fprintf( fid, '// Fractional word size of the control channel: WDF   = %d\n', WCF);
   fprintf( fid, '// Control channel lower guard bits:            LGC   = %d\n', LGC);
   fprintf( fid, '// Word size of the control channel:            WC    = %d\n', WC);
   fprintf( fid, '//\n');
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   fprintf( fid, '//\n');
   fprintf( fid, '//          IIIIIIIIIIIIIII.FFFFFFFFFFFFFF\n');
   fprintf( fid, '//       +-----------------------------------+\n');
   fprintf( fid, '// WD =  |  UGD   +  WI    +  W-WI  +  LGD   |\n');
   fprintf( fid, '//       +-----------------------------------+\n');
   fprintf( fid, '// WD =  |       WDI       +       WDF       |\n');
   fprintf( fid, '//       +-----------------------------------+\n');
   fprintf( fid, '//\n');
   fprintf( fid, '//       +-----------------------------------+\n');
   fprintf( fid, '// WC =  |  UGC   +   WI   +   4    +  LGC   |\n');
   fprintf( fid, '//       +-----------------------------------+\n');
   fprintf( fid, '// WC =  |       WCI       +       WCF       |\n');
   fprintf( fid, '//       +-----------------------------------+\n');
   fprintf( fid, '//          IIIIIIIIIIIIIII.FFFFFFFFFFFFFF\n');
   fprintf( fid, '//\n');
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   % -------------------------------------------------------------------------------------------------------------------

   % -------------------------------------------------------------------------------------------------------------------
   % LUT X
   % -------------------------------------------------------------------------------------------------------------------
   z_hex_size = ceil(WD/4);
   z_csd_size = ceil(2*WD/4);
   fprintf( fid, '//\n');
   fprintf( fid, '//\n');
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   fprintf( fid, '// This LUT uses %d bits which represent %d CSD digits. \n', 2*WD, WD);
   fprintf( fid, '// They are represented by %d hexadecimal digits. \n', z_csd_size);
   fprintf( fid, '// After the LUT value you have the twos complement representation in %d hexadecimal digits. \n', z_hex_size);
   fprintf( fid, '// Since we use %d bits for the integer part then the first %1.1f hexa digits represent the integer part. \n', WDI, ceil(log2(WDI)) );
   fprintf( fid, '// The rest %2.1f hexa digits represent the fractional part.\n', z_hex_size-ceil(log2(WDI)) );
   fprintf( fid, '// Example:\n');
   for x=2.^(WI-n');
      fprintf( fid, "//sign X[4\'bXXXX] [XX] = %d\'h %s;  // %s %+06.16f\n", ...
                                             2*WD, ...
                                                      dec2csd_hex( x, WDI, WDF , z_csd_size ) , ...
                                                            dec2hex( fix(x*2^WDF), z_hex_size ), ...
                                                                  x );
   end
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   fprintf( fid, '//\n');

   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign X[4\'b%s] [%02d] = %d\'h %s;  // %s %+6.16f", dec2bin(i-1, 4), n, 2*WD, dec2csd_hex( lut_x(n, i), WDI, WDF , z_csd_size ) , dec2hex( lut_x_hex(n,i), z_hex_size ), lut_x(n,i) );
         fprintf( fid, ' = 0.5 * ln( 1 + % d * 2^(-%d+1) + (% d^2+% d^2) * 2^(-2*%d) )', real(d(i)), n, real(d(i)), imag(d(i)), n );
         fprintf( fid, '   n = %2d   d_n = %s \n', n, num2str(d(i)) );
      end
   end
   % -------------------------------------------------------------------------------------------------------------------

   % -------------------------------------------------------------------------------------------------------------------
   % LUT Y
   % -------------------------------------------------------------------------------------------------------------------
   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign Y[4\'b%s] [%02d] = %d\'h %s;  // %s %+6.16f", dec2bin(i-1, 4), n, 2*WD, dec2csd_hex( lut_y(n,i), WDI, WDF, z_csd_size ) , dec2hex( lut_y_hex(n,i), z_hex_size ), lut_y(n,i) );
         fprintf( fid, ' = % d * atan( 1 / ( % d + 2^%d ) )', imag(d(i)), real(d(i)), n );
         fprintf( fid, '   n = %2d   d_n = %s \n', n, num2str(d(i)) );
      end
   end
   % -------------------------------------------------------------------------------------------------------------------

   % -------------------------------------------------------------------------------------------------------------------
   % LUT u
   % -------------------------------------------------------------------------------------------------------------------
   w_hex_size = ceil(WC/4);
   fprintf( fid, '//\n');
   fprintf( fid, '//\n');
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   fprintf( fid, '// This LUT uses %d bits which represent %d twos complement digits. \n', WC, WC);
   fprintf( fid, '// They are represented by %d hexadecimal digits. \n', w_hex_size);
   fprintf( fid, '// After the LUT value you have the floating point representation. \n');
   fprintf( fid, '// Since we use %d bits for the integer part then the first %1.1f hexa digits represent the integer part. \n', WCI, ceil(log2(WCI)) );
   fprintf( fid, '// The rest %2.1f hexa digits represent the fractional part.\n', w_hex_size-ceil(log2(WI)) );
   fprintf( fid, '// Example:\n');
   for x=2.^(WI-n');
      fprintf( fid, "//sign u[4\'bXXXX] [XX] = %d\'h %s;  //   %+6.16f\n", ...
                                                WC, ...
                                                      dec2hex( fix(x*2^(WCF)), w_hex_size ), ...
                                                               x );
   end
   fprintf( fid, '//--------------------------------------------------------------------------------\n');
   fprintf( fid, '//\n');
   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign u[4\'b%s] [%02d] = %d\'h %s;  // %+6.16f", dec2bin(i-1, 4), n, WC, dec2hex( lut_u_hex(n,i), w_hex_size ) , lut_u(n,i) );
         fprintf( fid, ' = 2^%2d * ln( 1 + % d * 2^(-%2d+1) + (% d^2+% d^2) * 2^(-2*%2d) )', n, real(d(i)), n, real(d(i)), imag(d(i)), n );
         fprintf( fid, '   n = %2d   d_n = %s \n', n, num2str(d(i)) );
      end
   end

   % -------------------------------------------------------------------------------------------------------------------
   % LUT v
   % -------------------------------------------------------------------------------------------------------------------
   for i = 1:length(d);
      for n = 1:N;
         fprintf( fid, "assign v[4\'b%s] [%02d] = %d\'h %s;  // %+6.16f", dec2bin(i-1, 4), n, WC, dec2hex( lut_v_hex(n,i), w_hex_size ) , lut_v(n,i) );
         fprintf( fid, ' = 2^(%d+1) * % d * atan( 1 / ( % d + 2^%d ) )', n, imag(d(i)), real(d(i)), n );
         fprintf( fid, '   n = %2d   d_n = %s \n', n, num2str(d(i)) );
      end
   end
   % -------------------------------------------------------------------------------------------------------------------

   %---------------------------------------------------------------
   % Close the file
   %---------------------------------------------------------------
   fclose(fid);
   %---------------------------------------------------------------
end
