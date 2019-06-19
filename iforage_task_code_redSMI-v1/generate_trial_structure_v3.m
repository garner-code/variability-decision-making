function [trial_struct, cert_ps, uncert_ps] = generate_trial_structure_v3(ntrials, sub_loc_config, cert_probs, uncert_probs, init_order)

% [trial_struct] = ntrials x 5 matrix, with columns of trial number,
% condition (1 = cert, 2 = uncert), and tgt location, tgt prob, and tgt id
% num
% cert_org, and uncert_org are vectors encoding which prob was assigned to
% which location

% inputs - ntrials = number of trials in each condition - should work for
% multiples of 10, but has only been tested for 100 and 60

trial_struct = zeros(ntrials*2, 4);
trial_struct(:,1) = 1:length(trial_struct(:,1));
% 1st 40 trials consist of 20 trials from each condition (blocked - to
% better aid learning of the two contexts)
trial_struct(1:20,2) = init_order;
trial_struct(21:40,2) = 3-init_order;


% get random numbers across trials to allocate to each condition
trial_blocs  = datasample(41:1:max(trial_struct(:,1)), length(41:1:max(trial_struct(:,1))), 'Replace', false);
cert_cond_tn = sort(trial_blocs(1:length(trial_blocs)/2), 'ascend');
uncert_cond_tn = sort(trial_blocs(length(trial_blocs)/2+1:length(trial_blocs)), 'ascend');

% now get the location/prob configuration for that participant
cert_base = zeros(4,4);
cert_base([4, 6, 9, 15]) = 1;
cert_config = rot90(cert_base, sub_loc_config(1));
cert_ps = zeros(1,16);
cert_ps(find(cert_config)) = cert_probs(cert_probs > 0);

uncert_base = zeros(4,4);
uncert_base([1 2 3 6 7 8 9 10 11 12 13 15]) = 1;
uncert_config = rot90(uncert_base, sub_loc_config(2));
uncert_ps = zeros(1,16);
uncert_ps(find(uncert_config)) = uncert_probs(uncert_probs > 0);
% now generate the tgt locs for each trial in each condition
cert_locs = get_locs_given_probs_v2(ntrials, cert_ps);
uncert_locs = get_locs_given_probs_v2(ntrials, uncert_ps);

% allocate to trial structure
trial_struct(cert_cond_tn, 2) = 1;
trial_struct(trial_struct(:,2) == 1, 3) = cert_locs;
trial_struct(trial_struct(:,2) == 1, 4) = cert_probs(1);
trial_struct(uncert_cond_tn, 2) = 2;
trial_struct(trial_struct(:,2) == 2, 3) = uncert_locs;
trial_struct(trial_struct(:,2) == 2, 4) = uncert_probs(1);

% now add which target will be presented on that trial
trial_struct(:,5) = 0;
trial_struct(trial_struct(:,2) == 1, 5) = randperm(ntrials);
trial_struct(trial_struct(:,2) == 2, 5) = randperm(ntrials);

end