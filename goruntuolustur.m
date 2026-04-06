clc
clear all
close all

% Yol ve klasör tanımlamaları
imageFolder = 'images'; % RGB asfalt görüntüleri
labelFolder = 'response'; % Segmentasyon etiketleri

 load('veriseti.mat')
data = son;




% Veri seti özelliklerini ve etiketlerini ayırın
features = data(:, 1:3);  % İlk 3 sütun özellikler
labels = data(:, 4);     % 4. sütun etiketler

% Özellikleri normalize edin (0-255 aralığına)
norm_features = (features - min(features(:))) / (max(features(:)) - min(features(:))) * 255;
norm_features = uint8(norm_features); % uint8 türüne dönüştür

% RGB görüntüler ve etiket görüntüleri için klasör oluşturun
if ~exist('images', 'dir')
    mkdir('images');
end
if ~exist('response', 'dir')
    mkdir('response');
end

% Görüntü oluşturma parametreleri
image_size = 256; % 256x256 boyutunda
num_images = 500; % Toplamda 500 görüntü
num_blocks = 4; % Görüntüyü kaç özdesine (block) böleceğiz (4x4 = 16 parça)
block_size = image_size / num_blocks; % Her bloğun boyutu

% Görüntüleri oluştur ve kaydet
for i = 1:num_images
    % RGB kanalları oluştur
    red_channel = zeros(image_size, image_size, 'uint8');
    green_channel = zeros(image_size, image_size, 'uint8');
    blue_channel = zeros(image_size, image_size, 'uint8');

    % Etiket görüntüsü oluştur
    label_rgb = zeros(image_size, image_size, 'uint8');

    % Her blok için rastgele bir sınıf ve veri seçimi
    for row = 1:num_blocks
        for col = 1:num_blocks
            % Blok koordinatları
            row_start = (row-1) * block_size + 1;
            row_end = row * block_size;
            col_start = (col-1) * block_size + 1;
            col_end = col * block_size;

            % Rastgele bir sınıf seç (0 veya 1)
            selected_class = randi([0, 1]);
            class_indices = find(labels == selected_class);

            % Rastgele veriler seç
            if length(class_indices) >= block_size^2
                selected_indices = class_indices(randi(length(class_indices), [block_size^2, 1]));
            else
                selected_indices = class_indices(randi(length(class_indices), [1, block_size^2]));
            end

            % Bloğa verileri yerleştir
            red_channel(row_start:row_end, col_start:col_end) = reshape(norm_features(selected_indices, 1), [block_size, block_size]);
            green_channel(row_start:row_end, col_start:col_end) = reshape(norm_features(selected_indices, 2), [block_size, block_size]);
            blue_channel(row_start:row_end, col_start:col_end) = reshape(norm_features(selected_indices, 3), [block_size, block_size]);

            % Etiket bloğunu doldur
            label_rgb(row_start:row_end, col_start:col_end) = selected_class * 255;
        end
    end

    % RGB görüntüsünü birleştir
    image_rgb = cat(3, red_channel, green_channel, blue_channel);

    % Etiket görüntüsünü renkli yap
    label_rgb = repmat(label_rgb, [1, 1, 3]);

    % Görüntüleri kaydet
    imwrite(image_rgb, fullfile('images', sprintf('image_%d.png', i)));
    imwrite(label_rgb, fullfile('response', sprintf('response_%d.png', i)));
end
