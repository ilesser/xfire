function [csd]=dec2csd(x, range, resolution)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts from decimal to a binary CSD representation.
%
% Default values:
%  range       = 11;    Integer range.
%  resolution  = 62;    Fractional range.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   switch nargin
      case 0
         puts('Error! no value to convert');
         return
      case 1
         range       = 11;
         resolution  = 62;
      case 2
         resolution  = 62;
   end

   if( abs(x) < 2^-64 )
      x = 0.0;
   end

   if ( resolution < 64 )
      % Use 64 bits of precision
      x_csd = csdigit(x, range, 64);

      % Then get the result with the appropriate resolution
      x_csd = x_csd(1:(range+resolution)+1);
   else
      % Use the specified resolution
      x_csd = csdigit(x, range, resolution);
   end

   % Create the binary version of the CSD string
   csd = '';

   L = length(x_csd);

   for i=1:L

      switch x_csd(i)
         case '+'
            csd_digit = '01';
         case '-'
            csd_digit = '10';
         case '0'
            csd_digit = '00';
      end

      if ( !strcmp(x_csd(i), '.') )
         csd = strcat( csd, csd_digit );
      end

   end
end
