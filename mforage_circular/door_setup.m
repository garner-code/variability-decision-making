function [door_xys, door_size] = door_setup(pix_per_mm, ...
    display_scale, ... % for scaling images proportionally 
    n_inner,... % number of doors to draw on the inner circle
    inner_r_mm, ... % radius of inner circle, in mm
    n_outer, ... % number of doors to draw on outer
    outer_r_mm, ...% same, same, but for outer circle
    xCenter, ... % x point closest to center of screen, in mm
    yCenter) % same but for y
% door xys = the set of xs and ys on which the doors will be centred (2 row
% vector, [2, n_doors]
% door_size = diameter of door, in mm

% here I define the inner and outer doors in polar co-ordinates, and
% convert to cartesian
% inner ring
inner_r = inner_r_mm*pix_per_mm*display_scale;
inner_thetas = (10:(360/n_inner):360) * pi/180; % so slightly set off
inner_xs = xCenter + (inner_r * cos(inner_thetas));
inner_ys = yCenter + (inner_r * sin(inner_thetas));
% outer ring
outer_r = outer_r_mm*pix_per_mm*display_scale;
outer_thetas = (10:(360/n_outer):360) * pi/180;
outer_xs = xCenter + (outer_r * cos(outer_thetas));
outer_ys = yCenter + (outer_r * sin(outer_thetas));

door_xys = [[outer_xs, inner_xs]; [outer_ys, inner_ys]];
door_r = 10*pix_per_mm*display_scale;
door_size = door_r*2;

end