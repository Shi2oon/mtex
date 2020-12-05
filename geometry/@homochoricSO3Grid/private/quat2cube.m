function XYZ = quat2cube(q)

% transforms unit quaternions (representing rotations) into cubochoric
%   representation 
% the transformation is achieved by going from representation as unit
%   quaternions to homochoric representation (Lambert) and then further to
%   cubochoric representation (ball2cube)
% 
% Input:   q - @quaternion
% Output:  XYZ (dimension (N,3) array) - cubochoric coordinates (X,Y,Z) of N points of the cube

xyz = Lambert([q.a(:) q.b(:) q.c(:) q.d(:)]);
XYZ = ball2cube(xyz);

end