function [u] = peakfilt(u);

u_ = medfilt2(u,[5 5],'symmetric');
diff = abs(u-u_);
v = mean(abs(u_(:)));
%sum(sum(diff > v))/size(u,1)/size(u,2)
u(diff > v) = u_(diff > v);