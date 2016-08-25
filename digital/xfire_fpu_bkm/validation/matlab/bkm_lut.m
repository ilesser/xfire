function [lut_X, lut_Y, lut_u, lut_v]=bkm_lut(N, WD, WC, max_val)
% Generates the BKM lut constants.
%
%     TODO: add doc
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Initialize variables
   % Fill in unset optional values.
   switch nargin
      case 0
         N        = 64;
         WD       = 64;
         WC       = 16;
         max_val  = 4;
      case 1
         WD       = 64;
         WC       = 16;
         max_val  = 4;
      case 2
         WC       = 16;
         max_val  = 4;
      case 3
         max_val  = 4;
   end

   if ( WD > 0 && WD <= 8 )
      lut_class_Z = 'int8';
   elseif ( WD > 8  && WD <= 16 )
      lut_class_Z = 'int16';
   elseif ( WD > 16 && WD <= 32 )
      lut_class_Z = 'int32';
   elseif ( WD > 32 && WD <= 64 )
      lut_class_Z = 'int64';
   end

   if ( WC > 0 && WC <= 8 )
      lut_class_w = 'int8';
   elseif ( WC > 8  && WC <= 16 )
      lut_class_w = 'int16';
   elseif ( WC > 16 && WC <= 32 )
      lut_class_w = 'int32';
   elseif ( WC > 32 && WC <= 64 )
      lut_class_w = 'int64';
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Calculate the LUT
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   n  = (1:N)';

   % the posible values for d are {0, +-1} + j {0, +-1}
   % d = dr + j di
   % being dr the real part and di the imaginary part
   d  = [ -1 -1-j -j 1-j 1 1+j j -1+j 0];

   % TODO: implement this to reduce memory space
   % Since the real part has simmetry with respecto to di
   % we could reduce these values to:
   %d  = [ -1 -1+j  0 +j  +1  +1-j];

   lut   = log(1+2.^-n*d);
   lut_x = real(lut);
   lut_y = imag(lut);
   lut_u = lut_x .* repmat( 2.^(n+1), 1, 9 );
   lut_v = lut_y .* repmat( 2.^(n+1), 1, 9 );

   % TODO: implement this to reduce memory space
   % If n > N/2 then real( ln(1+2^(-n)*d) = dr * 2^-n with only 1 bit of error

   % TODO: convert to a 2C representation
   % TODO: convert to a CSD representation
   lut_x = (lut_x / max_val * 2^(WD-1));
   lut_y = (lut_y / max_val * 2^(WD-1));
   lut_u = (lut_u / max_val * 2^(WC-1));
   lut_v = (lut_v / max_val * 2^(WC-1));

   lut_x = cast( lut_x, lut_class_Z);
   lut_y = cast( lut_y, lut_class_Z);
   lut_u = cast( lut_u, lut_class_w);
   lut_v = cast( lut_v, lut_class_w);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Write them to a file
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   fid = fopen('../../rtl/source/lut_constants.vh', 'w');

   for i = 1:length(d);
      for n = 1:N;
         [dx_bin, dy_bin] = get_d(d(i));
         fprintf( fid, "assign X[4\'b%s%s] [%02d] = %+016d;\n", dx_bin, dy_bin, n, dec2hex( lut_x(n, i), 16 ));
      end
   end

   for i = 1:length(d);
      for n = 1:N;
         [dx_bin, dy_bin] = get_d(d(i));
         fprintf( fid, "assign Y[4\'b%s%s] [%02d] = %+016d;\n", dx_bin, dy_bin, n, dec2hex( lut_y(n, i), 16 ) );
      end
   end

   for i = 1:length(d);
      for n = 1:N;
         [dx_bin, dy_bin] = get_d(d(i));
         fprintf( fid, "assign u[4\'b%s%s] [%02d] = %+016d;\n", dx_bin, dy_bin, n, dec2hex( lut_u(n, i), 16 ) );
      end
   end

   for i = 1:length(d);
      for n = 1:N;
         [dx_bin, dy_bin] = get_d(d(i));
         fprintf( fid, "assign v[4\'b%s%s] [%02d] = %+016d;\n", dx_bin, dy_bin, n, dec2hex( lut_v(n, i), 16 ) );
      end
   end

   fclose(fid);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

function [dx_bin, dy_bin]=get_d(d)

   switch (real(d))
      case 0
         dx_bin = '00';
      case 1
         dx_bin = '01';
      case -1
         dx_bin = '11';
   end

   switch (imag(d))
      case 0
         dy_bin = '00';
      case 1
         dy_bin = '01';
      case -1
         dy_bin = '11';
   end

end
