% Initialization
winRatio = .01;
maxA = 220;
omega = 0.95;
eps = 10^-6;
adr = 'Test Images\';
imageNo = 17;
imageAdr = [adr, 'Fogs\0', int2str(imageNo), '.jpg'];
img = imread(imageAdr); % Load Image
figure, imshow(uint8(img)), title('Original Image');

s = size(img);
width = s(2);
height = s(1);
minRGB = zeros(height, width);

I = double(img); % Original Image
J = zeros(height, width, 3); % Image After Defog

% Compute Dark Channel
for x = 1 : width
	for y = 1 : height
        minRGB(y, x) = min(img(y, x, :));
	end
end

figure, imshow(uint8(minRGB)), title('Min(R,G,B)');
winLength = floor(max([3, width*winRatio, height*winRatio]));
darkChannel = MinFilt2(minRGB, [winLength, winLength]);
darkChannel(height, width) = 0;
figure, imshow(uint8(darkChannel)), title('Dark Channel');

% Get the Atmospheric Light
A = min([maxA, max(max(darkChannel))]);

% Estimate the Transmission
t = 255 - darkChannel * omega;
figure, imshow(uint8(t)), title('Transmission');
T = t / 255;

% Compute Guided Filter
r = winLength * 4;
GFT = GuidedFilter(double(rgb2gray(img))/255, T, r, eps);

% Get the Transmission
T = GFT;
figure, imshow(T, []), title('Filtered Transmission');

% Defog Image
J(:, :, 1) = (I(:, :, 1) - (1 - T) * A) ./ T;
J(:, :, 2) = (I(:, :, 2) - (1 - T) * A) ./ T;
J(:, :, 3) = (I(:, :, 3) - (1 - T) * A) ./ T;

% Output result
imageAdr = [adr, 'Defogs\0', int2str(imageNo), '.bmp'];
imwrite(uint8(J), imageAdr);
figure, imshow(uint8(J)), title('Defog Image');