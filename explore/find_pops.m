file = "../e5_r.wav";				
[signal, sr] = audioread(file);

%% zoom in on the interesting part
% signal = signal(12000:70000);)

nsamps = length(signal);


%% NB: we don't actually care so much about frequency resolution,
%% but we do want time resolution.
%% so it would be best to use both a smaller FFT and a smaller hop:fftsize ratio.
%% these values are chosen more for visualization.
nbins = 256;
nfft = 512; 
hop = 128;


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

if 0
  %% scaling flatness by magnitude suppresses quiet noisy bits
  Xflatscale = Xflat .* sum(abs(Xm))';
  %% FIXME: important tuning parameter:
  peakMin = 0.0002;
  [peaks, locs] = findpeaks(Xflatscale, "MinPeakHeight", peakMin);
else
  %% flatness will be more useful if we filter out the quietest frames
  %% FIXME: important tuning parameter:
  tMmean = dbamp(-60);
  tMmax = dbamp(-30);
  tFpeak = 0.0001;
  XFlatFiltered = Xflat;
  for i=1:length(Xm)
    m = Xm(:,i);
    if mean(m) < tMmean || max(m) < tMmax,
      XFlatFiltered(i) = 0;
    end
  end
  [peaks, locs] = findpeaks(XFlatFiltered, "MinPeakHeight", tFpeak);
endif



%% hm, these turn out to be not so useful for the purpose.
%Xpapr = papr(Xp);
%Xcent = centroid(Xm);
