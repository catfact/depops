%% use cepstral method to extract "source" and "filter" components from log-power spectrum
%% quefrency breakpoint is given as a ratio of the window size
function [Y,Z] = source_filter(Xlp, r)
  [nblocks, nbins] = size(Xlp);
  Y = zeros([nblocks, nbins]);
  minbin = floor(r * nbins);
  for block = 1:nblocks
    tmp = ifft(Xlp(block,:));
    src = tmp;
    filt = tmp;
    src(:,1:minbin) = zeros(1,minbin);
    filt(:,(minbin+1):nbins) = zeros(1,nbins-minbin);
    Y(block,:) = fft(src);
    Z(block,:) = fft(filt);
  end
end

