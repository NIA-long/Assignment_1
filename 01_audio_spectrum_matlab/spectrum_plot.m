% Đọc tín hiệu âm thanh từ file wav
[audio, fs] = audioread('Introduction.wav'); 

% Chuyển sang mono nếu là stereo
if size(audio, 2) == 2
    audio = mean(audio, 2);
end

% Giới hạn thời lượng xử lý
duration_sec = 180;
samples_to_use = min(length(audio), duration_sec * fs);
audio = audio(1:samples_to_use);

% Tính FFT
N = length(audio);
Y = fft(audio);
magnitude_spectrum = abs(Y(1:floor(N/2)+1));
f = linspace(0, fs/2, floor(N/2)+1);  % Trục tần số

% Vẽ phổ tần số
figure;
plot(f, magnitude_spectrum);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Spectrum of Audio Signal (3 minutes)');
grid on;

% Phân tích năng lượng theo dải tần 
% Các dải tần (Hz)
low_band = [0, 500];
mid_band = [500, 2000];
high_band = [2000, fs/2];

% Tìm chỉ số tương ứng
idx_low = (f >= low_band(1)) & (f < low_band(2));
idx_mid = (f >= mid_band(1)) & (f < mid_band(2));
idx_high = (f >= high_band(1)) & (f <= high_band(2));

% Tính năng lượng (tổng bình phương biên độ)
E_low = sum(magnitude_spectrum(idx_low).^2);
E_mid = sum(magnitude_spectrum(idx_mid).^2);
E_high = sum(magnitude_spectrum(idx_high).^2);
E_total = E_low + E_mid + E_high;

% Tính tỷ lệ phần trăm
pct_low = E_low / E_total * 100;
pct_mid = E_mid / E_total * 100;
pct_high = E_high / E_total * 100;

% Nhận xét tự động
disp('Kết quả phân tích phần trăm năng lượng các dải tần');
fprintf('Năng lượng tần thấp (0–500 Hz): %.2f%%\n', pct_low);
fprintf('Năng lượng tần trung (500–2000 Hz): %.2f%%\n', pct_mid);
fprintf('Năng lượng tần cao (>2000 Hz): %.2f%%\n', pct_high);