close all
clear

N = 300;
n = (0:N-1)'; 
n1 = 70;
n2 = 130;
x = zeros(N,1);
x(30:45) = 2.5;
x(70:90) = 2;
x(91:130) = -1;
x(150:170) = 1;
x(170:200) = -2;
h=[1 1 1 1 1]'/5;

% add noise
randn('state', 0); 
y = conv(h, x);
Ny = length(y);
yn = y + 0.2 * randn(Ny, 1);
H = convmtx(h, N);

% minimizes the energy
lam1 = 0.1;
lam2 = 1;
lam3 = 5;
g_min_e1 = (H'*H + lam1 * eye(N)) \ (H' * yn);
g_min_e2 = (H'*H + lam2 * eye(N)) \ (H' * yn);
g_min_e3 = (H'*H + lam3 * eye(N)) \ (H' * yn);

% minimizes the second order derivative
d_second_order = [1 -2 1]';
D = convmtx(d_second_order, N);
g_min_d1 = (H'*H + lam1 * (D'*D)) \ (H' * yn);
g_min_d2 = (H'*H + lam2 * (D'*D)) \ (H' * yn);
g_min_d3 = (H'*H + lam3 * (D'*D)) \ (H' * yn);

hr = h(end : -1 : 1);
hff = conv(h, hr);
num = [hr; zeros(length(h) - 2, 1)];
[HF, ~] = freqz(h, 1);

d0 = [1 0 0 0 0]'; 
d0r = d0(end : -1 : 1);
d0ff = conv(d0, d0r); 
den10 = hff + lam1 * d0ff;
den20 = hff + lam2 * d0ff;
den30 = hff + lam3 * d0ff;
[HF10, ~] = freqz(num, den10);
[HF20, ~] = freqz(num, den20);
[HF30, ~] = freqz(num, den30);

d2 = [1 -2 1 0 0]'; 
d2r = d2(end : -1 : 1);
d2ff = conv(d2, d2r); 
den12 = hff + lam1 * d2ff;
den22 = hff + lam2 * d2ff;
den32 = hff + lam3 * d2ff;
[HF12, ~] = freqz(num, den12);
[HF22, ~] = freqz(num, den22);
[HF32, w] = freqz(num, den32);

figure(1)
subplot(4, 2, 1)
plot(n,x,'r',n,yn(1:N),'b');
ylim([-3 3])
title('Output Signal (noisy)');
subplot(4, 2, 2)
plot(w/pi, abs(HF))
xlabel('\omega/\pi')
title('Frequency Response of Moving Avergae Filter')
subplot(4, 2, 3)
plot(n,x,'r',n,g_min_e1,'k')
ylim([-3 3])
title('Deconvolution (minimizes the energy, \lambda = 0.10)');
subplot(4, 2, 4)
plot(w/pi,abs(HF10))
xlabel('\omega/\pi')
title('Frequency Response \lambda = 0.10')
subplot(4, 2, 5)
plot(n,x,'r',n,g_min_e2,'k')
ylim([-3 3])
title('Deconvolution (minimizes the energy, \lambda = 1.00)');
subplot(4, 2, 6)
plot(w/pi,abs(HF20))
xlabel('\omega/\pi')
title('Frequency Response \lambda = 1.00')
subplot(4, 2, 7)
plot(n,x,'r',n,g_min_e3,'k')
ylim([-3 3])
title('Deconvolution (minimizes the energy, \lambda = 5.00)');
subplot(4, 2, 8)
plot(w/pi,abs(HF30))
xlabel('\omega/\pi')
title('Frequency Response \lambda = 5.00')

figure(2)
subplot(4, 2, 1)
plot(n,x,'r',n,yn(1:N),'b');
ylim([-3 3])
title('Output Signal (noisy)');
subplot(4, 2, 2)
plot(w/pi, abs(HF))
xlabel('\omega/\pi')
title('Frequency Response of Moving Avergae Filter')
subplot(4, 2, 3)
plot(n,x,'r',n,g_min_d1,'k')
ylim([-3 3])
title('Deconvolution (minimizes 2nd derivative, \lambda = 0.10)');
subplot(4, 2, 4)
plot(w/pi,abs(HF12))
xlabel('\omega/\pi')
title('Frequency Response \lambda = 0.10')
subplot(4, 2, 5)
plot(n,x,'r',n,g_min_d2,'k')
ylim([-3 3])
title('Deconvolution (minimizes 2nd derivative, \lambda = 1.00)');
subplot(4, 2, 6)
plot(w/pi,abs(HF22))
xlabel('\omega/\pi')
title('Frequency Response \lambda = 1.00')
subplot(4, 2, 7)
plot(n,x,'r',n,g_min_d3,'k')
ylim([-3 3])
title('Deconvolution (minimizes 2nd derivative, \lambda = 5.00)');
subplot(4, 2, 8)
plot(w/pi,abs(HF32))
xlabel('\omega/\pi')
title('Frequency Response \lambda = 5.00')