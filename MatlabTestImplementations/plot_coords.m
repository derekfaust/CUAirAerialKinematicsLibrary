function plot_coords(r, R)
% plot_coords is a function that can plot the coordinate axes given a
% rotation matrix and a position for the origin of the matrices.
% (Assumes that a 3D plot has already been started)

    % Create unit vectors
    x = [1 0 0]'; y = [0 1 0]'; z = [0 0 1]';
    
    % Apply the rotation to the unit vectors
    rot_x = R*x; rot_y = R*y; rot_z = R*z;
    
    % Get the current axes that we will plot to.
    ax = gca;
    
    % Plot the coordinate system: Red->x, Green->y, Blue->z
    plot3(ax,[r(1), r(1)+rot_x(1)], [r(2), r(2)+rot_x(2)], [r(3), r(3)+rot_x(3)],'r');
    plot3(ax,[r(1), r(1)+rot_y(1)], [r(2), r(2)+rot_y(2)], [r(3), r(3)+rot_y(3)],'g');
    plot3(ax,[r(1), r(1)+rot_z(1)], [r(2), r(2)+rot_z(2)], [r(3), r(3)+rot_z(3)],'b');
    
end