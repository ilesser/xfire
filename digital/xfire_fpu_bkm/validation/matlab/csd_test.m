
W           = 4;
range       = W+0;
resolution  = 0;

for i=1:2^W
   num(i) = i-1-2^(W-1);
   [dig{i},pos(i),neg(i),err(i)]=csdigit(num(i),range,resolution);
end

shift_1 = bitshift (pos,-1)-bitshift(neg,-1);
shift_2 = bitshift (pos,-2)-bitshift(neg,-2);
shift_3 = bitshift (pos,-3)-bitshift(neg,-3);
div_1   = fix(num*2^-1);
div_2   = fix(num*2^-2);
div_3   = fix(num*2^-3);

printf('+------+--------+--------+--------+--------+--------+\n')
printf('| num  |  CSD   |  >>1   |  /2^1  |  >>2   |  /2^2  |\n')
printf('+------+--------+--------+--------+--------+--------+\n')
for i=1:2^W
   printf(  '|%+4d  |  %s |   %+d   |    %+d  |    %+d  |    %+d  |',  num(i), dig{i}, shift_1(i), div_1(i), shift_2(i), div_2(i) )

   if (neg(i) == 0)
      printf('\n')
   else
      printf('<-- este tiene -1: %s\n', dec2bin(neg(i),W) )
   end
   %printf(  '|%+4d  |  %s |     %s  |     %s |     %s |     %s     |<-- este tiene -1: %s\n',  num(i), dig{i}, dig{i}, dec2bin(floor((num(i)+2^W)/2),W), dig{i}, dec2bin(floor((num(i)+2^W)/4),W), dec2bin(neg(i),W) )
   %printf(  ' %+d      %s <-- este tiene -1: %s\n', num, dig{i}, dec2bin(neg(i),W) )
end
printf('+------+--------+------------+----------+-----------+--------------+\n')
