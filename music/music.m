% u - teacher input
% D - teacher output
% lead - leading track (teach)
% accomp - accompanying track (teach)
netsize = 2000; % network size
start = 1;
timesteps = 20000; % total number of timesteps in the training set
numNotes = 36; %number of notes to represent (3 octaves + rest)
leadNumNotes = 63;
numDur = 16; % number of durations to represent
offset = 22; % the lowest note to be represented 
a = 1;
leadData = read_notes('VerySimpleESNToolbox/music/csv/all.csv',',',3);
accompData = read_notes('VerySimpleESNToolbox/music/csv/all.csv',',',2);
beat = read_beat('VerySimpleESNToolbox/music/csv/all.csv',',',4);
lead(start:start+timesteps-1) = leadData(1,start:start+timesteps-1);
lead_dur(start:start+timesteps-1) = leadData(2,start:start+timesteps - 1);
accomp(start:start+timesteps-1) = accompData(1,start:start+timesteps - 1);
accomp_dur(start:start+timesteps-1) = accompData(2,start:start+timesteps - 1);
u(1,1:14) = 0; % input for training
%u(1,1:17) = 0;

input_length = 2*5 + 2*1 + 2;
% input_length = 2*5 + 2*3 + 1 

output_length = numNotes + numDur + 1;
D = zeros(timesteps,output_length);
for i = 2:timesteps
    u(i,1) = 0.2; %bias 
    u(i,2:6) = noteToVector(accomp(i-1),offset, leadNumNotes);
    u(i,7) = durationToVector(accomp_dur(i-1));
    u(i,8:12) = noteToVector(lead(i-1),offset,leadNumNotes);
    u(i,13) = durationToVector(lead_dur(i-1));
    u(i,14) = beat(i-1);
    %u(i,7:9) = durationToVector(accomp_dur(i-1));
    %u(i,10:14) = noteToVector(lead(i-1),offset,leadNumNotes);
    %u(i,15:17) = durationToVector(lead_dur(i-1));
    
    D(i,1:numNotes+1) = teachNote(accomp(i),offset,numNotes);
    D(i,numNotes+2:output_length) = teachDur(accomp_dur(i),numDur);
end
W = rand(netsize,netsize); % initialize Reservoir Weight matrix
m = max(abs(eig(W))); % spectral radius
W = (0.5/m)*W; % scale Weight matrix to make max(abs(eig(W))) = 0.95
Win(1:netsize,1) = randi([-1 1], netsize,1);
Win(1:netsize,2:input_length-1) = 0.5*(2*rand(netsize,input_length-2) - 1); % input to network weights
Win(1:netsize,input_length) = 0.5*(2*rand(netsize,1) - 1);
Wfb(1:netsize,1:output_length) =  0; % output to network weights
X(1,1:netsize) = 2*rand(netsize,1)-1; %initial state
%train
for i = 1:timesteps-1
    X(i+1,:) = (1 - a)*X(i,:)' + tanh(W*X(i,:)' + Win*u(i+1,:)' + Wfb*D(i,:)'); % + Wfb*D(i,:)'
end

% Learn the output weights
R = X'*X;
P = X'*D;
Wout =((R+1.5*eye(netsize))\P)';

