% Run the network
s = 85000;
e = 95000;
leadingMelody = leadData(1,s:e);
leadingDurations = leadData(2,s:e);
accompMelody = accompData(1, s:e);
accompDurations = accompData(2, s:e);
totalTime = size(leadingMelody,2);
%initial input/output

selectedNote = accompMelody(1);
selectedDur = accompDurations(1);

input(1) = 0.2; % bias
input(2:6) = noteToVector(selectedNote,offset,numNotes);
input(7) = durationToVector(selectedDur);
input(8:12) = noteToVector(leadingMelody(1),offset,leadNumNotes);
input(13) = durationToVector(leadingDurations(1));

outputMelody=zeros(1,totalTime);
outputDurations=zeros(1,totalTime);
outputMelody(1:totalTime) = 0;
outputDurations(1:totalTime) = 1;

input(14) = beat(1);

selectedNote = accompMelody(2);
selectedDur = accompDurations(2);

Wv(1:netsize,1:input_length) = 0.5*(2*rand(netsize,input_length) - 1);

X1 = zeros(totalTime,netsize);
count = 0;
for i = 1:totalTime-1
    input(2:6) = noteToVector(selectedNote,offset,numNotes);
    input(7) = selectedDur;
    input(8:12) = noteToVector(leadingMelody(i),offset,leadNumNotes);
    input(13) = leadingDurations(i);
   
    input(14) = beat(i);
    
    outputMelody(i+1) = selectedNote;
    outputDurations(i+1) = selectedDur;
    
    
    v = 0.00001*(2*(rand(input_length,1) - 1));
    X1(i+1,:) = (1-a)*X1(i,:)' + a*tanh(W*X1(i,:)' + Win*input' + Wv*v); % + Wfb * Y
    %% SECTION TITLE
    % DESCRIPTIVE TEXT
    outputP = zeros(totalTime,output_length);
    if count == 0
        Yout = tanh(Wout*X1(i+1,:)');
        outputP(i+1,1:numNotes+1) = P(Yout(1:numNotes+1));
        outputP(i+1,numNotes+2:end) = P(Yout(numNotes+2:end));
        selectedNote = select(Yout(1:numNotes+1),offset,1);
        
        if selectedNote < offset %selected the first neuron (rest)
            selectedNote = 0;
        end
   
        selectedDur = select(Yout(numNotes+2:output_length),1,1)+1;
        count = selectedDur;
        
    end
    % Next input
    
    if count > 0
        count = count - 1;
    end
end

