e = 0;
n = length(outputMelody);
for i = 1:n
    correct = noteToVector(accompDurations(i),offset,leadNumNotes);
    out = noteToVector(outputDurations(i),offset,leadNumNotes);
    d = norm(correct - out);
    if d > 0
        e = e + d;
    end
end
e = e/n