file = "e5_r.wav";

[X, sr] = audioread(file);

%% clipping threshold
t = dbamp(-0.05);

%% first and last indices of clipped region
r = region_from_index(find(X > t));


%% now we want to extrapolate from surrounding data over the clipped region
xr = [r(1)-2; r(1)-1; r(2)+1; r(2)+2];
yr = X(xr);

o = 3;
p = polyfit(xr, yr, o);
xex = [xr(1):xr(end)];
yex = polyval(p, xex);

Y = X;
Y(xex) = yex;



t = dbamp(-1);
Y = Y .* (t / max(Y));

audiowrite("e5_r_declip.wav", Y, sr);
