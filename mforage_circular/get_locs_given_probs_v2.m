function [trial_locs] = get_locs_given_probs_v2(n, probs, n2sample)

% function takes the number of trials per condition and selects the 
% target location over n trials, given that vector of target probailities

trial_locs = datasample(1:n2sample, n, 'Replace', true, 'Weights', probs);

end