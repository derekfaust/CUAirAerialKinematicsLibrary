function R = rotmat(n, theta)
% Calculates the matrix to multiply a vector by to rotate it by theta
% around axis n
    
    % Prep values for use in formula
    axis = n/norm(n);
    angle = mod(theta,2*pi);
    
    % Cross product matrix
    cp_mat = [0 -axis(3) axis(2); axis(3) 0 -axis(1); -axis(2) axis(1) 0];
    
    % Create the rotation maxtrix
    R = axis*axis' + cos(angle)*(eye(3)-axis*axis') + sin(angle)*cp_mat;
    
end

