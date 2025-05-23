function trials = generate_trial_structure_mts(ntrials, sub_config)
% generate a trial matrix for the match to sample component of the task

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% items to consider
% 1. whether items are from task a, task b, or neither (and selecting 
% which neither)
% 2. counterbalancing which 3 are chosen
% 3. assigning half the trials to same, and half to different
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% outcome matrix = [trial, context, cresp, locs before, locs after]
% context = 1, 2, or 3, where 3 is neither
% cresp = 0 or 1, 0 = same, 1 = different
trials = zeros(ntrials*4, 11);
%trials(:,1) = 1:ntrials*4;
trials(:,2) = repelem([1,2,3,4],ntrials);
trials(:,3) = repmat(repelem([0,1], ntrials/2), 1, 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get context a and b doors
context_a_doors = sub_config(3:6);
context_b_doors = sub_config(7:10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now create 2 'neither' contexts
context_c_doors = make_third_task(context_a_doors, context_b_doors);
context_d_doors = 1:16;
d_idx = ~ismember(context_d_doors, ...
    [context_a_doors, context_b_doors, context_c_doors]);
context_d_doors = context_d_doors(d_idx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now do sub selections of doors
k = 4; % how many to select each time - as 4
ca_doors = zeros(ntrials, k); 
cb_doors = ca_doors; % for collecting trials
cc_doors = ca_doors;
cd_doors = ca_doors;
for i = 1:ntrials
    ca_doors(i,:) = randsample(context_a_doors, k, false);
    cb_doors(i,:) = randsample(context_b_doors, k, false);
    cc_doors(i,:) = randsample(context_c_doors, k, false);
    cd_doors(i,:) = randsample(context_d_doors, k, false);
end

trials(trials(:,2) == 1,4:7) = ca_doors;
trials(trials(:,2) == 2,4:7) = cb_doors;
trials(trials(:,2) == 3,4:7) = cc_doors;
trials(trials(:,2) == 4,4:7) = cd_doors;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now for all trials where things will appear in the same location, repeat
% doors, for those with a 0, swap the order of two of the doors
trials(trials(:,3) == 0, 8:11) = trials(trials(:,3) == 0, 4:7);
trials(trials(:,3) == 1, 8:11) = trials(trials(:,3) == 1, [5,4,6,7]);

% now take the trials and shuffle the order of the rows
row_shuff_idx = randperm(size(trials,1));
trials = trials(row_shuff_idx, :);
trials(:,1) = 1:size(trials(:,1));

end