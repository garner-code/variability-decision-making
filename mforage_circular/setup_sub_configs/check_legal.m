function [legal] = check_legal(x_thetas, y_thetas, outer_theta_diff, ...
    outer_r, inner_r)

% the first question is whether x and y are rotated
% if there is a rotation, then there should be a single scalar value
% where old_thetas = new_thetas + (k*theta_diff)
% I found it took forever to find tasks that were not rotated on the inner
% layer, so sticking to only ensuring no rotation on the outer layer
outer_idx = 1:4;
inner_idx = 5:6;
outer_rots = (y_thetas(outer_idx)-x_thetas(outer_idx))./outer_theta_diff;
o_rot = sum(diff(round(outer_rots, 2)) > 0); % should be > 0
% inner_rots = (y_thetas(inner_idx)-x_thetas(inner_idx))./inner_theta_diff;
% i_rot = sum(diff(round(inner_rots, 2)) > 0);


% the second question is, are the inner and outer circles reflections of
% each other?
% first, I convert the polar co-ordinates from task x to cartesian
outer_x_comp = sum(ismember(abs(round(outer_r .* cos(x_thetas(outer_idx)), 2)), ...
    abs(round(outer_r .* cos(y_thetas(outer_idx)), 2)))) ...
    < length(outer_idx); % if the outcome is zero/false
% then the x coords of task y are a reflection of task x

inner_x_comp = sum(ismember(abs(round(inner_r .* cos(x_thetas(inner_idx)), 2)), ...
    abs(round(inner_r .* sin(y_thetas(inner_idx)), 2)))) ...
    < length(inner_idx); % if the outcome is zero/false
% then the x coords of task y are a reflection of task x
% now sum
%ref_test = outer_x_comp && inner_x_comp;

legal = o_rot && outer_x_comp && inner_x_comp; % if all of these are true then the pattern has passed the test


end