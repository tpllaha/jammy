% duration is measured in 16th notes.
% durationToVector takes a duration as a number of 16th notes and returns a
% 5 dimensional representation, where the first dimension measures the log
% of the duration, and the other 4 are x,y coordinates in the 1/3 beat cycle
% and in the 1/4 beat cycle.
function y = durationToVector(x)
    if x == 0
        y = 0;
    else
        y = (4/log2(16))*log2(x) + 1;      
    end
end