function [trial_struct] = generate_trial_structure_learn(ntrials, sub_config, door_probs)
%%%%%
% GENERATE_TRIAL_STRUCTURE_LEARN
% generate the trial structure for the initial learning stage
% which is essentially equivalent to generating 200 trials for each context
% if the person hasn't got it in that time, then we assume they can't do
% the experiment
% [trial_struct] = 5 x ntrials matrix, with columns of trial number,
% condition (1, 2), and tgt location, tgt prob, and tgt id
% num
% ps is a 1 x ndoor x ndisplay matrix, with the probs assigned to each door in each condition for this session 

% inputs - ntrials = number of trials in each condition - should work for
% multiples of 10, but has only been tested for 100 and 60
ndoors = 16;

trial_struct = zeros(ntrials*2, 4);
trial_struct(:,1) = 1:length(trial_struct(:,1));

% define whether context 1 or context 2 comes first - wayoooo
[ttrials, ~] = size(trial_struct);
trial_struct(1:(ttrials/2),2) = sub_config(3);
trial_struct((ttrials/2)+1:ttrials,2) = 3 - sub_config(3);

%%%%% consider making this a function
% now get the location/prob configuration for this session
x_mat = zeros(4,4);
a = x_mat;
a([6,7,9,16])=1;
b=x_mat;
b([3,5,11,13])=1;
% c=x_mat;
% c([2,8,12,14])=1;
% d=x_mat;
% d([1,4,10,15])=1;
bases = cat(3, a,b);

loc_config = bases;
ca_ps = zeros(1,ndoors);
ca_ps(find(loc_config(:,:,sub_config(3)))) = door_probs(door_probs > 0);

cb_ps = zeros(1,ndoors);
cb_ps(find(loc_config(:,:,3-sub_config(3)))) = door_probs(door_probs > 0);
%%%%% end make function

% now generate the tgt locs for each trial in each condition
ca_locs = get_locs_given_probs_v2(ntrials, ca_ps);
cb_locs = get_locs_given_probs_v2(ntrials, cb_ps);

% allocate to trial structure % KG: MFORAGE: This needs to be so that which
% ever context is first according to the counterbalancing is put first in
% the trial structure
trial_struct(cert_cond_tn, 2) = 1; % 
trial_struct(trial_struct(:,2) == 1, 3) = cert_locs;
trial_struct(trial_struct(:,2) == 1, 4) = cert_probs(1);
trial_struct(uncert_cond_tn, 2) = 2;
trial_struct(trial_struct(:,2) == 2, 3) = uncert_locs;
trial_struct(trial_struct(:,2) == 2, 4) = cert_probs(1);

% now add which target will be presented on that trial
trial_struct(:,5) = 0;
trial_struct(trial_struct(:,2) == 1, 5) = randperm(ntrials);
trial_struct(trial_struct(:,2) == 2, 5) = randperm(ntrials);

end