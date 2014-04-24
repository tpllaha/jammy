function y = teachDur(dur, total)
if dur > total || dur < 1
    err = MException('DurChk:OutOfRange', ...
        'Duration is outside expected range');
    throw(err);
end
y(1:dur-1) = 0;
y(dur) = 1;
y(dur+1:total) = 0;
end