% Authors - Basaran, Baumberger, Dietsch, Wert
function [modelParameters] = positionEstimatorTraining(training_data)
  % Arguments:
  
  % - training_data:
  %     training_data(n,k)              (n = trial id,  k = reaching angle)
  %     training_data(n,k).trialId      unique number of the trial
  %     training_data(n,k).spikes(i,t)  (i = neuron id, t = time)
  %     training_data(n,k).handPos(d,t) (d = dimension [1-3], t = time)
  
  % ... train your model
  
  % Return Value:
  
  % - modelParameters:
  %     single structure containing all the learned parameters of your
  %     model and which can be used by the "positionEstimator" function.
  
  %% Global variables setters 
    function setGlobalAngles(angles_list)
        global ANGLES_LIST;
        ANGLES_LIST = angles_list;
    end
    function setGlobalExtractionDuration(duration)
        global EXTRACTION_DURATION;
        EXTRACTION_DURATION = duration;
    end
    function setGlobalSlidingWindowDuration(duration)
        global SLIDING_WINDOW_DURATION;
        SLIDING_WINDOW_DURATION = duration;
    end
    function setGlobalOverlap(duration)
        global OVERLAP;
        OVERLAP = duration;
    end
    function setNbNeurons(trainingData)
        global NB_NEURONS;
        NB_NEURONS = size(trainingData(1,1).spikes,1);
    end
    function setNbFeatures()
        global NB_FEATURES;
        global NB_NEURONS;
        global EXTRACTION_DURATION;
        global SLIDING_WINDOW_DURATION;
        
        nb_sliding_windows = EXTRACTION_DURATION/SLIDING_WINDOW_DURATION;
        NB_FEATURES = nb_sliding_windows*NB_NEURONS;
    end

  %% Setting the global variables
  angles_list = [38/180*pi, 73/180*pi, 110/180*pi, 150/180*pi, 190/180*pi,...
  229/180*pi, 315/180*pi, 355/180*pi];
  extractionDuration = 300; %ms
  slidingWindowDuration = 100; %ms
  overlap = 80; %ms
  
  setGlobalAngles(angles_list);
  setGlobalExtractionDuration(extractionDuration);
  setGlobalSlidingWindowDuration(slidingWindowDuration);
  setGlobalOverlap(overlap);
  setNbNeurons(training_data);
  setNbFeatures();
  
  %% Extraction functions
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
    global NB_FEATURES;
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
  function [X] = extractFeaturesVectorsFromATrial(trial_spikes)
% This function will agregate every features vector that can be retrieved from
% a single trial in the matrix X.
% This function calls the function countSpikes
    
% Arguments:
% - trial_spikes, the spikes time series of a single trial
%
% Return Value:
% - X, the extracted matrix of vector features

    global EXTRACTION_DURATION;
    global OVERLAP;
    global NB_FEATURES;

    % Setting the number of input vectors that are going to be extracted
    trial_duration = size(trial_spikes,2);
    nb_extracted_data = fix((trial_duration - EXTRACTION_DURATION)/OVERLAP)+1;
    
    X = zeros(NB_FEATURES,nb_extracted_data);
    
    for i_data = 1:nb_extracted_data
        t_i = 1+(i_data-1) * OVERLAP;
        t_f = EXTRACTION_DURATION +(i_data-1) * OVERLAP;
        spikes = trial_spikes(:,t_i :t_f);
        X(:,i_data) = countSpikes(spikes,EXTRACTION_DURATION);   
    end 

  end
  function [M,Y] = extractFeaturesMatrixFromTrainingData(trainingData)
% This function will agregate every feature vectors that can be retrieved from
% every trial during the trainging in the features matrix X.
% This function will call the function extractFeaturesVectorsFromATrial
%
% Arguments:
% - trainingData, the training data
%
% Return Value:
% - M, the extracted matrix of features
% - y, the angles class (supposed to be equal to the angle bw starting point and target position) 

    M = [];
    Y = [];
    nb_trial = size(trainingData,1);
    nb_angle = size(trainingData,2);
    
    for i_trial = 1:nb_trial
        for i_angle = 1:nb_angle
            trial = trainingData(i_trial,i_angle).spikes;
            X = extractFeaturesVectorsFromATrial(trial);
            nb_data_extracted = size(X,2);
            y = ones(1,nb_data_extracted) * i_angle;
            M = [M X];
            Y = [Y y];
        end
    end
end
  
  %% Training
  [M,Y] = extractFeaturesMatrixFromTrainingData(training_data);
  modelParameters = [M;Y];
  
end