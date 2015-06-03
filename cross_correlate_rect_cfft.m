function [c] = cross_correlate_rect_cfft(a2,b2,NfftHeight,NfftWidth)

% temprorary solution
a2 = a2 - mean2(a2);
b2 = b2 - mean2(b2);

b2 = b2(end:-1:1,end:-1:1);


% let's replace two fft's by a single complex one:
% before:
% ffta=fft2(single(a2),NfftHeight,NfftWidth);
% fftb=fft2(single(b2),NfftHeight,NfftWidth);

% after replacement:
fftab = fft2(single(a2+1i*b2),NfftHeight,NfftWidth);

% and use them in the inverse fft 
% c = real(ifft2(real(fftab).*imag(fftab)));

c = fftshift(fftab.*conj(fftab));

% another option not implemented yet, but b2 shall be larger than a2
% see >> help normxcorr2
% c = normxcorr2(b2,a2);

c(c<0) = 0;

return
