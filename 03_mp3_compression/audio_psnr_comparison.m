% B1: Đọc file âm thanh
[original, fs] = audioread('Introduction 1.wav');
[compressed1, ~] = audioread('Introduction_compressed.wav');
[compressed2, ~] = audioread('compress.wav');

% B2: Cắt độ dài giống nhau nếu có sai lệch
min_len = min([length(original), length(compressed1), length(compressed2)]);
original = original(1:min_len, :);
compressed1 = compressed1(1:min_len, :);
compressed2 = compressed2(1:min_len, :);

% B3: Tính PSNR cho từng bản nén
psnr_1 = 10 * log10(sum(original.^2, 'all') / sum((original - compressed1).^2, 'all'));
psnr_2 = 10 * log10(sum(original.^2, 'all') / sum((original - compressed2).^2, 'all'));

% B4: In kết quả
fprintf('📌 PSNR - Introduction_compressed.wav: %.2f dB\n', psnr_1);
fprintf('📌 PSNR - compress.wav               : %.2f dB\n', psnr_2);

% B5: Phân tích phổ tần số (chỉ lấy 1 kênh nếu stereo)
Y_orig = abs(fft(original(:,1)));
Y_comp1 = abs(fft(compressed1(:,1)));
Y_comp2 = abs(fft(compressed2(:,1)));

f = linspace(0, fs/2, floor(min_len/2));

% B6: Vẽ 3 biểu đồ tách riêng

% 🎧 Original
figure;
plot(f, Y_orig(1:floor(min_len/2)), 'b');
title('Original Spectrum');
xlabel('Frequency (Hz)'); ylabel('|Amplitude|');
grid on;

% 🎧 Compressed 1
figure;
plot(f, Y_comp1(1:floor(min_len/2)), 'r');
title('Compressed 1 Spectrum (Introduction\_compressed.wav)');
xlabel('Frequency (Hz)'); ylabel('|Amplitude|');
grid on;

% 🎧 Compressed 2
figure;
plot(f, Y_comp2(1:floor(min_len/2)), 'g');
title('Compressed 2 Spectrum (compress.wav)');
xlabel('Frequency (Hz)'); ylabel('|Amplitude|');
grid on;
s