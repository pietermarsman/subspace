function [ output_args ] = plotvec( vec )
%PLOTVEC Summary of this function goes here
%   Detailed explanation goes here

hold on

if size(vec, 1) > 1
    for v = vec
        plot3([0, v(1)], [0, v(2)], [0, v(3)])
    end
else
    plot3([0, vec(1)], [0, vec(2)], [0, vec(3)])
end

view(3)

end

