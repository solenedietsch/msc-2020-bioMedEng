% Authors - Basaran, Baumberger, Dietsch, Wert

function [x,y] = calculateNextPostionFromAnglePrediction(angle_prediction,t,previous_position)
% Computes the next position from the estimated angle angle_est, the time and the
% previous position prev_pos

% Arguments:
% - angle_prediction, the angle that has been predicted via K - nearest
% neighbor algorithm
% - t, the length of the test_data.decodedHandPos
% - previous_position, the initial position
%
% Return Value:
% - x, the new position abscissa
% - y, the new position ordinate

    global ANGLES_LIST;
    % Calulating the corresponding time of the position to be predicted
    dt = 20;
    current_time =300+dt*t;
    % Coeff obtained by polyfit on the average of the velocity through the
    % trials
    v_coeff = [6.68104039494441e-16,...
              -2.02813402602335e-12,...
              2.58365394257859e-09,...
              -1.78530956559538e-06,...
              0.000720300126509312,...
              -0.169032693530307,...
              21.2668938957257,...
              -1099.95309178192];
          
    v = polyval(v_coeff,current_time);
  
    prev_pos_x = previous_position(1);
    prev_pos_y = previous_position(2);
    angle_in_rad = ANGLES_LIST(angle_prediction);
    x = prev_pos_x + cos(angle_in_rad) * v * dt;
    y = prev_pos_y + sin(angle_in_rad) * v * dt;

    if sqrt((x+9)^2+(y+5)^2) > 97
        x = prev_pos_x;
        y = prev_pos_y;
    end
    
end