function [csd]=dec2csd(x, range, resolution)
% Converts from decimal to a binary CSD representation.

   x_csd = csdigit(x, range, resolution);
   csd = '';

   L = length(x_csd);

   for i=1:L

      switch x_csd(i)
         case '+'
            csd_digit = '01';
         case '-'
            csd_digit = '11';
         case '0'
            csd_digit = '00';
      end

      if ( !strcmp(x_csd(i), '.') )
         csd = strcat( csd, csd_digit );
      end

   end
end
