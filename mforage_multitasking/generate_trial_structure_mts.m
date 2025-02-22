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
trials = zeros(ntrials*4, 9);
trials(:,1) = 1:ntrials*4;
trials(:,2) = repelem([1,2,3,4],ntrials);
trials(:,3) = repmat(repelem([0,1], ntrials/2), 1, 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now for contexts 1 and 2, pick 3 loctations at random for all the trials
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
k = 3; % how many to select each time
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
trials(trials(:,2) == 1,4:6) = ca_doors;
trials(trials(:,2) == 2,4:6) = cb_doors;
trials(trials(:,2) == 3,4:6) = cc_doors;
trials(trials(:,2) == 4,4:6) = cd_doors;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now for all trials where things will appear in the same location, repeat
% doors, for those with a 0, swap the order of two of the doors
trials(trials(:,3) == 0, 7:9) = trials(trials(:,3) == 0, 4:6);
trials(trials(:,3) == 1, 7:9) = trials(trials(:,3) == 1, [5,4,6]);

end