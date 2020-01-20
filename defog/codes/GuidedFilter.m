%   GUIDEDFILTER   O(1) time implementation of guided filter.
%
%   - guidance image: I (should be a gray-scale/single channel image)
%   - filtering input image: p (should be a gray-scale/single channel image)
%   - local window radius: r
%   - regularization parameter: eps

function q = GuidedFilter(I, p, r, eps)
    [hei, wid] = size(I);
    N = BoxFilter(ones(hei, wid), r); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.

    mean_I = BoxFilter(I, r) ./ N;
    mean_p = BoxFilter(p, r) ./ N;
    mean_Ip = BoxFilter(I.*p, r) ./ N;
    cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.

    mean_II = BoxFilter(I.*I, r) ./ N;
    var_I = mean_II - mean_I .* mean_I;

    a = cov_Ip ./ (var_I + eps); % Eqn. (5) in the paper;
    b = mean_p - a .* mean_I; % Eqn. (6) in the paper;

    mean_a = BoxFilter(a, r) ./ N;
    mean_b = BoxFilter(b, r) ./ N;

    q = mean_a .* I + mean_b; % Eqn. (8) in the paper;
end