function [velocity_decoded] = calculateVelocitiesFromPositionVectors(X,Y)
%CALCULATEVELOCITIESFROMPOSITIONVECTORS Summary of this function goes here
%   Detailed explanation goes here
    global MAX_EXPERIMENT_DURATION;
    n = length(X);
    velocity_decoded = zeros(1,MAX_EXPERIMENT_DURATION);
    for i_pos = 1:n-1
        opposite = Y(1,i_pos+1)-Y(1,i_pos);
        adjacent = X(i_pos+1)-X(i_pos);
        velocity_decoded(i_pos) = sqrt(opposite^2+adjacent^2);
    end
    
end

