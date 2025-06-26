function [tasks] = assign_target_locations(i)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% ASSIGN_TARGET_LOACTIONS: for a given subject - perform the
    %%%% following:
    % randomly select 1 door from each outer quadrant
    % randomly select 2 doors from 2 of the inner quadrants
    % now randomly select the second task, and check it is not a rotation
    % or a reflection of the first. Keep selecting until the criterion is
    % met.
    % then randomly select a 3rd task, test it is not a rotation or
    % reflection of the first and second task. Keep selecting until these
    % criteria are met
    % mix up the first two tasks two make the permuted transfer condition
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% HEALTH WARNING! I have hard coded the circle/dims info here. If
    %%%% we change the display then this needs to be re-run.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% DEFINE THE DOOR LOCATION INFO
    n_inner = 8; % 8 inner doors
    inner_r = 30;
    inner_thetas = (10:(360/n_inner):360) * pi/180;
    inner_theta_diff = unique(round(diff(inner_thetas),4));
    n_outer = 12; % 12 outer doors
    outer_r = 60;
    outer_thetas = (10:(360/n_outer):360) * pi/180;
    outer_theta_diff = unique(round(diff(outer_thetas),4));
    thetas = [outer_thetas, inner_thetas];
  
    %%%%% STEP 1: Select the first task 

    outer = {1:3, 4:6, 7:9, 10:12}; % each cell is one quadrant. EC: updated door numbers
    inner = {13:14, 15:16, 17:18, 19:20}; % EC: as above
    outer_idx = 1:2; % when you get your vector of target door locations, which 2 are from the outer ring?
    inner_idx = 3:4; % same as above but for inner
    [ta_idxs, nu_outer, nu_inner] = grab_random_idxs_for_task_locs(outer,...
        inner); % output is [taskA locs, remaining outer doors, remaining inner doors]
    % on the basis of these locations, get the thetas
    task_a_thetas = thetas(ta_idxs);

    % now select tasks b and c
    n_tasks_left_2choose = 2;
    bn_idxs = zeros(n_tasks_left_2choose, length(ta_idxs)); % idxs for task b and novel

    for i_choose = 1:n_tasks_left_2choose
        legal = 0;
        while ~legal
            [idxs, ~, ~] = grab_random_idxs_for_task_locs(nu_outer, nu_inner);
            t_thetas = thetas(idxs);
            % test whether the new task is legal
            legal = check_legal(task_a_thetas, t_thetas, outer_theta_diff, ...
                outer_r, inner_r, outer_idx, inner_idx);
        end
        % found a legal set so throw out the indexes for the next round
        [nu_outer, nu_inner] = throw_away_used_idxs(nu_outer, nu_inner, ...
            idxs(outer_idx), idxs(inner_idx)); % warning hardcoded idxs
        % and add the new task indexes to the matrix
        bn_idxs(i_choose, :) = idxs;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% allocate to the config structure
    tasks.a = ta_idxs;
    tasks.b = bn_idxs(1,:);
    tasks.novel = bn_idxs(2,:); % novel task
   
    n_take_from_out = 1; % EC: need to change this
    n_take_from_in = 1;

    tasks.perm = sort([ta_idxs(randperm(max(outer_idx),n_take_from_out)), ...
                       ta_idxs(randperm(length(inner_idx),n_take_from_in) + max(outer_idx)), ...
                       bn_idxs(1, randperm(max(outer_idx),n_take_from_out)), ... 
                       bn_idxs(1, randperm(length(inner_idx),n_take_from_in) + max(outer_idx))]);
    % now plot the tasks for sanity checking
    rs = [repmat(outer_r, 1, length(outer_idx)), repmat(inner_r, 1, length(inner_idx))];
    figure;
    subplot(2,2,1)
    polarplot(thetas(tasks.a), rs, 'o');
    title('a')
    subplot(2,2,2)
    polarplot(thetas(tasks.b), rs, 'o', 'Color','magenta');
    title('b')
    subplot(2,2,3)
    polarplot(thetas(tasks.novel), rs, 'o', 'Color','red');
    title('novel')
    subplot(2,2,4)
    polarplot(thetas(tasks.perm), rs, 'o', 'Color','blue');
    title('partial')
    print(sprintf('task-sets_%d.pdf', i), '-dpdf', '-r320')
    close;

    comp_choice = randsample(2, 1);
    if comp_choice == 1
        tasks.comp = tasks.a;
    else
        tasks.comp = tasks.b;
    end

end
