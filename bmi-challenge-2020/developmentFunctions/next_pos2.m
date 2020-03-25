% Authors - Basaran, Baumberger, Dietsch, Wert

function [x,y] = next_pos2(angle_est,v,prev_pos)
% Computes the next position from the estimated angle_est in radians, the time and the
% previous position prev_posd
    dt = 1;
    
    prev_pos_x = prev_pos(1);
    prev_pos_y = prev_pos(2);
    angle_in_rad = angle_est;
    x = prev_pos_x + cos(angle_in_rad) * v * dt;
    y = prev_pos_y + sin(angle_in_rad) * v * dt;
    
    
end