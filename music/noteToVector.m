% This function takes a midi representation of a note (integer, where 60
% represents the middle C, and the distance between any 2 consecutive
% numbers is a half tone), and converts it into a 5 dimensional vector,
% which will be used as input:
% The 1st coordinate will have values proportional to the log of the
% frequency of the note being represented.
% The 2nd and 3rd coordinates will be x,y coordinates in the chroma circle
% The 4th and 5th coordinates will be x,y coordinates in the circle of
% fifths.

function y = noteToVector(x,offset,total)
% minNote and maxNote are the lowest and highest note (respectively) that
% we want to represent
if x == 0
    y = [0,0,0,0,0];
else
    minNote = offset;
    maxNote = offset + total - 1;
    % chroma conatiains the position of each note in the chroma circle
    % (numbered  1:12). They are given in natural order. i.e: the first element
    % specifies the order of C, in the circle, the second that of C# and so on.
    chroma = [1,2,3,4,5,6,7,8,9,10,11,12];
    Rch = 1;
    % In the same way as chroma, c5, contains the position of each note on the
    % circle of fifths.
    c5 = [1,8,3,10,5,12,7,2,9,4,11,6];
    Rc5 = 1;

    note = mod(x-60,12) + 1;
    chromaAngle = (chroma(note) - 1)*(360/12);
    c5Angle = (c5(note) - 1)*(360/12);
    chromaX = Rch*sind(chromaAngle);
    chromaY = Rch*cosd(chromaAngle);
    c5X = Rc5*sind(c5Angle);
    c5Y = Rc5*cosd(c5Angle);

    % n is the distance (in semitones) of the note from A4 (69 in midi), whose
    % frequency is 440 Hz. fx is the frequency of the note.
    n = x - 69;
    fx = 2^(n/12)*440;
    % p is the pitch representation in our vector
    minP = 2*log2(2^((minNote - 69)/12)*440);
    maxP = 2*log2(2^((maxNote - 69)/12)*440);
    % we scale the representation of pitch in such a way that a pitch distance of 1
    % octave in the first dimension is equal to the distance of notes on the
    % oposite sides on the chroma circle or the circle of fifths.
    p = 2*log2(fx) - maxP + (maxP - minP)/2;
    y = [p, chromaX,chromaY,c5X,c5Y];
end
end
