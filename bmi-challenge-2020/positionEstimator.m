% Authors - Basaran, Baumberger, Dietsch, Wert
function [x, y] = positionEstimator(test_data, modelParameters)
  % **********************************************************
  %
  % You can also use the following function header to keep your state
  % from the last iteration
  %
  % function [x, y, newModelParameters] = positionEstimator(test_data, modelParameters)
  %                 ^^^^^^^^^^^^^^^^^^
  % Please note that this is optional. You can still use the old function
  % declaration without returning new model parameters. 
  %
  % *********************************************************

  % - test_data:
  %     test_data(m).trialID
  %         unique trial ID
  %     test_data(m).startHandPos
  %         2x1 vector giving the [x y] position of the hand at the start
  %         of the trial
  %     test_data(m).decodedHandPos
  %         [2xN] vector giving the hand position estimated by your
  %         algorithm during the previous iterations. In this case, N is 
  %         the number of times your function has been called previously on
  %         the same data sequence.
  %     test_data(m).spikes(i,t) (m = trial id, i = neuron id, t = time)
  %     in this case, t goes from 1 to the current time in steps of 20
  %     Example:
  %         Iteration 1 (t = 320):
  %             test_data.trialID = 1;
  %             test_data.startHandPos = [0; 0]
  %             test_data.decodedHandPos = []
  %             test_data.spikes = 98x320 matrix of spiking activity
  %         Iteration 2 (t = 340):
  %             test_data.trialID = 1;
  %             test_data.startHandPos = [0; 0]
  %             test_data.decodedHandPos = [2.3; 1.5]
  %             test_data.spikes = 98x340 matrix of spiking activity

  % ... compute position at the given timestep.
  
  % Return Value:
  
  % - [x, y]: % x - position along the x axis, y - position along the y axis 
  %     current position of the hand
  
  global EXTRACTION_DURATION;
  global NB_FEATURES;
  
  %% Decoding functions
  function X = extractSpikesTimeSeriesFromTestData(test_trial)
% Return the last EXTRACTION_DURATION (ms) of the tested data
%
% Argument:
% - test_trial, the trial that has been fed in positionEstimator
%
% Return Value:
% - X, the extracted matrix

    spikes = test_trial.spikes;
    trial_duration = size(spikes,2);
    t_i = trial_duration - EXTRACTION_DURATION + 1;
    X = spikes(:,t_i:end);
end
  function x = countSpikes(spikesTimeSeries,duration)
% This function returns a vector x(i), containing the spike counts for
% each neuron every SLIDING_WINDOW_DURATION (ms) during the duration
% 
% Arguments:
% - spikesTimeSeries
% - duration
%
% Return Value:
% - x, vector x(i) counting the spikes for each neuron every SLIDING_WINDOW_DURATION

    global SLIDING_WINDOW_DURATION;
    global NB_NEURONS;
    
    nb_sliding_windows = duration/SLIDING_WINDOW_DURATION;
    x = zeros(NB_FEATURES,1);
    feature_idx = 1;
    
    for i_window = 1:nb_sliding_windows
        for i_neuron = 1:NB_NEURONS
            
            t_i = (i_window-1)*SLIDING_WINDOW_DURATION+1;
            t_f = i_window*SLIDING_WINDOW_DURATION;

            x(feature_idx) = sum(spikesTimeSeries(i_neuron,t_i : t_f));
            feature_idx = feature_idx + 1;
        end
    end
  end
  function euclidean_dist_vect = calculateEucDistBwTrainingMatrixAndTestVector(M,X_test)
% Return a vector of the computed euclidean distance b/w the features 
% matrix and the tested features vector
% 
% Arguments:
% - M, the features matrix
% - X_test, the tested features vector
%
% Return Value:
% - euclidean_dist_vect, the vector of the calculated euclidean distances

    nb_training_data = size(M,2);
    euclidean_dist_vect = zeros(1,nb_training_data);
    for i_data = 1:nb_training_data
        P = M(:,i_data)-X_test;
        euclidean_dist_vect(i_data) = sqrt(P'*P);
    end
  end
  function [angle_predicted_class] = kNearestNeighbor(k,classes_vector,euc_dist_vect)
% Return the k-nearest neigbourgh class from the computed euclidean distance
%
% Arguments:
% - k, number of neighbors
% - classes_vector, the vectors of the corresponding angle classes of the training data
% - euc_dist_vect,the vector of the calculated euclidean distances
%
% Return Value:
% - angle_predicted_class, the class of the angle predicted

k_nn_angle_est = zeros(1,k);    

% Sort the euclidean distances in order to have the min distances at the
% beggining
euc_dist_vect_sorted = sort(euc_dist_vect);

% Observe the k nearest neighbors
    for i_k = 1:k
        nn_idx = euc_dist_vect == euc_dist_vect_sorted(i_k);
        nn_angle_idx = find(nn_idx.*classes_vector);
        k_nn_angle_est(i_k) = classes_vector(nn_angle_idx(1));
    end
    [GC,GR] = groupcounts(k_nn_angle_est');
    [~,idx] = max(GC);
    angle_predicted_class = GR(idx);
  end
  function [x,y] = calculateNextPostionFromAnglePrediction(angle_prediction,t,previous_position)
% Computes the next position from the estimated angle angle_est, the time and the
% previous position prev_pos

% Arguments:
% - angle_prediction, the angle that has been predicted via K - nearest
% neighbor algorithm
% - t, the length of the test_data.decodedHandPos
% - previous_position, the initial position
%
% Return Value:
% - x, the new position abscissa
% - y, the new position ordinate

    global ANGLES_LIST;
    % Calulating the corresponding time of the position to be predicted
    dt = 20;
    current_time =300+dt*t;
    % Coeff obtained by polyfit on the average of the velocity through the
    % trials
    v_coeff = [6.68104039494441e-16,...
              -2.02813402602335e-12,...
              2.58365394257859e-09,...
              -1.78530956559538e-06,...
              0.000720300126509312,...
              -0.169032693530307,...
              21.2668938957257,...
              -1099.95309178192];
          
    v = polyval(v_coeff,current_time);
  
    prev_pos_x = previous_position(1);
    prev_pos_y = previous_position(2);
    angle_in_rad = ANGLES_LIST(angle_prediction);
    x = prev_pos_x + cos(angle_in_rad) * v * dt;
    y = prev_pos_y + sin(angle_in_rad) * v * dt;

    if sqrt((x+9)^2+(y+5)^2) > 97
        x = prev_pos_x;
        y = prev_pos_y;
    end
    
  end

function [angle_est,nn_idx] = nearest_neighbor(Y,euc_dist_vect)
    [~,nn_idx] = min(euc_dist_vect);
    angle_est = Y(nn_idx);
end
  %% Decoding
  
  M =  modelParameters(1:NB_FEATURES,:);
  training_classes_vec = modelParameters(end,:);
   
  % Extract the last EXTRACTION_DURATION data from the tiral to be tested
  trial_decoded = extractSpikesTimeSeriesFromTestData(test_data);
  
  % Format the data as a corresponding features vector that is going to be decoded
  X_test = countSpikes(trial_decoded,EXTRACTION_DURATION);
  
  % Compute the distance b/w the testData features Vector and the training
  % matrix features
  euc_dist_vect = calculateEucDistBwTrainingMatrixAndTestVector(M,X_test);
  
  % Estimates the angle via the k-nearest neighbor algorithm
  k = 11;
  angle_predicted_class = nearest_neighbor(training_classes_vec,euc_dist_vect);
  
  % Set the first position to be the startHandPos if it's the first
  % position that is going to be decoded 
  if isempty(test_data.decodedHandPos)
    init_pos = test_data.startHandPos;
  else
    init_pos = test_data.decodedHandPos(:,end);
    
  end
  t = length(test_data.decodedHandPos) + 1;
  
  % Decode the new hand position 
  [x,y] = calculateNextPostionFromAnglePrediction(angle_predicted_class,t,init_pos);
  
end