% Authors - Basaran, Baumberger, Dietsch, Wert
% Return the nearest neigbourgh class from the computed euclidean distances

function [angle_est,nn_idx] = nearest_neighbor(Y,euc_dist_vect)
    [~,nn_idx] = min(euc_dist_vect);
    angle_est = Y(nn_idx);
end