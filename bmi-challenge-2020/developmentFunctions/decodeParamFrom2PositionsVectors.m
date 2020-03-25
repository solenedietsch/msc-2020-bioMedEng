function [angles_decoded,velocity_decoded] = decodeParamFrom2PositionsVectors(X,Y)
    global ANGLES_LIST;
    
    n = length(X);
    angles_decoded = zeros(1,n);
    velocity_decoded = zeros(1,n);
    for i_pos = 1:n-1
        
        opposite = Y(1,i_pos+1)-Y(1,i_pos);
        adjacent = X(i_pos+1)-X(i_pos);
        angle_decoded = atan2(opposite,adjacent);
        [~,idx] = min(abs(ANGLES_LIST - angle_decoded));
        angles_decoded(i_pos) = ANGLES_LIST(idx);

        velocity_decoded(i_pos) = sqrt(opposite^2+adjacent^2);
    end
    
end