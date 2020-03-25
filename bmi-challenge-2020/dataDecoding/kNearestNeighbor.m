% Authors - Basaran, Baumberger, Dietsch, Wert




function [angle_est,nn_idx] = nearest_neighbor(Y,euc_dist_vect)
    [~,nn_idx] = min(euc_dist_vect);
    angle_est = Y(nn_idx);
end
