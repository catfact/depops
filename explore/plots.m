imshow(abs(X(1:nbins,:)));
title("magnitude spectrum");
axis on;
print -dpng "mag_spectrum.png";
clf

imshow(abs(Xsrc(1:nbins,:)));
axis on;
print -dpng "liftered_source.png";
clf

plot(Xflat);
axis on;
print -dpng "spectral_flatness.png";
clf
