file = "e5_r.wav";				
[signal, sr] = audioread(file);

nframes = length(signal);


%% NB: we don't actually care so much about frequency resolution,
%% but we do want time resolution.
%% so it would be best to use both a smaller FFT and a smaller hop:fftsize ratio.
%% these values are chosen more for visualization.
nbins = 256;
nfft = 512; 
hop = 128;

%% zoom in on the interesting part
signal = signal(12000:70000);

%% start with STFT
[X, C] = stft(signal, nfft, hop, nbins, "hanning");

%% magnitude, power and log-power spectra
Xm = abs(X)/nfft;
Xp = Xm .^ 2;
Xlp = log(abs(X) .^ 2);

%% liftered source/filter components
[Xsrc, Xflt] = source_filter(Xlp, 0.4);

%% other spectral measures

Xflat = flatness(Xp);

%% flatness will be more useful if we filter out the quietest frames
nframes = size(X)(2);
%max_mag = zeros(nframes,1);
tmag = dbamp(-40);
for i=1:nframes  
  if max(Xm(:,i)) < tmag
    Xflat(i) = 0;
  end
end


%% hm, these turn out to be not so useful for the purpose.
Xpapr = papr(Xp);
Xcent = centroid(Xm);
