function [csd]=dec2csd_hex(x, range, resolution)
% Converts from decimal to a hexadecimal CSD representation.
   csd_bin = dec2csd( x, range, resolution );
   csd = dec2hex( bin2dec( csd_bin ) );
end
