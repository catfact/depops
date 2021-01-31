# compute the peak-to-average power ratio, given power spectrum
function P = papr(Xp)
  n = size(Xp)(2);
  P = zeros(n, 1);
  for i=1:n
    x = Xp(:,i);		
    P(i) = max(x)/mean(x);
  end 
end
