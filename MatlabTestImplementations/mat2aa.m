function [angle, axis] = mat2aa(rotation_matrix)
%Function to find the axis and angle of a 3D rotation given a rotation
%matrix
    
    % Define soem small number that can be compared against when judging
    % numerical errors
    small_number = .0001;

    % Make sure that all elements are not NaN
    if sum(sum(isnan(rotation_matrix)))
        angle = 0; axis = [0,0,0];
        fprintf('Some elements are not numbers')
        
    else
        % Find the eigenvectors and eigen-values
        [V,D] = eig(rotation_matrix);

        % Initialize the axis
        axis = [NaN; NaN; NaN];

        % If the eigenvalue is real, and all of the elements of the
        % eigenvector are real, then use that as the axis.
        for i = 1:length(D)
            if imag(D(i,i))==0 && sum(abs(imag(V(:,i))))==0
                % Normalize the eigenvector before making it the axis
                axis = V(:,i)/norm(V(:,i));
            end
        end

        % Initialize sine and cosine
        cos_theta = NaN;
        sin_theta = NaN;

        % If no axis was found, then the matrix is not a rotation matrix
        if sum(isnan(axis))>0
            fprintf('This is not a rotation matrix \n');
            
            % Provide some value for the angle and axis
            angle = 0; axis = [0,0,0]';
        
        % If an axis was found
        else
            % Try to determine the angle from the diagonal terms of the
            % matrix
            if (rotation_matrix(1,1) ~= 0) && (abs(axis(1)) ~= 1)
                cos_theta = (rotation_matrix(1,1)-axis(1)^2)/(1-axis(1)^2);
            elseif (rotation_matrix(2,2) ~= 0) && (abs(axis(2)) ~= 1)
                cos_theta = (rotation_matrix(2,2)-axis(2)^2)/(1-axis(2)^2);
            elseif (rotation_matrix(3,3) ~= 0) && (abs(axis(3)) ~= 1)
                cos_theta = (rotation_matrix(3,3)-axis(3)^2)/(1-axis(3)^2);
            else
                fprintf('Cannot Determine Rotation \n')
            end

            % If the cosine of the angle was found, try using one of the
            % six other terms to find the sine of theta
            if ~isnan(cos_theta)
                if (rotation_matrix(1,2) ~= 0) && (abs(axis(3))>small_number)
                    sin_theta = -(rotation_matrix(1,2)-axis(1)*axis(2)*(1-cos_theta))/axis(3);
                elseif (rotation_matrix(1,3) ~= 0) && (abs(axis(2))>small_number)
                    sin_theta = (rotation_matrix(1,3)-axis(1)*axis(3)*(1-cos_theta))/axis(2);
                elseif (rotation_matrix(2,3) ~= 0) && (abs(axis(1))>small_number)
                    sin_theta = -(rotation_matrix(2,3)-axis(2)*axis(3)*(1-cos_theta))/axis(1);
                elseif (rotation_matrix(2,1) ~= 0) && (abs(axis(3))>small_number)
                    sin_theta = (rotation_matrix(2,1)-axis(2)*axis(1)*(1-cos_theta))/axis(3);
                elseif (rotation_matrix(3,1) ~= 0) && (abs(axis(2))>small_number)
                    sin_theta = -(rotation_matrix(3,1)-axis(3)*axis(1)*(1-cos_theta))/axis(2);
                elseif (rotation_matrix(3,2) ~= 0) && (abs(axis(1))>small_number)
                    sin_theta = (rotation_matrix(3,2)-axis(3)*axis(2)*(1-cos_theta))/axis(1);
                else
                    sin_theta = 0;
                end
            end
            
            % Use the 4-quadrant inverse tangent to find the angle
            angle = atan2(sin_theta,cos_theta);
            
            % If the angle couldn't be determined, set it to 0.
            if isnan(angle)
                angle = 0;
            end

            % If either sin or cosine couldn't be determined
            if (isnan(cos_theta)+isnan(sin_theta)) > 0
                fprintf('This is not a rotation matrix 1 \n');
                angle = 0; axis = [0,0,0]';
            
            % If the rotation matrix corresponding to this axis and angle
            % doesn't agree with the original matrix, then a good solution
            % wasn't found.
            elseif sum(sum((rotmat(axis, angle)-rotation_matrix).^2)) > .05
                rotmat(axis,angle)
                fprintf('Cannot Determine Rotation: A poor match was found. \n')
                angle = 0; axis = [0,0,0]';
            
            % If the angle ends up as zero, then say so
            elseif angle == 0
                fprintf('No Rotation has Occured \n')
                angle = 0; axis = [0,0,0]';
            else
                % It worked, don't say anything.
                
                %fprintf('This rotation matrix is for: \n an angle %f deg \n around %f, %f, %f \n', ...
                %        angle*180/pi, axis(1), axis(2), axis(3));
            end
        end
    end
end

