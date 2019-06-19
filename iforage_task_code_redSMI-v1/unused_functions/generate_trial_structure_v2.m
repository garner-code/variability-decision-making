function [trial_struct, cert_org, uncert_org] = generate_trial_structure_v2(ntrials, cert_probs, uncert_probs)

% [trial_struct] = ntrials x 5 matrix, with columns of trial number,
% condition (1 = cert, 2 = uncert), and tgt location, tgt prob, and tgt id
% num
% cert_org, and uncert_org are vectors encoding which prob was assigned to
% which location
% inputs - ntrials = number of trials in each condition - should work for
% multiples of 10, but has only been tested for 100 and 60

trial_struct = zeros(ntrials*2, 4);
trial_struct(:,1) = 1:length(trial_struct(:,1));

trial_blocs  = datasample(1:10:max(trial_struct(:,1)), length(1:10:max(trial_struct(:,1))), 'Replace', false);
cert_cond_tn = sort(trial_blocs(1:length(trial_blocs)/2), 'ascend');
uncert_cond_tn = sort(trial_blocs(length(trial_blocs)/2+1:length(trial_blocs)), 'ascend');

[cert_locs, cert_idx] = get_locs_given_probs(ntrials, cert_probs);
[uncert_locs, uncert_idx] = get_locs_given_probs(ntrials, uncert_probs);

loc_rw_idx = 1:10:ntrials;
for count = 1:length(loc_rw_idx)
    
    % now I want to get cert_locs(loc_rw_idx(count):loc_rw_idx(count)+9),
    % get the locations these ids refer to, and put them in
    % trial_struct(cert_cond_tn(count):cert_cond(count)+9)
    these_cert_loc_idxs = cert_locs(loc_rw_idx(count):loc_rw_idx(count)+9);
    trial_struct(cert_cond_tn(count):cert_cond_tn(count)+9, [2 3]) = [repmat(1, 1, 10)' cert_idx(these_cert_loc_idxs)'];
    trial_struct(cert_cond_tn(count):cert_cond_tn(count)+9, 4) = cert_probs(these_cert_loc_idxs);
    
    these_uncert_loc_idxs = uncert_locs(loc_rw_idx(count):loc_rw_idx(count)+9);
    trial_struct(uncert_cond_tn(count):uncert_cond_tn(count)+9, [2 3]) = [repmat(2, 1, 10)' uncert_idx(these_uncert_loc_idxs)'];
    trial_struct(uncert_cond_tn(count):uncert_cond_tn(count)+9, 4) = uncert_probs(these_uncert_loc_idxs);
end

% now add which target will be presented on that trial
trial_struct(:,5) = 0;
trial_struct(trial_struct(:,2) == 1, 5) = randperm(ntrials);
trial_struct(trial_struct(:,2) == 2, 5) = randperm(ntrials);

cert_org = [];
uncert_org = [];
for i = 1:max(cert_idx)
    cert_org(i) = cert_probs(cert_idx == i);
    uncert_org(i) = uncert_probs(uncert_idx == i);
end

end