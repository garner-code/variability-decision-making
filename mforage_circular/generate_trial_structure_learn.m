function [trial_struct] = generate_trial_structure_learn(ntrials, ...
    sub_config, ...
    door_probs, ...
    house)
%%%%%
% GENERATE_TRIAL_STRUCTURE_LEARN
% generate the trial structure for the initial learning stage
% which is essentially equivalent to generating 200 trials for each context
% if the person hasn't got it in that time, then we assume they can't do
% the experiment
%
% inputs - ntrials = number of trials in each condition
% sub_config [1, structure] = subject counterbalancing info loaded from
% 'sub_infos.mat'
% door_probs [1, ndoors] = set of target probabilities to be distributed
% among the doors
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

% set the number of doors for getting other info later
ndoors = length(door_probs);
% get locations for this stage % WARNING - HARD CODED
if house < 9 % if house 1 or 2 then only make trials from one house

    % first work out from sub_config which task goes first
    if house == 1 % if this is the first house encountered
        if sub_config.frst == 1 % if this is 1, then task 1 is A
            task_doors = sub_config.tasks.a;
        else
            task_doors = sub_config.tasks.b;
        end
    elseif house == 2 % if second house encountered
        if sub_config.frst == 1
            task_doors = sub_config.tasks.b;
        else
            task_doors = sub_config.tasks.a;
        end
    end

    tntrials = ntrials;% this assumes only 2 contexts

    % hardcoded 2 would need to change for experiments involving more than 2.
    trial_struct = zeros(tntrials, 4);
    trial_struct(:,1) = 1:length(trial_struct(:,1)); % allocate trial number
    trial_struct(:,2) = house;

    % get target locations for each context
    task_probs = zeros(1, ndoors);
    task_probs(task_doors) = door_probs(door_probs > 0);

    % now generate the tgt locs for each trial in each context
    tgt_locs = get_locs_given_probs_v2(ntrials, task_probs, ndoors);

    % allocate a target door to each trial
    trial_struct(:, 3) = tgt_locs;
    trial_struct(:, 4) = max(door_probs); % this needs to change if you ever have varying probabilities of the target doors

    % now add which target will be presented on that trial
    trial_struct(:,5) = NaN; % this is not relevant, it indexed the target number drawn from the stack of 0-100, 
    % and we now have four folders/categories
    % but keeping in case we need in future

else % if not, make blocks of both trials

    tntrials = ntrials*2;% this assumes only 2 contexts
    if sub_config.frst == 1
        task_a_doors = sub_config.tasks.a;
        task_b_doors = sub_config.tasks.b;
    else
        task_a_doors = sub_config.tasks.b;
        task_b_doors = sub_config.tasks.a;
    end

    trial_struct = zeros(tntrials, 4);
    trial_struct(:,1) = 1:length(trial_struct(:,1)); %

    [ttrials, ~] = size(trial_struct);
    trial_struct(1:(ttrials/2),2) = 1;
    trial_struct((ttrials/2)+1:ttrials,2) = 2;

    % now select target locations for each task
    ta_ps = zeros(1,ndoors);
    ta_ps(task_a_doors) = door_probs(door_probs > 0);
    tb_ps = zeros(1,ndoors);
    tb_ps(task_b_doors) = door_probs(door_probs > 0);

    ta_locs = get_locs_given_probs_v2(ntrials, ta_ps, ndoors);
    tb_locs = get_locs_given_probs_v2(ntrials, tb_ps, ndoors);

    trial_struct(trial_struct(:,2) == 1, 3) = ta_locs;
    trial_struct(trial_struct(:,2) == 1, 4) = max(ta_ps);
    trial_struct(trial_struct(:,2) == 2, 3) = tb_locs;
    trial_struct(trial_struct(:,2) == 2, 4) = max(tb_ps);

    trial_struct(:,5) = NaN;
end % end if house < 9