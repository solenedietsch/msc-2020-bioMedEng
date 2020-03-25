clear all; close all;
load monkeydata_training.mat
% Set random number generator
rng(2013);
ix = randperm(length(trial));

% Select training and testing data (you can choose to split your data in a different way if you wish)
trainingData = trial(ix(1:10),:);
testData = trial(ix(91:end),:);
neuron = 1;
angle = 1;
training_trial_one =  trainingData(1,1).handPos;
angles = [0,20/180*pi,10/180*pi,30/180*pi,40/180*pi,50/180*pi,60/180*pi,70/180*pi,80/180*pi,90/180*pi ,110/180*pi, 150/180*pi, 180/180*pi,...
120/180*pi, 120/180*pi, 140/180*pi,160/180*pi, 170/180*pi,-120/180*pi, -130/180*pi, -140/180*pi,160/180*pi, -170/180*pi...
230/1-10/180*pi,-20/180*pi,-30/180*pi,-40/180*pi,-50/180*pi,-60/180*pi,-70/180*pi,-80/180*pi,-90/180*pi ,-110/180*pi, -150/180*pi,];

X = training_trial_one(1,:);
Y = training_trial_one(2,:);
n = length(X);

[angles_decoded,velocity_decoded] = decode_angles_from_training_data(X,Y,angles);
prev_pos = [X(1),Y(1)];
X_e = [X(1)];
Y_e = [Y(1)];
plot(X_e,Y_e,"go");
hold on;
for i = 1:n-1
    angles_decoded(i);
    [x_e,y_e] = next_pos2(angles,angles_decoded(i),velocity_decoded(i),prev_pos);
    X_e = [X_e  x_e];
    Y_e = [Y_e  y_e];
    prev_pos = [x_e,y_e];
end

figure(1);
plot(X,Y,'r+')
hold on;
plot(X_e,Y_e,'b+')
