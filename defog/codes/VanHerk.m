%  VANHERK    Fast max/min 1D filter
%
%    Y = VANHERK(X,N,TYPE) performs the 1D min filtering of the row
%    vector X using a N-length filter.
%    This function uses the van Herk algorithm for min filters that demands
%    only 3 min calculations per element, independently of the filter size.
%    
%    It only keep codes (min filter) related with the Defog algorithm.
%
%    If X is a 2D matrix, each row will be filtered separately.
%    
%    Y = VANHERK(...,'col') performs the filtering on the columns of X.
%    
%    Y = VANHERK(...,'shape') returns the subset of the filtering specified
%    by 'shape' :
%        'full'  - Returns the full filtering result,
%        'same'  - (default) Returns the central filter area that is the
%                   same size as X,
%        'valid' - Returns only the area where no filter elements are outside
%                  the image.
%
%    X can be uint8 or double. If X is uint8 the processing is quite faster, so
%    dont't use X as double, unless it is really necessary.

function Y = VanHerk(X, N, varargin)
    [direc, shape] = parseInputs(varargin{:});
    if strcmp(direc, 'col')
        X = X';
    end

    % Correcting X size
    fixsize = 0;
    addel = 0;
    if mod(size(X, 2), N) ~= 0
        fixsize = 1;
        addel = N - mod(size(X, 2), N);
        f = [X repmat(X(:, end), 1, addel)];
    else
        f = X;
    end
    lf = size(f, 2);
    lx = size(X, 2);
    clear X;

    % Declaring aux. mat.
    g = f;
    h = g;

    % Filling g & h (aux. mat.)
    ig = 1 : N : size(f, 2);
    ih = ig + N - 1;

    g(:, ig) = f(:, ig);
    h(:, ih) = f(:, ih);

    for i = 2 : N
        igold = ig;
        ihold = ih;

        ig = ig + 1;
        ih = ih - 1;

        g(:, ig) = min(f(:, ig), g(:, igold));
        h(:, ih) = min(f(:, ih), h(:, ihold));
    end
    clear f;

    % Comparing g & h
    if strcmp(shape, 'full')
        ig = (N : 1 : lf);
        ih = (1 : 1 : lf-N+1);
        if fixsize
            Y = [g(:, 1 : N-1) min(g(:, ig), h(:, ih)) h(:, end-N+2 : end-addel)];
        else
            Y = [g(:, 1 : N-1) min(g(:, ig), h(:, ih)) h(:, end-N+2 : end)];
        end
    elseif strcmp(shape, 'same')
        if fixsize
            if addel > (N-1)/2
                ig = (N : 1 : lf-addel+floor((N-1)/2));
                ih = (1 : 1 : lf-N+1-addel+floor((N-1)/2));
                Y = [g(:, 1+ceil((N-1)/2) : N-1) min(g(:, ig), h(:, ih))];
            else   
                ig = (N : 1 : lf);
                ih = (1 : 1 : lf-N+1);
                Y = [g(:, 1+ceil((N-1)/2) : N-1) min(g(:, ig), h(:, ih)) h(:, lf-N+2 : lf-N+1+floor((N-1)/2)-addel)];
            end            
        else % not fixsize (addel=0, lf=lx)
            ig = (N : 1 : lx);
            ih = (1 : 1 : lx-N+1);
            Y = [g(:, N-ceil((N-1)/2) : N-1) min(g(:, ig), h(:, ih)) h(:, lx-N+2 : lx-N+1+floor((N-1)/2))];
        end      
    elseif strcmp(shape, 'valid')
        ig = (N : 1 : lx);
        ih = (1 : 1 : lx-N+1);
        Y = (min(g(:, ig), h(:, ih)));
    end

	if strcmp(direc, 'col')
        Y = Y';
	end
end

function [direc, shape] = parseInputs(varargin)
    direc = 'lin';
    shape = 'same';
    flag = [0 0]; % [dir shape]

    for i = 1 : nargin
        t = varargin{i};
        if strcmp(t, 'col') && flag(1) == 0
            direc = 'col';
            flag(1) = 1;
        elseif strcmp(t, 'full') && flag(2) == 0
            shape = 'full';
            flag(2) = 1;
        elseif strcmp(t, 'same') && flag(2) == 0
            shape = 'same';
            flag(2) = 1;
        elseif strcmp(t, 'valid') && flag(2) == 0
            shape = 'valid';
            flag(2) = 1;
        else
            error(['Too many / Unkown parameter: ' t ]);
        end
    end
end