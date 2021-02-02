%% find pops in an audio file
%%
%% returns a 2xN matrix, 
%% where each row represents the start and end sample in a "pop" region
%% search resolution is determined by FFT window and hop size
%%
%% `nwin`: window size excluding zero-padding
%% `nbins`: number of real frequency bins; exceeding nwin/2
%% `nhop`: hop size in samples

function [locations, peaks, signal] = find_pops(filename, channel=1,
			       nwin=512, nbins=256, nhop=128,
			       meanMagThreshDb = -60,
			       maxMagThreshDb = -30,
			       peakFlatnessThreshDb = -80)

#file = "../e5_r.wav";				
[signal, sr] = audioread(filename);
nch = size(signal)(2);
if nch > 1
  signal = signal(:,min(channel,nch));
end

nsamps = length(signal);

%% NB: we don't actually care so much about frequency resolution,
%% but we do want time resolution.
%% so it would be best to use both a smaller FFT and a smaller hop:fftsize ratio.
%% these values are chosen more for visualization.

[X, C] = stft(signal, nwin, nhop, nbins, "hanning");

%% magnitude, power and log-power spectra
Xm = abs(X)/nbins*2;
Xp = Xm .^ 2;

%% liftered source/filter components
%% this is intriguing but probably unnecessary
% Xlp = log(abs(X) .^ 2);
% [Xsrc, Xflt] = source_filter(Xlp, 0.4);

%% other spectral measures
Xflat = flatness(Xp);

%% hm, these turn out to be not so directly interpretable...
%Xpapr = papr(Xp);
%Xcent = centroid(Xm);


%% flatness will be more useful if we filter out the quietest frames
%% FIXME: important tuning parameters:
tMmean = dbamp(meanMagThreshDb);
tMmax = dbamp(maxMagThreshDb);
XFlatFiltered = Xflat;
for i=1:length(Xm)
  m = Xm(:,i);
  if mean(m) < tMmean || max(m) < tMmax,
    XFlatFiltered(i) = 0;
  end
end

%% FIXME: another important tuning parameter:
tFpeak = dbamp(peakFlatnessThreshDb);
[peaks, l] = findpeaks(XFlatFiltered, "MinPeakHeight", tFpeak);
nloc = length(l);
locations = zeros(nloc,2);
peaks = zeros(nloc,2);
for i =1:nloc
  locations(i,:) = [l(i)*nhop, l(i)*nhop + nwin];
end
