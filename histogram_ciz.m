clc
clear all
close all

 load('veriseti.mat')
data = son;




% Veri seti özelliklerini ve etiketlerini ayırın
features = data(:, 1:3);  % İlk 3 sütun özellikler
labels = data(:, 4);     % 4. sütun etiketler

% Özellikleri normalize edin (0-255 aralığına)
norm_features = (features - min(features(:))) / (max(features(:)) - min(features(:))) * 255;
norm_features = uint8(norm_features); % uint8 türüne dönüştür


% Görüntü oluşturma parametreleri
image_size = 256; % 256x256 boyutunda
num_images = 1; % Toplamda 500 görüntü
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
            selected_class = 1;
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

   % imshow(image_rgb);
   % figure
   % imshow(label_rgb);
   r = imhist(image_rgb(:,:,1));
   g = imhist(image_rgb(:,:,2));
   b = imhist(image_rgb(:,:,3));

  
end

x = 1:256; 
XData1 =x;
YData1=r;
YData2=g;
YData3=b;


figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create patch
patch('DisplayName','Red','Parent',axes1,'YData',YData1,'XData',XData1,...
    'FaceAlpha',0.5,...
    'FaceColor',[1 0 0]);

% Create patch
patch('DisplayName','Green','Parent',axes1,'YData',YData2,'XData',XData1,...
    'FaceAlpha',0.5,...
    'FaceColor',[0 1 0]);

% Create patch
patch('DisplayName','Blue','Parent',axes1,'YData',YData3,'XData',XData1,...
    'FaceAlpha',0.5,...
    'FaceColor',[0 0 1]);

% Create ylabel
ylabel('Number of pixels');

% Create xlabel
xlabel('Value of pixels');
xlim(axes1,[50 200]);
% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[-2.07373271889402 297.926267281106]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 6000]);
box(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'FontWeight','bold','XGrid','on','YGrid','on');
% Create legend
legend(axes1,'show');


