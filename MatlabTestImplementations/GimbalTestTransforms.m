% GimbalTestTranforms.m
% A MATLAB program to test the math associated with pointing the camera in
% line with a desired rotation. Most math is performed with both rotation
% matrices and quaternions so any errors in use of one can be checked
% against the other.

% Clean up everything
clear all;
close all;
clc;

% Establish relationship between the graphing frame and the Fixed frame
G_R_F = rotmat([1 1 0]', pi);
G_q_F = rotq([1 1 0]', pi);

% Establish all of the test cases to run through
yaw_cases = [-180:90:360]; 
pitch_cases = [-45:22.5:90]; 
roll_cases = [-60:30:60]; 
starting_roll_cases = 0; %[-60:60:60];
starting_pitch_cases = 0; %[-60:60:60];
target_roll_cases = [-60:30:60];
target_pitch_cases = [-60:30:60];
num_cases = length(yaw_cases)*length(pitch_cases)*length(roll_cases) ...
            * length(starting_roll_cases)*length(starting_pitch_cases) ...
            * length(target_roll_cases)*length(target_pitch_cases)
thiscase = 0;
        
% Start a figure in which to plot the coordinate systems
figure();

% Run through all of the test cases
for plane_yaw = yaw_cases * pi/180
for plane_pitch = pitch_cases * pi/180
for plane_roll = roll_cases * pi/180
for starting_roll = starting_roll_cases * pi/180
for starting_pitch = starting_pitch_cases * pi/180
for target_roll = target_roll_cases * pi/180
for target_pitch = target_pitch_cases * pi/180
    
    % Establish relationship of the plane to the fixed frame
    r_Plane = [10, 10, 10]';    % Give the plane some position
    F_R_Plane = rotmat([0 0 1]', plane_yaw)*rotmat([0 1 0]', plane_pitch)*rotmat([1 0 0]', plane_roll);
    F_q_Plane = quatmultiply(quatmultiply(rotq([0 0 1]', plane_yaw),rotq([0 1 0]', plane_pitch)),rotq([1 0 0]', plane_roll));

    % Establish the relationship of the target relative to the fixed frame and
    % the plane
    F_R_Target = rotmat([1 0 0]', target_roll)*rotmat([0 1 0]', target_pitch);
    F_q_Target = quatmultiply(rotq([1 0 0]',target_roll),rotq([0 1 0]', target_pitch));
    P_R_Target = inv(F_R_Plane) * F_R_Target;
    P_q_Target = quatmultiply(inv_q(F_q_Plane),F_q_Target);

    % Establish Relationship of the camera to the plane and the fixed frame
    camera_roll = starting_roll;
    camera_pitch = starting_pitch;
    P_R_Camera = rotmat([1 0 0]', camera_roll)*rotmat([0 1 0]', camera_pitch);
    P_q_Camera = quatmultiply(rotq([1 0 0]', camera_roll),rotq([0 1 0]', camera_pitch));
    F_R_Camera = F_R_Plane * P_R_Camera;
    F_q_Camera = quatmultiply(F_q_Plane, P_q_Camera);

    % Get the motor angles
    [t_roll, t_pitch, t_spin] = get_motor_angles_q(P_q_Target);
    [c_roll, c_pitch, c_spin] = get_motor_angles_q(P_q_Camera);
    diff = [t_roll, t_pitch, t_spin]-[c_roll, c_pitch, c_spin];

    % Find the rotations of the arm and camera after the rotations are
    % performed
    P_q_RArm = rotq([1 0 0]', t_roll);
    P_q_RCamera = quatmultiply(rotq([1 0 0]', t_roll),rotq([0 1 0]', t_pitch));
    F_q_RCamera = quatmultiply(F_q_Plane,P_q_RCamera);
    P_R_RArm = rotmat([1 0 0]', t_roll);
    P_R_RCamera = rotmat([1 0 0]', t_roll)*rotmat([0 1 0]', t_pitch);
    F_R_RCamera = F_R_Plane * P_R_RCamera;

    % Draw Plots:
    % Plane frame on top, camera starting frame below, camera resultant and
    % desired frame super-imposed below that.
    plot3([0,.001],[0,.001],[0,.001]);      % Start a 3D Plot
    hold on;                                % Allow next commands to plot to it
    %plot_coords([0 0 0]',G_R_F)            % Show coordinate system F in the graphing frame
    plot_coords([0 0 10]', G_R_F*F_R_Plane) % Show the plane's frame
    plot_coords([0 0 8]', G_R_F*F_R_Camera) % Show the camera's current frame
    plot_coords([0 0 6]', G_R_F*F_R_Plane*P_R_RCamera) % Show the camera's final frame
    plot_coords([0 0 6]', G_R_F*F_R_Target) % Show the target's frame
    hold off;                               % Stop allowing plots to this plot
    axis([-5,5,-5,5,0,12]);                 % Set the window size

    % Try to find the quaternion that describes the difference and convert that
    % to Euler angles
    % Currently does not work because Euler angles would need to be found
    % relative to each motor (since they are starting off rotated from both the
    % camera's axis an the planes axis)
    Camera_q_Target = quatmultiply(P_q_Target,inv_q(P_q_Camera));
    
    % Find the direction of the z-axis (the camera's pointing axis) under
    % the garget frame, and the resultant camera frame.
    dir1 = quatmultiply(F_q_RCamera,quatmultiply([0 0 0 1],inv_q(F_q_RCamera)));
    dir2 = quatmultiply(F_q_Target,quatmultiply([0 0 0 1],inv_q(F_q_Target)));
    
    % Check that the z-axes are aligned within some tolerance
    if dot(dir1(2:4), dir2(2:4)) + 16*eps < 1
        % Print how large the error is, and in what case the problem occurs
        acosd(dot(dir1(2:4), dir2(2:4)))
        problem = [plane_yaw; plane_pitch; plane_roll; starting_roll; ...
                    starting_pitch; target_roll; target_pitch]
    end

    % Keep trakc of and display some information about the progress
    thiscase = thiscase+1;
    if mod(thiscase,100)==0
        Progress = thiscase*100/num_cases
    end
    
    % Pause and show a visualization
    pause(.05);
    shg;
end
end
end
end
end
end
end