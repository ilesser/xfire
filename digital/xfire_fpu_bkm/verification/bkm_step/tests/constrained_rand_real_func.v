function real constrained_rand_real;
   input real low_limit;
   input real high_limit;

   reg         sign;
   reg         sign_low, sign_high;
   reg [10:0]  rnd_exp, exp_range, exp_low, exp_high;
   reg [51:0]  rnd_man;
   reg [63:0]  rnd_ieee754, ieee754_range, ieee754_low, ieee754_high, constrained_ieee754;
   real        rnd, range, temp, offset;

   begin

      // Order the values
      if (low_limit > high_limit) begin
         temp        = high_limit;
         high_limit  = low_limit;
         low_limit   = high_limit;
      end

      // Calculate the range of the randomized segment
      range          = high_limit - low_limit;
      ieee754_range  = $realtobits(range);
      exp_range      = ieee754_range[62:52];

      // Substract 1 to the exponent to avoid overflow when man = FFFFFFFF
      // (its equivalent to multiply by 2)
      exp_range = exp_range-1;

      //Get sign and exponent of the limits
      ieee754_low    = $realtobits(low_limit);
      sign_low       = ieee754_low[63];
      exp_low        = ieee754_low[62:52];
      ieee754_high   = $realtobits(high_limit);
      sign_high      = ieee754_high[63];
      exp_high       = ieee754_high[62:52];

      // Calculate offset and sign based on low and high limits
      case ({sign_low, sign_high})
         2'b00:   begin
                     offset   = low_limit;
                     sign     = 1'b0;
                  end
         2'b01:   begin
                     // it shoulnd't enter here
                     offset   = low_limit;
                     sign     = 1'b0;
                  end
         2'b10:   begin
                     offset   = low_limit;
                     sign     = 1'b0;
                  end
         2'b11:   begin
                     offset   = high_limit;
                     sign     = 1'b1;
                  end
      endcase

      // Initial value to force while loop
      rnd = high_limit + 10.0;
      //$display("-----------------------------------------");
      //$display("low        = %e\n", low_limit);
      //$display("low        = %h\n", ieee754_low);
      //$display("sign_low   = 1'b%b\n", sign_low);
      //$display("exp_low    = %h\n", exp_low);
      //$display("exp_low    = %d\n", exp_low);
      //$display("high       = %e\n", high_limit);
      //$display("high       = %h\n", ieee754_high);
      //$display("sign_high  = 1'b%b\n", sign_high);
      //$display("exp_high   = %h\n", exp_high);
      //$display("exp_high   = %d\n", exp_high);
      //$display("sign       = 1'b%b\n", sign);
      //$display("exp_range  = 11'h%h\n", exp_range);
      //$display("exp_range  = %d (%d)\n", exp_range, $signed(exp_range-1023));
      //$display("range      = %f\n",range);
      //$display("offset     = %f\n",offset);
      //$display("rnd        = %f\n",rnd);

      while( rnd <= low_limit || high_limit <= rnd ) begin
         // Randomize exponent up to 53 bits below 0 exp
         rnd_exp  = constrained_rand_int(1023-11, exp_range);

         // Mantissa is 52 bits long so it has to be buil by concating two 32 bits rands
         rnd_man  = {$random(testseed), $random(testseed)};

         rnd_ieee754 = {sign, rnd_exp, rnd_man};

         rnd      = $bitstoreal(rnd_ieee754) + offset;
         //$display("exp = 11'h%h\n", rnd_exp);
         //$display("rnd_exp = %d (%d)\n", rnd_exp, $signed(rnd_exp-1023));
         //$display("man = 52'h%h\n", rnd_man);
         //$display("rnd_ieee754 = 64'h%h\n",rnd_ieee754);
         //$display("rnd = %f\n",rnd);
      end
      //$display("-----------------------------------------\n");

      constrained_ieee754   = $realtobits(rnd);
      constrained_rand_real = rnd;

   end

endfunction


