% Authors - Basaran, Baumberger, Dietsch, Wert
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
