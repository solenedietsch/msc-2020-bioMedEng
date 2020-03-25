% Authors - Basaran, Baumberger, Dietsch, Wert

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