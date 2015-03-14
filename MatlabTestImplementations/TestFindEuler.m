% Test the find_euler_angles function against Matlab's

% Pick some order
order = 'xyx';
% Pick some angles
angles = [1,2,3];

% Use Matlab to create the qauternion
q = angle2quat(angles(1),angles(2),angles(3),order);

% Use Matlab to extract the Euler angles
[mfirst msecond mthird] = quat2angle(q,order)
% Use custom method to extract the Euler angles
[first second third] = find_euler_angles(q,order)
