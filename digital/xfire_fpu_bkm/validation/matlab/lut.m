function [X,Y,u,v]=lut(WD, WC, LOG2N, bkm_mode, format )
% Generates the BKM lut constants.
%
%     TODO: add doc
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Initialize variables
   % Fill in unset optional values.
   switch nargin
      case 0
         WD       = 64;
         WC       = 16;
         LOG2N    = 6;
         bkm_mode = 'E';
         format   = 64;
      case 1
         WC       = 16;
         LOG2N    = 6;
         bkm_mode = 'E';
         format   = 64;
      case 2
         LOG2N    = 6;
         bkm_mode = 'E';
         format   = 64;
      case 3
         bkm_mode = 'E';
         format   = 64;
      case 4
         format   = 64;
   end

   % Check for bkm_mode
   if ( strcmp(bkm_mode,'E') || strcmp(bkm_mode,'E-mode') )
      bkm_mode = 'E';
   elseif ( strcmp(bkm_mode,'L') || strcmp(bkm_mode,'L-mode') )
      bkm_mode = 'L';
   else
      error('%s is not a recognized bkm_mode. You can use {E, E-mode, L, L-mode}',bkm_mode)
   end


   fid = fopen('../../rtl/source/lut_constants.vh', 'w');

   % Print X lut
   for d_x = 0:3;
      for d_y = 0:3;
         %for n = 1:(2^LOG2N)-1;
         for n = 1:21;
            [dx, dy] = get_d(d_x, d_y);
            %fprintf( fid, "assign X[4\'b%s%s] [%02d] = %s;\n", dec2bin(d_x, 2), dec2bin(d_y, 2), n, dec2csd_hex(log(1+dx*2^(-n+1)+(dx^2+dy^2)*2^(-2*n)), 10, WD-10) );
            %fprintf( fid, "assign Y[4\'b%s%s] [%02d] = %s;\n", dec2bin(d_x, 2), dec2bin(d_y, 2), n, dec2csd_hex(dy * atan( 1 / (dx+2^n) )              , 10, WD-10) );
            %fprintf( fid, "assign X[4\'b%s%s] [%02d] = %+01.16f;\n", dec2bin(d_x, 2), dec2bin(d_y, 2), n,          (1+dx*2^(-n+1)+(dx^2+dy^2)*2^(-2*n)) );
            %fprintf( fid, "assign X[4\'b%s%s] [%02d] = %+01.16f;\n", dec2bin(d_x, 2), dec2bin(d_y, 2), n, (1/2)*log(1+dx*2^(-n+1)+(dx^2+dy^2)*2^(-2*n)) );
            %fprintf( fid, "assign Y[4\'b%s%s] [%02d] = %+01.16f;\n", dec2bin(d_x, 2), dec2bin(d_y, 2), n, dy * atan( 1 / (dx+2^n) )               );
            fprintf( fid, "assign X[4\'b%s%s] [%02d] = %+01.16f;\n", dec2bin(d_x, 2), dec2bin(d_y, 2), n, real(log(1+(dx+j*dy)*2^-n)) );
            fprintf( fid, "assign Y[4\'b%s%s] [%02d] = %+01.16f;\n", dec2bin(d_x, 2), dec2bin(d_y, 2), n, imag(log(1+(dx+j*dy)*2^-n)) );
            fprintf( fid, "assign u[4\'b%s%s] [%02d] = %+01.16f;\n", dec2bin(d_x, 2), dec2bin(d_y, 2), n, real(log(1+(dx+j*dy)*2^-n)) * 2^(n+1) );
            fprintf( fid, "assign v[4\'b%s%s] [%02d] = %+01.16f;\n", dec2bin(d_x, 2), dec2bin(d_y, 2), n, imag(log(1+(dx+j*dy)*2^-n)) * 2^(n+1) );
         end
      end
   end

   % Print Y lut
   %for d_x = 0:3
      %for d_y = 0:3
         %for n = 1:(2^LOG2N)-1
            %[dx, dy] = get_d(d_x, d_y);
            %fprintf  (
                     %fid, ...
                     %'assign Y[4b%b%b] [%d] = %d\n', ...
                     %d_x, ...
                     %d_y, ...
                     %n, ...
                     %dy * atan( 1 / (dx+2^n) ) ...
                     %);
         %end
      %end
   %end

   fclose(fid);

end




function [dx,dy]=get_d(d_x, d_y)

   switch (d_x)
      case 0   % 00
         dx = 0;
      case 1   % 01
         dx = 1;
      case 2   % 10
         dx = 0;
      case 3   % 11
         dx = -1;
   end

   switch (d_y)
      case 0   % 00
         dy = 0;
      case 1   % 01
         dy = 1;
      case 2   % 10
         dy = 0;
      case 3   % 11
         dy = -1;
   end

end
