% Đọc file audio
[y, fs] = audioread('audiotest1.wav');

% Nếu là stereo thì chuyển thành mono
if size(y,2) == 2
    y = mean(y, 2);
end

% Độ dài tín hiệu
N = length(y);

% Thực hiện biến đổi Fourier (FFT)
Y = fft(y);

% Tạo trục tần số
f = (0:N-1)*(fs/N);

% Tính biên độ (magnitude)
magnitude = abs(Y)/N;

% Chỉ lấy một nửa phổ (tần số dương)
half_N = floor(N/2);
f_plot = f(1:half_N);
magnitude_plot = magnitude(1:half_N);

% Vẽ phổ
figure;
plot(f_plot, magnitude_plot);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Spectrum of the Audio Signal');
grid on;
