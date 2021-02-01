%% excise a portion of given (audio) signal with crossfade
%%
%% it is assumed that the exact final duration is flexible,
%% so a fade time is programatically determined
%%
%% parameters:
%% a, b: first and last indices of region to excise
%% nw: window length (maximum crossfade duration in samples)
%%
%% returns:
%% Y: new signal
%% c: correlation peak value
%% nf: actual count of crossfade samples
function [Y, C, nf, W, V] = excise(X, a, b, nw=1000)
  % count of excised samples
  nx = b-a+1;
  % restrict window size
  nw = min(a-1, nw);
  nw = min(length(X)-b, nw);
  
  %% windows preceding and following excision,
  %% which we'll examine for correlation
  W = X(a-nw:a-1);  
  V = X(b+1:b+1+nw);

  %% find lag time maximizing cross-correlation
  [C, lag] = xcorr(W,V,nw-1);  
  %% discard negative lags
  %ipos = find(lag>=0);
  %C = C(ipos);
  %lag = lag(ipos);
  [cmax, idx] = max(C);  
  r = int64(lag(idx));
  nf = nw - r; % finally the true xfade duration

  %%% build output
  %% initial segment
  Y0 = X(1:a-1-nf,:);
  %% ending segment
  Y1 = X(b+1+nf:end);
  %% calculate xfaded segment
  phi = linspace(0, 1, nf)';
  W = X(a-nf:a-1);
  V = X(b+1:b+nf);  
  %% FIXME:
  %% should choose interpolation type based on degree of correlation
  %% (linear if totally correlated, equal-power if uncorrelated)
  %% for now, just use linear
  Yf = (W.*phi) + (V.*(1-phi));
  Y = [Y0;Yf;Y1];  
end
