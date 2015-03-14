function q = rotq(n, theta)
% Calculates the matrix to multiply a vector by to rotate it by theta
% around axis n
%   Detailed explanation goes here
    
    % Prep values for use in formula
    axis = n/norm(n);
    angle = mod(theta,2*pi);
    
    % Calculate the sine once.
    s = sin(angle/2);
    
    % Form the quaternion
    q = [cos(angle/2), axis(1)*s, axis(2)*s, axis(3)*s];
    
end

