% Frequency Compression – Static, Nonlinear (log-scale) (theo PMC: https://pmc.ncbi.nlm.nih.gov/)
clear; clc;

% --- Nhập tên file ---
input_filename = '';
while true
    input_filename = input('Enter the input file''s name (.wav): ', 's');

    if ~endsWith(lower(input_filename), '.wav')
        fprintf('Input file must have a .wav extension.\n');
    elseif ~isfile(input_filename)
        fprintf('File "%s" not found. Please try again.\n', input_filename);
    else
        break;
    end
end

output_filename = '';
while true
    output_filename = input('Enter the output file''s name (.wav): ', 's');

    if ~endsWith(lower(output_filename), '.wav')
        fprintf('Output file must have a .wav extension.\n');
    else
        break;
    end
end


% Đọc âm thanh
[x, fs] = audioread(input_filename);  % Stereo nếu có 2 cột
left = x(:,1);
right = x(:,2);

% --- Nhập tham số nén ---

fc = 0; scale = 0;

% Nhập tần số cắt
while true
    fc = input('Enter the cut-off frequency (Hz, must be > 0): ');
    if fc > 0
        break;
    else
        fprintf('Cut-off frequency must be a positive number.\n');
    end
end

% Nhập scale
while true
    scale = input('Enter the compression scale (e.g., ~100 for light compression, must be ≥ 0): ');
    if scale >= 0
        break;
    else
        fprintf('Scale must not be negative.\n');
    end
end

% Áp dụng nonlinear compression (log-scale nhẹ)
left_new = compress_channel_nonlinear(left, fs, fc, scale);
right_new = compress_channel_nonlinear(right, fs, fc, scale);

% Ghép stereo và lưu lại
stereo_new = [left_new, right_new];
audiowrite(output_filename, stereo_new, fs);
fprintf('Compressed audio written to "%s".\n', output_filename);

% Vẽ phổ trước và sau
N = length(left);
f = linspace(0, fs/2, floor(N/2));

% Before - Left
Y_left = fft(left);
mag_left = abs(Y_left(1:floor(N/2)));
subplot(2,2,1); plot(f, mag_left); title('Before - Left'); xlabel('Frequency (Hz)'); ylabel('|Amplitude|');

% Before - Right
Y_right = fft(right);
mag_right = abs(Y_right(1:floor(N/2)));
subplot(2,2,2); plot(f, mag_right); title('Before - Right'); xlabel('Frequency (Hz)'); ylabel('|Amplitude|');

% After - Left
Y_left_new = fft(left_new);
mag_left_new = abs(Y_left_new(1:floor(N/2)));
subplot(2,2,3); plot(f, mag_left_new); title('After - Left'); xlabel('Frequency (Hz)'); ylabel('|Amplitude|');

% After - Right
Y_right_new = fft(right_new);
mag_right_new = abs(Y_right_new(1:floor(N/2)));
subplot(2,2,4); plot(f, mag_right_new); title('After - Right'); xlabel('Frequency (Hz)'); ylabel('|Amplitude|');



% --- Hàm hỗ trợ ---
function x_new = compress_channel_nonlinear(x, fs, fc, scale)
    % Nén tần số phi tuyến log-scale nhẹ
    N = length(x);
    X = fft(x);
    f = (0:N-1)*(fs/N);
    X_new = zeros(size(X));

    for i = 1:N
        if f(i) <= fc
            X_new(i) = X(i);
        elseif f(i) <= fs/2
            % Logarithmic compression
            f_shifted = fc + log10(1 + (f(i)-fc)) * scale;
            idx_shifted = round(f_shifted / fs * N);
            if idx_shifted <= N
                X_new(idx_shifted) = X_new(idx_shifted) + X(i);
            end
        end
    end

    x_new = real(ifft(X_new));
    x_new = x_new / max(abs(x_new));  % Chuẩn hóa
end
