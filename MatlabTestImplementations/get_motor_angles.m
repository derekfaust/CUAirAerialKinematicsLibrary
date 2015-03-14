function [roll, pitch, spin] = get_motor_angles(P_R_C)
% Returns the motor angles of the camera given a rotation matrix
% representing the camera's rotation relative to the plane
% Assumes that plane's axes are Forward, Right, Down, and camera's axes are
% aligned with the plane at (roll, pitch, spin) = (0 0 0)
% Assumes that the roll axis is fixed to the plane, then pitch, then spin

    R = P_R_C;

    % If cos(pitch) is not zero (sin(pitch) is 1)
    if abs(R(1,3)) ~= 1
        % Calculate spin
        spin = atan2(-R(1,2),R(1,1));
        
        % Calculate roll
        roll = atan2(-R(2,3),R(3,3));
        
        % Calculate pitch -- wrong
        pitch = asin(R(1,3));
        
        if R(3,3) ~= 0
            if R(3,3)/cos(roll) < 0
                pitch = pitch + 180;
            end
        else
            if -R(2,3)/sin(roll) < 0
                pitch = pitch + 180;
            end
        end

    % If the sin(pitch)=1
    else
        % Assign a value to pitch based on its sign
        if R(1,3) == 1
            pitch = pi/2;
        elseif R(1,3) == -1
            pitch = -pi/2;
        end
        
        % Spin and roll are effectively about the same axis, so pick one to
        % be zero, and calculate the other.
        spin = atan2(R(1,2),R(2,2));
        roll = 0;
    end
        
end

