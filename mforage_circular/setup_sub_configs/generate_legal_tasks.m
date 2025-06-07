%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Identify all legal task configurations of the circles task
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 
%%% THIS CODE IS NOTES I USED TO WORK THINGS OUT - NOT ACTUALLY USED
% Step 1: demonstrate, using circular regression, when a pattern is a
% relfection or a rotation
% the idea here is that I can use complex valued regression to rule out any
% target location patterns that are reflections or rotations of each other
% a target location pattern should be a reflection when the slope estimates
% of a complex valued regression
% cos(x): 1 or -1
% sin(x):                                                                
% and should be a rotation when the real component = 1 (everything the same 
% distance) and the imaginary component is a number different from 0
% (keep everything the same distance and rotate it)

%%% first I select four thetas from the original set to form a simplified
%%% task. Then I add a constant to the thetas, based on how many steps
%%% around the circle I want the four points to collectively jump
n_outer = 16;
thetas = (10:(360/n_outer):360) * pi/180;
these_thetas = thetas(randperm(length(thetas), 4));
theta_diff = unique(diff(thetas)); % this gives me how much thetas can be shifted by
r = [2,2,2,2]; % mimic for outer
% now plot to see how they are looking
figure;
subplot(1,2,1)
polarplot(these_thetas, r, 'o');
% now check that adding k*diff to the thetas rotates the pattern
k = 2;
subplot(1,2,2)
polarplot(these_thetas + 2*(theta_diff), new_r, 'o','Color', 'magenta');

% ok, now I need to think about the constraints on reflections
% to reflect the above thetas,
% I can either do -r, -theta
% or r, -theta
% or -r, theta
% lets plot that out
figure;
subplot(2,2,1)
polarplot(these_thetas, r, 'o');
subplot(2,2,2)
polarplot(-these_thetas, -r, 'o','Color', 'magenta');
subplot(2,2,3)
polarplot(-these_thetas, r, 'o','Color', 'red');
subplot(2,2,4)
polarplot(these_thetas, -r, 'o','Color', 'blue');

% so I need to check the following for each task
% 1. that there is no k such as when I hold r constant, z = k*theta_diff
% where k is an integer
% so should I check whether z/theta_diff is not a whole number, where z is
% the new thetas
% e.g. 
new_thetas = these_thetas + 2*(theta_diff)
(new_thetas-these_thetas) % actually, if this number is the same across all, 
% then we know this is a rotation
(new_thetas-these_thetas)./theta_diff % and this recovers the scaling
% so lets make sure I can break this
new_thetas = these_thetas + (theta_diff.*[3, 2, 3, 3]);
figure;
subplot(1,2,1)
polarplot(these_thetas, r, 'o');
% now check that adding k*diff to the thetas rotates the pattern
k = 2;
subplot(1,2,2)
polarplot(new_thetas, r, 'o','Color', 'magenta'); % this breaks it
(new_thetas-these_thetas)./theta_diff;

% and then I need to make sure that the equation for the points fails the
% symmetry tests
% I am thinking it will be easier to convert the thetas into x's and y's,
% and then make sure that none of the x's and ys match the absolute values
% of the other x's and y's
% will try it now - huzzah
xs = r.*cos(these_thetas)
xs = -r.*cos(-these_thetas)

