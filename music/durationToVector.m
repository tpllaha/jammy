% duration is measured in 16th notes.
% durationToVector takes a duration as a number of 16th notes and returns a
% 3 dimensional representation, where the first dimension measures the log
% of the duration, and the other two are coordinates in the 1/4 beat cycle.
function y = durationToVector(x)

y = x;

%height = log(x);
%position4 = mod(x,4);
%angle4 = 45 + position4*90;
%R4 = 1; %radius of 1/4 beat circle
%x4 = R4*sind(angle4);
%y4 = R4*cosd(angle4);
%y = [height, x4,y4];
end