function real rand_real;

   reg         sign;
   reg [10:0]  exp;
   reg [51:0]  man;
   real        r;

   begin
      sign        = $random(testseed)%1;
      exp         = $random(testseed)%((2**11)-1);
      man         = $random(testseed)%((2**52)-1);
      rand_real   = $bitstoreal({sign, exp, man});
   end
endfunction

