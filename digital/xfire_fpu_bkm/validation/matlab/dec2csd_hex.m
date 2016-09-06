function [csd_hex]=dec2csd_hex(x, range, resolution, len)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts from decimal to a hexadecimal CSD representation.
%
% Default values:
%  range       = 11;    Integer range.
%  resolution  = 62;    Fractional range.
%  len         = 37;    Number of hexadecimal digits.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   switch nargin
      case 0
         puts('Error! no value to convert');
         return
      case 1
         range       = 11;
         resolution  = 62;
         len         = 37;
      case 2
         resolution  = 62;
         len         = 37;
      case 3
         len         = 37;
   end

   % Convert from decimal to binary csd
   csd_bin = dec2csd( x, range, resolution );

   pad_len = mod(length(csd_bin), 4);
   if ( pad_len != 0 )
      % Extend to have a full hex digit
      csd_bin = strcat( repmat( '0', 1, pad_len ), csd_bin );
   end

   diff = len*4 - length(csd_bin);
   if ( diff >= 0 )
      % Extend to desired length
      csd_bin = strcat( repmat('0', 1, diff), csd_bin );
   else
      puts( 'ERROR!: Desired length is not enough to represent this number!');
      csd_hex = '-1';
      return
   end

   % Create the hex version of the binary string
   csd_hex = '';
   for i=1:len;
      four_bits = csd_bin((i-1)*4 + 1 : i*4);
      hex_digit = dec2hex( bin2dec( four_bits ) );
      csd_hex   = strcat( csd_hex, hex_digit );
   end

end
