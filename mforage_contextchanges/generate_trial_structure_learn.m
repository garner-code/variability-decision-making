function [trial_struct, cert_ps, uncert_ps] = generate_trial_structure_learn(ntrials, sub_loc_config, cert_probs)
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

trial_struct = zeros(ntrials*2, 4);
trial_struct(:,1) = 1:length(trial_struct(:,1));

% get random numbers across trials to allocate to each condition (cert and
% uncert is legacy language, don't worry about the semantics, it just
% disambiguates 2 conditions)
trial_blocs  = datasample(1:1:max(trial_struct(:,1)), length(1:1:max(trial_struct(:,1))), 'Replace', false);
cert_cond_tn = sort(trial_blocs(1:length(trial_blocs)/2), 'ascend');
uncert_cond_tn = sort(trial_blocs(length(trial_blocs)/2+1:length(trial_blocs)), 'ascend');

% now get the location/prob configuration for that participant and session
% I randomly selected a tile from each quadrant, and allocated to each
% context - so for each context, a target appears in each location but
% there is no overlapping
x_mat = zeros(4,4);
a = x_mat;
a([6,7,9,16])=1;
b=x_mat;
b([3,5,11,13])=1;
c=x_mat;
c([2,8,12,14])=1;
d=x_mat;
d([1,4,10,15])=1;
bases = cat(3, a,b,c,d);

cert_config = bases(:,:,sub_loc_config(1));
cert_ps = zeros(1,16);
cert_ps(find(cert_config)) = cert_probs(cert_probs > 0);

% second display condition for this session
uncert_config = bases(:,:,sub_loc_config(2));
uncert_ps = zeros(1,16);
uncert_ps(find(uncert_config)) = cert_probs(cert_probs > 0);

% now generate the tgt locs for each trial in each condition
cert_locs = get_locs_given_probs_v2(ntrials, cert_ps);
uncert_locs = get_locs_given_probs_v2(ntrials, uncert_ps);

% allocate to trial structure
trial_struct(cert_cond_tn, 2) = 1;
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