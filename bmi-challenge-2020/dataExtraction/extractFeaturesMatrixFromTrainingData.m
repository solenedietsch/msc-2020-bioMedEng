% Authors - Basaran, Baumberger, Dietsch, Wert

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