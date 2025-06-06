function [trial_struct, novel_ps,...
    perm_ps, comp_ps] = generate_trial_structure_lttest(ntrials, ...
    sub_config, ...
    door_probs, ...
    n_transfer)
%%%%%
% GENERATE_TRIAL_STRUCTURE_LEARN
% generate the trial structure for the learning transfer stage
% which is essentially equivalent to generating 60 trials for each context
%
% inputs - ntrials = number of trials in each transfer condition 
% sub_config [1, n] = subject counterbalancing info loaded from
% 'sub_infos.mat'
% door_probs [1, ndoors] = set of target probabilities to be distributed
% among the doors
% n_transfer = how many learning transfer conditions
%
% RETURNS:
% [trial_struct] = 5 x ntrials matrix
% col 1 = trial number
% col 2 = context - 1 or 2
% col 3 = target door for that trial
% col 4 = a priori p(tgt door)
% col 5 = NaN - used to be the target id, but we draw it a different way
% now
% ca_ps = 1,ndoor vector of which p goes with which door for context a
% cb_ps = as above, but for context b

tasks = sub_config.tasks;
transfer_order = sub_config.trnsfr_order;

ndoors = length(door_probs);
tntrials = ntrials*n_transfer;
% hardcoded 2 would need to change for experiments involving more than 2.
trial_struct = zeros(tntrials, 4); 
trial_struct(:,1) = 1:length(trial_struct(:,1)); % allocate trial number

% now define which trials belong to which transfer condition
condition = repelem(transfer_order, ntrials);
trial_struct(:,2) = condition;

% get locations for each transfer task
novel = tasks.novel; 
perm = tasks.perm;
comp = tasks.comp;

% create a vector that corresponds to which probability has been assigned
% to the target doors
novel_ps = zeros(1,ndoors);
perm_ps = novel_ps;
comp_ps = novel_ps;
novel_ps(novel) = door_probs(door_probs > 0);
perm_ps(perm) = door_probs(door_probs > 0);
comp_ps(comp) = door_probs(door_probs > 0);

% now generate the tgt locs for each trial in each context
novel_locs = get_locs_given_probs_v2(ntrials, novel_ps, length(door_probs));
perm_locs = get_locs_given_probs_v2(ntrials, perm_ps, length(door_probs));
comp_locs = get_locs_given_probs_v2(ntrials, comp_ps, length(door_probs));

% allocate a target door to each trial
trial_struct(trial_struct(:,2) == 1, 3) = novel_locs;
trial_struct(trial_struct(:,2) == 1, 4) = max(novel_ps); % this needs to change if you ever have varying probabilities of the target doors
trial_struct(trial_struct(:,2) == 2, 3) = perm_locs;
trial_struct(trial_struct(:,2) == 2, 4) = max(perm_ps);
trial_struct(trial_struct(:,2) == 3, 3) = comp_locs;
trial_struct(trial_struct(:,2) == 3, 4) = max(comp_ps);
% now add which target will be presented on that trial
trial_struct(:,5) = NaN;

end