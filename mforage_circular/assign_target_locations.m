function [tasks] = assign_target_locations()

    %%%% ASSIGN_TARGET_LOACTIONS: for a given subject, assign randomly
    %%%% selected target loactions to doors, with the following constraints
    %%%% - 1 door in each quadrant, 2 are outer, 2 are inner
    
    %%%%% FOR NOW: I AM MANUALLY PICKING 3 TASKS FOR EMILY TO RUN WITH IN
    %%%%% THE FIRST WEEK. WILL COME BACK TO THIS
    %%%%% GET THE DOOR INFO
    % all_outer = 1:16;
    % outer = {1:4, 5:8, 9:12, 13:16}; % see run_iforage and door_setup for why these idxs 
    % inner = {17:18, 19:20, 21:22, 23:24}; 
    task_a_out = [1, 6, 11, 14]; % 4 outer, and 2 inner
    task_a_in = [18, 21];
    task_b_out = [3, 5, 10, 16];
    task_b_in = [20, 24];
    task_c_out = [4, 7, 9, 15];
    task_c_in = [17, 21];

    tasks.a = [task_a_out, task_a_in];
    tasks.b = [task_b_out, task_b_in];
    tasks.novel = [task_c_out, task_c_in]; % novel task

    n_take_from_out = 2;
    n_take_from_in = 1;

    tasks.perm = [task_a_out(randsample(length(task_a_out), n_take_from_out)), ...
                  task_a_in(randsample(length(task_a_in), n_take_from_in)), ...
                  task_b_out(randsample(length(task_b_out), n_take_from_out)), ...
                  task_b_in(randsample(length(task_b_in), n_take_from_in))];
    comp_choice = randsample(2, 1);
    if comp_choice == 1
        tasks.comp = tasks.a;
    else
        tasks.comp = tasks.b;
    end

end
