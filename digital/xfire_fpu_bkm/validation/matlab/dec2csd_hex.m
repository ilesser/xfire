function [csd]=dec2csd_hex(x, range, resolution, len)
% Converts from decimal to a hexadecimal CSD representation.

   % Use 64 bits of precision
   csd_bin = dec2csd( x, range, 64 );

   % Then get the result with the appropriate resolution
   csd_bin = csd_bin(1:2*(range+resolution));

   % Convert to decimal and then back to hexa
   csd = dec2hex( bin2dec( csd_bin ) , len);
end
