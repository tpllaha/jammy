% converts a network output to probabilities
function y = P(x)
    F = 4;   % favor factor
    y = zeros(length(x),1);
    for i=1:length(x)
        if x(i) < 0
            x(i) = 0;
        else
            x(i) = x(i)^F;
        end
    end
    s = sum(x(:));
    y(:) = (1/s)*x(:);