% Run the network
leadingMelody = leadData(1,1:timesteps);
leadingDurations = leadData(2,1:timesteps);
accompMelody = accompData(1, 1:timesteps);
accompDurations = accompData(2, 1:timesteps);
totalTime = size(leadingMelody,2);
%initial input/output

selectedNote = accompMelody(1);
selectedDur = accompDurations(1);

input(1) = 0.2; % bias
input(2:6) = noteToVector(selectedNote,offset,numNotes);
input(7) = selectedDur;
input(8:12) = noteToVector(leadingMelody(1),offset,leadNumNotes);
input(13) = leadingDurations(1);
input(14) = beat(1);
%input(7:9) = durationToVector(selectedDur);
%input(10:14) = noteToVector(leadingMelody(1),offset,leadNumNotes);
%input(15:17) = durationToVector(leadingDurations(1));
outputMelody(1:totalTime) = 0;
outputDurations(1:totalTime) = 1;

selectedNote = accompMelody(2);
selectedDur = accompDurations(2);

Y = zeros(6,1);
Y(1:5) = noteToVector(selectedNote,offset,leadNumNotes);
Y(6) = durationToVector(selectedDur);

X = zeros(totalTime,netsize);
count = 0;
for i = 1:totalTime-1
    input(2:6) = noteToVector(selectedNote,offset,numNotes);
    input(7) = selectedDur;
    input(8:12) = noteToVector(leadingMelody(i),offset,leadNumNotes);
    input(13) = leadingDurations(i);
    input(14) = beat(i);
    %input(2:6) = noteToVector(selectedNote,offset,leadNumNotes);
    %input(7:9) = durationToVector(selectedDur);
    %input(10:14) = noteToVector(leadingMelody(i+1),offset,leadNumNotes);
    %input(15:17) = durationToVector(leadingDurations(i+1));
    
    outputMelody(i+1) = selectedNote;
    outputDurations(i+1) = selectedDur;
    
    
    
    X(i+1,:) = (1-a)*X(i,:)' + tanh(W*X(i,:)' + Win*input' + Wfb*Y); % + Wfb * Y
    %% SECTION TITLE
    % DESCRIPTIVE TEXT
    
    if count == 0 
        Yout = tanh(Wout*X(i+1,:)');
        selectedNote = select(Yout(1:numNotes+1),offset,1);
        if selectedNote < offset %selected the first neuron (rest)
            selectedNote = 0;
        end
   
        selectedDur = select(Yout(numNotes+2:output_length),1,1)+1;
        count = selectedDur;
        
        Y(1:5) = noteToVector(selectedNote,offset,leadNumNotes);
        Y(6) = durationToVector(selectedDur);
    end
    % Next input
    
    if count > 0
        count = count - 1;
    end
end

