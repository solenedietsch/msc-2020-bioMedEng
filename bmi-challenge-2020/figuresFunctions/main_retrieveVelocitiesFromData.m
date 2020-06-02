clear all;close all;
load monkeydata_training.mat

global MAX_EXPERIMENT_DURATION;
MAX_EXPERIMENT_DURATION = 975;

nb_trials = size(trial,1);
nb_angles = size(trial,2);
nb_trials_in_total = nb_angles*nb_trials;
% nb_trials = 1;
% nb_angles = 1;

velocities_matrix = zeros(nb_trials_in_total,MAX_EXPERIMENT_DURATION);

time = 1:MAX_EXPERIMENT_DURATION;
times = ones(nb_trials_in_total,MAX_EXPERIMENT_DURATION).*time;
idx = 1;

for i_trial = 1:nb_trials
    for i_angle = 1:nb_angles
        handPos = trial(i_trial,i_angle).handPos;
        
        X = handPos(1,:);
        Y = handPos(2,:);
        %figure(1);
        %plot(X,Y);hold on;
        
        velocities_vector = calculateVelocitiesFromPositionVectors(X,Y);
        velocities_matrix(idx,:) =  velocities_matrix(idx,:) + velocities_vector;
        idx = idx + 1;
        
    end
end

figure(2)
plot(time,velocities_matrix);
avg_velocities = mean(velocities_matrix);
hold on;
plot(time,avg_velocities,'g','LineWidth',3);

figure(3)
small_duration = 310:600;
plot(time(small_duration),avg_velocities(small_duration),'g','LineWidth',3);
hold on;
order = 7;
times_order = ones(order+1,length(time));
for i_order = 1:order
    times_order(end-i_order,:) = time.^i_order;
end

p = polyfit(time(small_duration),avg_velocities(small_duration),order);

plot(time(small_duration),p*times_order(:,small_duration),'r');