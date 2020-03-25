% Authors - Basaran, Baumberger, Dietsch, Wert

function X = extractSpikesTimeSeriesFromTestData(test_trial)
% Return the last EXTRACTION_DURATION (ms) of the tested data
%
% Argument:
% - test_trial, the trial that has been fed in positionEstimator
%
% Return Value:
% - X, the extracted matrix

global EXTRACTION_DURATION;

    spikes = test_trial.spikes;
    trial_duration = size(spikes,2);
    t_i = trial_duration - EXTRACTION_DURATION + 1;
    X = spikes(:,t_i:end);
end