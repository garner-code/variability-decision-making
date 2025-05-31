%%%% this code tests whether using circular regression can help me identify
%%%% task sets that are reflections, and whether wrap vs unwrap on the
%%%% thetas, plus a linear transform can identify rotations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. reflections
clear all;
% hand pick 4 thetas that make life real easy
task_a = [0, (3*pi)/2, pi, pi/2]';
% a) reflect across the polar axis (horizontal)
ta_hr = -task_a;
% check this works
r = [1, 1, 1, 1];
subplot(1,2,1)
polarplot(task_a, r, '-o', 'LineWidth', 1.5);
subplot(1,2,2)
polarplot(ta_hr, r, 'Color', [0.2, 0.2, 0.2], 'LineWidth', 1.5);

% c) reflect throigh the origin
subplot(1,2,1)
o_ref = task_a + pi;
polarplot(task_a, r, '-o', 'LineWidth', 1.5);
subplot(1,2,2)
polarplot(o_ref, r, 'Color', [0.2, 0.2, 0.2], 'LineWidth', 1.5);

slopes_hr = do_regression(ta_hr, task_a);
rsq_hr = get_rsq(ta_hr, task_a, slopes_hr);

slopes_o = do_regression(o_ref, task_a);
rsq_o = get_rsq(o_ref, task_a, slopes_o);

%%%%%%%% now I rotate the original pattern by adding 1 pi radian to the xs
rot_x = task_a + (pi/180);
subplot(1,2,1)
polarplot(task_a, r, '-o', 'LineWidth', 1.5);
subplot(1,2,2)
polarplot(rot_x, r, '-o', 'LineWidth', 1.5);

slopes_rot_x = do_regression(rot_x, task_a);
rsq_rot = get_rsq(rot_x, task_a, slopes_rot_x);

%%%%%%%% now I add a different amount to each radian
ran_x = [task_a(1)+(pi/6), task_a(2)+(pi/5), task_a(3)+(pi/4), task_a(4)-(pi/6)]';
subplot(1,2,1)
polarplot(task_a, r, '-o', 'LineWidth', 1.5);
subplot(1,2,2)
polarplot(ran_x, r, '-o', 'LineWidth', 1.5);

slopes_ran_x = do_regression(ran_x, task_a);
rsq_ran = get_rsq(ran_x, task_a, slopes_ran_x);


function slopes = do_regression(x,y)
% this function does the regression

X=cos(x)+1i*sin(y);
Y=cos(y)+1i*sin(y);

Xt = X';
slopes = (Xt*X)^-1*Xt*Y;
end

function rsq = get_rsq(x,y,slopes)

X=cos(x)+1i*sin(y);
Y=cos(y)+1i*sin(y);

ypred = X*slopes;
ss_model = sum(ypred-mean(Y).^2);
ss_err = sum(ypred-Y.^2);
ss_total = ss_model+ss_err;
rsq = 1-(ss_err/ss_total);
rsq=sqrt(real(rsq).^2+imag(rsq).^2);
end


