load('sub_infos.mat'); % matrix of counterbalancing info
% see generate_sub_info_mat for details

% probabilities of target location and number of doors
load('probs_cert_world_v2.mat'); % this specifies that there are 4 doors with p=0.25 each 
door_probs   = probs_cert_world;
clear probs_cert_world 


ntrials = 4*40; % must have whole integers for p=.7/.3 or .95/.05
lo_switch = .05;
hi_switch = .3;

tmp = zeros(1, size(sub_infos, 1));
for isub = 1:size(sub_infos,1)

    sub_config = sub_infos(isub, :);


    if sub_config(2) == 1
        switch_prob = lo_switch;
    elseif sub_config(2) == 2
        switch_prob = hi_switch;
    end

    [trials, ~, ~] = generate_trial_structure_train(ntrials, sub_config, door_probs, switch_prob);

    tmp(isub) = sum(trials(:,2) == 1) == sum(trials(:,2) == 2);

end
