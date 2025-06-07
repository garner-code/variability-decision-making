%%%% this script creates the sub config info that drives the task,
%%%% for all subjects. Out put is a 1:n_subs structure with the following:
%%%% sub_info(id).sub_id = id
%%%% sub_info(id).grp
%%%% sub_info(id).tasks
%%%% sub_info(id).frst (A first or B first, for learning)
%%%% sub_info(id).trnsfr_order (see below)
%%%% sub_info(id).col_assign (randomly assigned colour idxs 1:5)
clear all
rng(42); % meaning of life

% counterbalancing:
% house learned 1st: A B vs B A
% order of transfer: 1 2 3
%                    1 3 2
%                    2 1 3
%                    2 3 1
%                    3 1 2
%                    3 2 1
% so 6 x 2 = 12 replications of each set of tasks
% repeated per group therefore 24
% then we want enough task sets to get up to 48 participants per group
% so we only need to make 4 task sets for now
% and I will make enough for now for 48 per group

n_per_grp = 48;
n_grps = 2;
nsubs = n_per_grp * n_grps;

% now I will generate all the task sets we need, given n et al
n_task_sets_2_make = 4;
for i = 1:n_task_sets_2_make
    tasks(i) = assign_target_locations(i);
end

% now I define the transfer orders as above
order_of_transfer = [1, 2, 3; ...
                     1, 3, 2; ...
                     2, 1, 3; ...
                     2, 3, 1; ...
                     3, 1, 2; ...
                     3, 2, 1];
n_transfer_orders = size(order_of_transfer,1);
% each of the tasks is going to be repeated 6 x 2 times, now define the 2
% times
frst_tsk = [1, 2]; % do you do A or B first?

id = 1; % now cycle through tasks, the transfer orders, which task comes first,
% and the groups, to get the info for each subject
for i = 1:length(tasks)

    for i_trns = 1:n_transfer_orders
        for i_frst = 1:length(frst_tsk)
            for i_grp = 1:n_grps
                sub_info(id).sub_id = id;
                sub_info(id).grp = i_grp;
                sub_info(id).tasks = tasks(i);
                sub_info(id).frst = frst_tsk(i_frst);
                sub_info(id).trnsfr_order = order_of_transfer(i_trns,:);
                sub_info(id).col_assign = randperm(5);
                id = id + 1;
            end
        end
    end

end % end for i:length(tasks)

% sub info should be as long as nsub
if length(sub_info) ~= nsubs
    sprintf('problem! sub info has the wrong number of subjects')
end

save(['../','sub_info.mat'], 'sub_info', '-mat');