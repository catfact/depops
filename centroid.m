%% compute the centroid of a magnitude spectrum
function C = centroid(Xm)
  [m,n] = size(Xm);
  C = zeros(n, 1);
  for i=1:n
    x = Xm(:,i);
    sum = 0;
    for j=1:m
      sum = sum + (j-1)*(x(i));
    end
    C(i) = sum / m;
  end
end 
