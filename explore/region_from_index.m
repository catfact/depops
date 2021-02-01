% given a vector of indices, returns the start and end points of the first connected region.
% input is assumed to be in ascending order (e.g. result of `find()`)
function range = region_from_index(x)
  a = x(1);
  b = x(1);
  n = length(x);
  
  for i=2:n
    if (x(i) - x(i-1)) == 1;
      b = x(i);
    else
      break
    end    
  end
  
  range = [a, b];
endfunction
