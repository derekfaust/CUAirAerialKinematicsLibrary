function [theta_x, theta_y, theta_z] = get_motor_angles_q(q)
% Returns the motor angles of the camera given a quaternion
% representing the camera's rotation relative to the plane
% Assumes that plane's axes are Forward, Right, Down, and camera's axes are
% aligned with the plane at (roll, pitch, spin) = (0 0 0)
% Assumes that the roll axis is fixed to the plane, then pitch, then spin

    % Calculate the sin of y, so we only have to o it once.
    siny = 2*(q(2)*q(4) + q(1)*q(3));
    
    % If cos(pitch) is not zero (sin(pitch) is 1)
    if abs(1-abs(siny)) > 16*eps
        
        % Calculate spin
        theta_z = atan2(-2*(q(2)*q(3)-q(1)*q(4)), q(1)^2+q(2)^2-q(3)^2-q(4)^2);
        
        % Calculate roll
        theta_x = atan2(-2*(q(3)*q(4)-q(1)*q(2)), q(1)^2-q(2)^2-q(3)^2+q(4)^2);
        
        % Calculate pitch
        theta_y = asin(siny);

    % Assign a value to pitch based on its sign
    elseif siny > 0
        theta_y = pi/2;

        % Spin and roll are effectively about the same axis, so pick one to
        % be zero, and calculate the other.
        theta_x = 0;
        theta_z = atan2(2*(q(2)*q(3)+q(1)*q(4)),q(1)^2-q(2)^2+q(3)^2-q(4)^2); 
    else
        theta_y = -pi/2;
        
        % Spin and roll are effectively about the same axis, so pick one to
        % be zero, and calculate the other.
        theta_x = 0;
        theta_z = atan2(2*(q(2)*q(3)+q(1)*q(4)),q(1)^2-q(2)^2+q(3)^2-q(4)^2);
    end
    
end

