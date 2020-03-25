clear all; close all;
%% Data laoding
load monkeydata_training.mat

% Set random number generator
rng(2013);
ix = randperm(length(trial));

% Select training and testing data (you can choose to split your data in a different way if you wish)
trainingData = trial(ix(1:10),:);
testData = trial(ix(91:end),:);


%% Visualizing the data
neuron = 1;
angle = 1;
training_trial_one =  trainingData(1,1).spikes;
%figure(1);
rastergram(training_trial_one);
%% 
trial_one_short = training_trial_one(:,1:320);
%figure(2);
rastergram(trial_one_short);
%% STEP 1 : for each trial we retrieve the spikes count --> 0 to 320ms 
sliding_window_length = 40;
yi = spike_count(trial_one_short,sliding_window_length);
% test 1
sum(yi) == sum(trial_one_short,'all')

%% STEP 2 : retrieve the features for one entire trial
sliding_window_length = 40;
%window = 320;
X = data_extraction_1trial(training_trial_one);

figure(1);
max_spike = max(max(X));
imshow(X,'DisplayRange',[0 max_spike],'Colormap',parula);
colorbar;

%% STEP 2 : retrieve the features for every trial in the training data
sliding_window_length = 40;
%window = 320;
[M,Y] = data_extraction(trainingData);
figure(2);
max_spike = max(max(X));
imshow(M,'DisplayRange',[0 max_spike],'Colormap',parula);
colorbar;

figure(3);
nb_angles = max(max(Y));
imshow(Y,'DisplayRange',[0 nb_angles],'Colormap',parula);
colorbar;
%% Implementation of the K-nearest neighbour
testData = trial(ix(91:end),:);
test_trial_one = testData(1,1);

%% Step 1 - Extract the last 320ms from the data
trial_one_decoded = decode_extract_data(test_trial_one);
figure(4);
rastergram(trial_one_decoded);
%% Step 2 - Extract the features vector
X_test = spike_count(trial_one_decoded,sliding_window_length);
figure(4);
plot(X_test);
%size(X_test)
%% Step 3 - Compute the euclidean distance comparing all the training data to the
% testing sample
euc_dist_vect = dist_to_training(M,X_test);
figure(5);
plot(euc_dist_vect);

%% Step 4 - Extracting the nearest neighbour class
[angle_est,nn_idx] = nearest_neighbor(Y,euc_dist_vect);

%% Step 5 - Compute the next position 
v = 1; %%the speed
angles = [30/(180*pi), 70/180*pi, 110/180*pi, 150/180*pi, 190/180*pi,...
230/180*pi, 310/180*pi, 350/180*pi];
angles(1)
init_pos = [0,0];

next_pos(angles,angle_est,v,init_pos);
