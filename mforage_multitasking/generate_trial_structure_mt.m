function [trial_struct, ca_ps, cb_ps] = generate_trial_structure_mt(ntrials, sub_config, door_probs, p)
%%%%%
% GENERATE_TRIAL_STRUCTURE_TRAIN
% generate the trial structure for the task switching stage
% multi-switch group == switch contexts with switch p of p 
%
% inputs - ntrials = number of trials in each condition 
% sub_config [1, n] = subject counterbalancing info loaded from
% 'sub_infos.mat'
% door_probs [1, ndoors] = set of target probabilities to be distributed
% among the doors
%
% 
% RETURNS:
% [trial_struct] = 5 x ntrials matrix
% col 1 = trial number
% col 2 = context - 1 or 2
% col 3 = target door for that trial
% col 4 = a priori p(tgt door)
% col 5 = target for that trial
% col 6 = when mt should come on, if coming on
% col 7 = mt location 
% col 8 = tgt for mt task
% col 9 = mt trial (1 for yes, 0 for no)
% ca_ps = 1,ndoor vector of which p goes with which door for context a
% cb_ps = as above, but for context b

ndoors = length(door_probs);
ntargets = 100; % total number of targets to choose from
tntrials = ntrials*2;% this assumes only 2 contexts, the
% hardcoded 2 would need to change for experiments involving more than 2.
trial_struct = zeros(tntrials, 9); 

trial_struct(:,1) = 1:length(trial_struct(:,1)); % allocate trial number

% set up single switch as in learning stage
[ttrials, ~] = size(trial_struct);
trial_struct(1:(ttrials/2),2) = datasample(1:2,1); % randomise which context comes first
trial_struct((ttrials/2)+1:ttrials,2) = 3 - trial_struct(1,2);

% get locations for this stage % WARNING - HARD CODED
ca_idxs = sub_config(3:6); 
cb_idxs = sub_config(7:10);

ca_ps = zeros(1,ndoors);
ca_ps(ca_idxs) = door_probs(door_probs > 0);
cb_ps = zeros(1,ndoors);
cb_ps(cb_idxs) = door_probs(door_probs > 0);

%%%%%%%%%%% note, below code specific to 2 contexts, not generalisable
% now replicate each location into a vector that allows 
% the full balance of target door, place when multitask will be revealed
% and mt location
% target
ca = repelem(ca_idxs, length(ca_idxs)*length(ca_idxs));
cb = repelem(cb_idxs, length(ca_idxs)*length(ca_idxs));
% location when mt will be presented if its happening (i.e. where in
% task a does the mt occur?
ca_trigger = zeros(1,length(ca));
cb_trigger = zeros(1,length(cb));
for i = 1:length(ca_idxs)
    ca_trigger(ca == ca_idxs(i)) = ...
        repmat([0, ca_idxs(ca_idxs ~= ca_idxs(i))], ...
                            1, length(ca_idxs));
    cb_trigger(cb == cb_idxs(i)) = ...
        repmat([0, cb_idxs(cb_idxs ~= cb_idxs(i))], ...
                            1, length(cb_idxs));
end

% location for multitask | ca
ca_mt_loc = repmat(repelem(cb_idxs, length(ca_idxs)), 1, length(ca_idxs));
cb_mt_loc = repmat(repelem(ca_idxs, length(cb_idxs)), 1, length(cb_idxs));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now put the info into the trial structure
% allocate information to each context
% after which shuffle by context before running through
% 'create_switch_conditions'
trial_struct(trial_struct(:,2) == 1, 3) = ca;
trial_struct(trial_struct(:,2) == 1, 4) = max(ca_ps); % this needs to change if you ever have varying probabilities of the target doors
trial_struct(trial_struct(:,2) == 2, 3) = cb;
trial_struct(trial_struct(:,2) == 2, 4) = max(cb_ps);

% now add which target will be presented on that trial
trial_struct(:,5) = 0;
trial_struct(trial_struct(:,2) == 1, 5) = randi(ntargets, 1, ntrials);
trial_struct(trial_struct(:,2) == 2, 5) = randi(ntargets, 1, ntrials);

trial_struct(trial_struct(:,2) == 1, 6) = ca_trigger;
trial_struct(trial_struct(:,2) == 2, 6) = cb_trigger;
trial_struct(trial_struct(:,2) == 1, 7) = ca_mt_loc;
trial_struct(trial_struct(:,2) == 2, 7) = cb_mt_loc;
trial_struct(:,8) = randi(ntargets, 1, tntrials); % FOR NOW, TGT NUMBER
trial_struct(:,9) = 1;
% now make a trialstruct with 0 for col 9, so no multitask
tmp = trial_struct;
tmp(:,6:9) = 0;

trial_struct = [trial_struct; tmp];
% now randomly shuffle the rows of the matrix, within context
ca_trl_idx = find(trial_struct(:,2) == 1);
trial_struct(ca_trl_idx, :) = ...
    trial_struct(ca_trl_idx(randperm(length(ca_trl_idx))),:);
cb_trl_idx = find(trial_struct(:,2) == 2);
trial_struct(cb_trl_idx, :) = ...
    trial_struct(cb_trl_idx(randperm(length(cb_trl_idx))),:);

trial_struct = create_switch_conditions(trial_struct, ntrials*2, p);

end