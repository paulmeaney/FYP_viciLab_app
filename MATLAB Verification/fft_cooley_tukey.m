% Paul Meaney
% 2017
% Implementation of Cooley-Tukey FFT algorithm

function FFT = fft_cooley_tukey(x)
n = length(x);

% if r < n
%     p = n - r;
%     x = [x, zeros(1, p)];
% elseif r > n
%     x = x(1 : n);
% end

if n == 1
    FFT = x;
    return;
end
even = zeros(1, n/2);
ptr = 1;
for k = 1:2:n
    even(ptr) = x(k);
    ptr = ptr+1;
end

q = fft_cooley_tukey(even);
odd = zeros(1, n/2);
ptr = 1;
for k = 2:2:n
    odd(ptr) = x(k);
    ptr = ptr+1;
end

r = fft_cooley_tukey(odd);
FFT = zeros(1,n);
for k = 1 : n/2
    kth = (-2 * k * pi) /n;
    wk = cos(kth) + sin(kth)*1i;
    FFT(k) = q(k) + (wk * r(k));
    FFT(k + n/2) = q(k) - (wk * r(k));
end
