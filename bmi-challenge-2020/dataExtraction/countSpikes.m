% Authors - Basaran, Baumberger, Dietsch, Wert

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
