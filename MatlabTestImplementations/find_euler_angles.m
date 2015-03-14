function [first, second, third] = find_euler_angles(q, order)
% Find the Euler angles associated with a given quaternion
% (Currently only works for Tait-Bryan Angles)
    
    % Associate a vector and number with each axis
    order_num = zeros(3,1);
    order_axis = {};
    for i=[1:3]
        if order(i) == 'x'
            order_axis{i} = [1,0,0]';
            order_num(i) = 1;
        elseif order(i) == 'y'
            order_axis{i} = [0,1,0]';
            order_num(i) = 2;
        elseif order(i) == 'z'
            order_axis{i} = [0,0,1]';
            order_num(i) = 3;
        end
    end

    % Check if the cross of the first two axes align with the third (this
    % also gives us whether the order is odd over even
    order_oddness = dot(cross(order_axis{1},order_axis{2}),order_axis{3});
        
    if order_oddness == 0
        % If the axes are not three different axes
        % TODO Add formulas to handle true Euler angles, not just
        % Tait-Bryan angles.
        fprintf('This is not a valid order\n')
        first = 0; second = 0; third = 0;
    else
        % Apply the formula found thorugh symbolic math.
        first = atan2((-order_oddness)*R(q, order_num(2), order_num(3)), R(q, order_num(3), order_num(3)));
        second = asin(order_oddness*R(q, order_num(1), order_num(3)));
        third = atan2((-order_oddness)*R(q, order_num(1), order_num(2)), R(q, order_num(1), order_num(1)));
    end
end

function value = R(q, row, col)
% Return the value of the rotation matrix associated with the quaternion at
% given row and column

    if row == col
        if row == 1
            value = q(1)^2 + q(2)^2 - q(3)^2 - q(4)^2;
        elseif row == 2
            value = q(1)^2 - q(2)^2 + q(3)^2 - q(4)^2;
        elseif row == 3
            value = q(1)^2 - q(2)^2 - q(3)^2 + q(4)^2;
        else
            fprintf('Error, invalid row/column\n')
            value = 0;
        end
    elseif row==1
        if col == 2
            value = 2*(q(2)*q(3)-q(1)*q(4));
        elseif col == 3
            value = 2*(q(2)*q(4)+q(1)*q(3));
        else
            fprintf('Error, invalid column\n')
            value = 0;
        end
    elseif row==2
        if col == 1
            value = 2*(q(2)*q(3)+q(1)*q(4));
        elseif col == 3
            value = 2*(q(3)*q(4)-q(1)*q(2));
        else
            fprintf('Error, invalid column\n')
            value = 0;
        end
    elseif row==3
        if col == 1
            value = 2*(q(2)*q(4)-q(1)*q(3));
        elseif col == 2
            value = 2*(q(3)*q(4)+q(1)*q(2));
        else
            fprintf('Error, invalid column\n')
            value = 0;
        end
    else
        fprintf('Error, invalid row\n')
        value = 0;
    end
        
end