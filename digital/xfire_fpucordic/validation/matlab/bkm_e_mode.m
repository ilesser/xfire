   close all


   N  = 2;     % Number of steps in the BKM algorithm
   K  = 100;   % Number of terms to add to calculate rxn and sxn
   L  = 10;    % Number of points to plot Exn vs Exn+1


   %Calculate ln() and atan() LUTs
   n  = (1:N)';
   %d  = [0   j   -j  1-j 1   1+j -1-j -1  -1-j];
   d  = [ -1 -1-j -1+j  0  -j  +j  +1  +1-j +1-j];
   cc = ['r' 'g'  'g'  'b' 'm' 'm' 'c' 'g'  'g'];
   % d could be reduce to:
   d  = [ -1 -1+j  0  +j  +1  +1-j];
   cc = ['r' 'g'  'b' 'm' 'c' 'g'];
   dx = real(d);
   dy = imag(d);
   D  = length(d);

   % ln_lut_c es de NxD
   ln_lut_c = log( 1 + 2.^(-n) * d );

   ln_lut_x = real(ln_lut_c);
   ln_lut_r = (1/2) * log( 1 + 2.^(-n+1) * dx +  2.^(-2*n) * (dx.^2 + dy.^2) );
   ln_lut_y = imag(ln_lut_c);

   rx = zeros(N+1,1);   % rx is (N+1)x1
   sx = zeros(N+1,1);   % sx is (N+1)x1
   k  = zeros(N,K);     % k is NxK

   for n=(1:N+1);
      k(n,:)     = [zeros(1,n-1) (n:K)];
   end

   rx = sum( log( 1 + 2.^(-k) )                 .* (k>0) , 2);
   sx = sum( log( 1 - 2.^(-k+1) + 2.^(-2*k+1) ) .* (k>0) , 2) * -0.5;

   % Ex es de (N+1)xL
   Ex = linspace( -sx, rx, L );

   constant = ones(1,L);

   for n=(1:N);

      % create one figure for each step
      figure(n)
      grid on
      hold on

      % plot a big point in ( rx(n);  rx(n+1))
      plot(  rx(n)          ,  rx(n+1)                       , 'color', 'k', 'marker', '.', 'markersize', 10);
      % plot a big point in (-sx(n); -srx(n+1))
      plot( -sx(n)          , -sx(n+1)                       , 'color', 'k', 'marker', '.', 'markersize', 10);

      % plot a horizontal line on rx(n+1) and -sx(n+1)
      plot( Ex(n,:)         , constant * rx(n+1)             , 'color', 'k' );
      plot( Ex(n,:)         , constant *-sx(n+1)             , 'color', 'k' );

      % plot a vertical line on rx(n) and -sx(n)
      plot( constant * rx(n), linspace( -sx(n+1), rx(n+1), L), 'color', 'k' );
      plot( constant *-sx(n), linspace( -sx(n+1), rx(n+1), L), 'color', 'k' );

      % the previous four lines create a black box around the converge rectange R_{n,n+1}^x

      for i=(1:D);
         % create the line corresponding to d_n
         Exnp1 = Ex(n,:) - ln_lut_x(n,i);

         % plot E_{n+1}^x vs E_n^x
         plot( Ex(n,:), Exnp1, 'color', cc(i) );

         % limit the axis by the point (-sx(n); -sx(n+1) and (rx(n), rx(n+1)) with a factor or 1.2
         xlim( [-sx(n)     rx(n)    ] * 1.2 );
         ylim( [-sx(n+1)   rx(n+1)  ] * 1.2 );
      end

      % print the title, axis labels, legend and text on the border of the black box
      title (  'Plot of E_{n+1}^x vs E_n^x' );
      ylabel(  'E_{n+1}^x' );
      xlabel(  'E_n^x' );
      legend(  'd_n=-1', ...
               'd_n=-1+-j', ...
               'd_n=0', ...
               'dn=+-j', ...
               'd_n=+1', ...
               'd_n=+1+-j', ...
               'location', 'southEast');

      text( rx(n)*(1+1/10), rx(n+1)*(1+1/10), '(r_n^x; r_{n+1}^x)' )
      text(-sx(n)*(1+1/10),-sx(n+1)*(1+1/10), '(-s_n^x; -s_{n+1}^x)' )


   end
