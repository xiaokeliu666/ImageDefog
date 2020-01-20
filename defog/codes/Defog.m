function J = Defog(img, maxA, omega)
    % Initialization
    winRatio = .01;
    eps = 10^-6;

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

    winLength = floor(max([3, width*winRatio, height*winRatio]));
    darkChannel = MinFilt2(minRGB, [winLength, winLength]);
    darkChannel(height, width) = 0;

    % Get the Atmospheric Light
    A = min([maxA, max(max(darkChannel))]);

    % Estimate the Transmission
    t = 255 - darkChannel * omega;
    T = double(t) / 255;

    % Compute Guided Filter
    r = winLength * 4;
    GFT = GuidedFilter(double(rgb2gray(img))/255, T, r, eps);

    % Get the Transmission
    T = GFT;

    % Defog Image
    J(:, :, 1) = (I(:, :, 1) - (1 - T) * A) ./ T;
    J(:, :, 2) = (I(:, :, 2) - (1 - T) * A) ./ T;
    J(:, :, 3) = (I(:, :, 3) - (1 - T) * A) ./ T;
end