
% u - teacher input
% D - teacher output
% lead - leading track (teach)
% accomp - accompanying track (teach)
netsize = 2000; % network size
start = 1;
timesteps = 90000; % total number of timesteps in the training set
data = read_mixed_csv('music/csv/rock-70songs.csv',',');
leadData = read_notes(data,2);
accompData = read_notes(data,3);
beat = read_beat(data,4);
lead(start:start+timesteps-1) = leadData(1,start:start+timesteps-1);
lead_dur(start:start+timesteps-1) = leadData(2,start:start+timesteps - 1);
accomp(start:start+timesteps-1) = accompData(1,start:start+timesteps - 1);
accomp_dur(start:start+timesteps-1) = accompData(2,start:start+timesteps - 1);

u(1,1:14) = 0; % input for training
%u(1,1:17) = 0;


a = 0.995; % leak
offset = min(accomp(accomp>0));
numNotes = max(accomp) - offset + 1;
leadNumNotes = max(lead) - offset + 1;
numDur = 16;


input_length = 2*5 + 2*1 + 2; 

output_length = numNotes + numDur + 1;
D = zeros(timesteps,output_length);

for i = 2:timesteps
    u(i,1) = 0.2; %bias
    
    u(i,2:6) = noteToVector(accomp(i-1),offset, leadNumNotes);
    u(i,7) = durationToVector(accomp_dur(i-1));
    
    u(i,8:12) = noteToVector(lead(i-1),offset,leadNumNotes);
    u(i,13) = durationToVector(lead_dur(i-1));
    
    u(i,14) = beat(i-1);
  
    D(i,1:numNotes+1) = teachNote(accomp(i),offset,numNotes);
    D(i,numNotes+2:output_length) = teachDur(accomp_dur(i),numDur);
end
W = rand(netsize,netsize); % initialize Reservoir Weight matrix
m = max(abs(eig(W))); % spectral radius
W = (0.5/m)*W; % scale Weight matrix to make max(abs(eig(W))) = 0.95
Win(1:netsize,1) = randi([-1 1], netsize,1);
Win(1:netsize,2:7) = 0.8*(2*rand(netsize,6) - 1); % input to network weights
Win(1:netsize,8:13) = (2*rand(netsize,6) - 1);
Win(1:netsize,input_length) = 0.8*(2*rand(netsize,1) - 1);

X = zeros(timesteps,netsize);
X(1,1:netsize) = 2*rand(netsize,1)-1; %initial state
%train
for i = 1:timesteps-1
    X(i+1,:) = tanh(W*X(i,:)' + Win*u(i+1,:)'); % + Wfb*D(i,:)'
    
end

% Learn the output weights
R = X'*X;
%P = X'*D;
P1 = X'*D(:,1:numNotes+1);
P2 = X'*D(:,numNotes+2:end);
Wout = zeros(output_length,netsize);
Wout(1:numNotes+1,:) =((R+1.5*eye(netsize))\P1)';
Wout(numNotes+2:end,:) =((R+1*eye(netsize))\P2)';

