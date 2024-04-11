function [trial_struct, c_ps] = generate_trial_structure_learn(ntrials, sub_config, door_probs, house)
%%%%%
% GENERATE_TRIAL_STRUCTURE_LEARN
% generate the trial structure for the initial learning stage
% which is essentially equivalent to generating 200 trials for each context
% if the person hasn't got it in that time, then we assume they can't do
% the experiment
%
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
% ca_ps = 1,ndoor vector of which p goes with which door for context a
% cb_ps = as above, but for context b

ndoors = length(door_probs);
ntargets = 100; % total number of targets to choose from
tntrials = ntrials;% this assumes only 2 contexts

% get locations for this stage % WARNING - HARD CODED
if house == 1
    c_idxs = sub_config(3:6); % context A
else
    c_idxs = sub_config(7:10); % context B
end

% hardcoded 2 would need to change for experiments involving more than 2.
trial_struct = zeros(tntrials, 4); 
trial_struct(:,1) = 1:length(trial_struct(:,1)); % allocate trial number
trial_struct(:,2) = house;

% get target locations for each context
c_ps = zeros(1,ndoors);
c_ps(c_idxs) = door_probs(door_probs > 0);

% now generate the tgt locs for each trial in each context
c_locs = get_locs_given_probs_v2(ntrials, c_ps);

% allocate a target door to each trial
trial_struct(:, 3) = c_locs;
trial_struct(:, 4) = max(c_ps); % this needs to change if you ever have varying probabilities of the target doors

% now add which target will be presented on that trial
trial_struct(:,5) = 0;
trial_struct(:, 5) = randi(ntargets, 1, ntrials);

end