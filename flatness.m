%% compute spectral flatness (aka weiner entropy), given power spectrum
function F = flatness(Xp)
  n = size(Xp)(2);
  F = zeros(n, 1);
  for i=1:n
    x = Xp(:,i);
    F(i) = geomean(x)/mean(x);
  end 
end
