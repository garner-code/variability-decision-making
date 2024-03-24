function [sub, complete_idxs, hybrid_idxs] = assign_transfer_conditions(sub, ...
    cb, ca_idxs, cb_idxs)

    %%%% ASSIGN_TRANSFER_CONDITIONS: for a given subject, assign complete
    %%%% transfer context according to cb, and then generate a hybrid task
    %%%% from ca_idxs and cb_idxs
    % inputs
    % sub = int, 1, sub number
    % cb = int, 1 or 2, A for complete transfer or B for complete transfer
    % ca_idxs = int, [1, 4] - indexes for task A, 
    % cb_idxs = as above but for task B
    
    complete_idxs = [ca_idxs; cb_idxs];
    complete_idxs = complete_idxs(cb, :);

        %%%%%%%%%% set the options for each type of door allocation
    outest = [1, 4, 13, 16]; % outer corners
    outmid = [2, 5, 3, 8, 9, 14, 12, 15];
    inner = [6, 7, 10, 11]; % inner
    
    hybrid_idxs = [datasample(ca_idxs, 2, 'Replace', false), ...
                         datasample(cb_idxs, 2, 'Replace', false)];

end
