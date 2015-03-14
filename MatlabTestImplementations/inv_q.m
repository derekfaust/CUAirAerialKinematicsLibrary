function q_inv = inv_q(q)
% Return the complex conjugate (the inverse) of a quaternion

    q_inv = [q(1), -q(2:4)]/quatnorm(q);

end

