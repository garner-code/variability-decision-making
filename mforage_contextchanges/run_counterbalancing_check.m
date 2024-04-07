%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% check counterbalancing of the switching training task
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% note that the auto-selection doesn't work perfectly for configurations
% that match on a but differ on b. I have manually checked those ones and
% they are fine. KG: 7/04/24

% here I check the sub_info.mat file has done what I think it has

% rules - if col 23 == 1, then cols 11:14 should be the same as cols 3:6,
% if 2, then cols 11:14 should be the same as cols 7:10

% cols 3:6 should not share any elements with cols 7:8

% cols 15:18 should have 2 from 3:6, and 2 from 7:10

% for each set of a and b doors, there should be 8 participants, 4 from
% each group, 4 from each group should have a 1 for col 24, and 4 should
% have a 2, of each of these 4, 2 should have a 1 and 2 should have a 2 for
% column 23

% there should only be numbers 1:4 in cols 19:22, with no repeats
clear all
load('sub_infos.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% go
% step 1: get unique configurations for context A
unique_as = unique(sub_infos(:,3:6), 'rows');
[n_unique_as, ~] = size(unique_as); % number of unique configurations

% add a loop for unique bs if its an issue for more than case 9

for i_unique_a = 1:n_unique_as

    % first get indexes of the rows in that matrix tha are == that config
    nu_idx = find(sum(ismember(sub_infos(:, 3:6), unique_as(i_unique_a, :)),2) == 4);

    this_case = sub_infos(nu_idx, :);

    % question 1: are there 8?
    [n_cases, ~] = size(this_case);
    if n_cases ~= 8
        sprintf('warning - config %d doesn`t return 8 cases', i_unique_a)
        keyboard % manually checked 9  - its fine
    else
        sprintf('config %d passes cases test', i_unique_a)
    end

    % question 2: check grouping
    grp_a_idx = find(this_case(:,2) == 1);
    grp_b_idx = find(this_case(:,2) == 2);
    if length(grp_a_idx) < 4 || length(grp_b_idx) < 4
        sprintf('warning - config %d doesn`t return 4 per group', i_unique_a);
        keyboard
    else
        sprintf('config %d passes cases n per group test', i_unique_a)
    end

    % question 3, do 2 of each group have complete transfer first (col 24 ==
    % a), and of those who have complete transfer first, do equal numbers of
    % them have context a for complete transfer vs context b?


    % there should be 4 in each group
    grp_a_balance = [sum(this_case(grp_a_idx, 23) == 1 & this_case(grp_a_idx, 24) == 1),... % a for complete and complete first
        sum(this_case(grp_a_idx, 23) == 1 & this_case(grp_a_idx, 24) == 2),... % a for complete and hybrid first
        sum(this_case(grp_a_idx, 23) == 2 & this_case(grp_a_idx, 24) == 1),... % b for complete and complete first
        sum(this_case(grp_a_idx, 23) == 2 & this_case(grp_a_idx, 24) == 2)];  % b for complete and hybrid first
    grp_b_balance = [sum(this_case(grp_b_idx, 23) == 1 & this_case(grp_b_idx, 24) == 1),... % a for complete and complete first
        sum(this_case(grp_b_idx, 23) == 1 & this_case(grp_b_idx, 24) == 2),... % a for complete and hybrid first
        sum(this_case(grp_b_idx, 23) == 2 & this_case(grp_b_idx, 24) == 1),... % b for complete and complete first
        sum(this_case(grp_b_idx, 23) == 2 & this_case(grp_b_idx, 24) == 2)];

    if max([grp_a_balance, grp_b_balance]) ~= 1
        sprintf('warning - config %d doesn`t return balanced counterbalancing', i_unique_a)
    elseif ~isequal(grp_a_balance, grp_b_balance)
        sprintf('warning - config %d doesn`t return balanced counterbalancing across groups', i_unique_a)
        keyboard
    else
        sprintf('config %d passes counterbalancing test', i_unique_a)
    end


    % now check if A and B don't share elements
    context_elements_check = unique(this_case(:, 3:10), 'rows');
    shared = 0;
    [n_context_element_configs, ~] = size(context_elements_check);
    for i_context_elements = 1:n_context_element_configs
        check = sum(ismember(context_elements_check(i_context_elements, 1:4), ...
            context_elements_check(i_context_elements, 5:8)));
        shared = shared + check;
    end
    if ~shared
        sprintf('config %d passes shared elements test', i_unique_a);
    else
        sprintf('warning - config %d shares elements between context A and B', i_unique_a);
        keyboard
    end

    % check counterbalancing of transfer locations
    chk_a_transfer_idx = find(this_case(:, 23) == 1);
    chk_b_transfer_idx = find(this_case(:, 23) == 2);
    complete_check = 0;
    for i_tl_chk = 1:length(chk_a_transfer_idx)
        count_a = sum(ismember(this_case(chk_a_transfer_idx(i_tl_chk), 7:10),...
            this_case(chk_a_transfer_idx(i_tl_chk), 11:14)));
        count_b = sum(ismember(this_case(chk_b_transfer_idx(i_tl_chk), 3:6),...
            this_case(chk_b_transfer_idx(i_tl_chk), 11:14)));
        complete_check = complete_check + count_a + count_b;
    end
    if ~complete_check
        sprintf('config %d passes complete transfer test', i_unique_a)
    else
        sprintf('warning - problem with complete transfer for config %d', i_unique_a)
        keyboard
    end

    partial_check = 0;
    for ipartial = 1:n_cases
        a_part = sum(ismember(this_case(ipartial, 3:6), this_case(ipartial, 15:18)));
        b_part = sum(ismember(this_case(ipartial, 7:10), this_case(ipartial, 15:18)));


        if a_part ~= b_part || a_part ~= 2
            partial_check = partial_check + 1;   
        end
    end
    if ~partial_check
        sprintf('config %d passes hyrbid transfer test', i_unique_a)
    else
        sprintf('warning - problem with hybrid transfer for config %d', i_unique_a)
        keyboard
    end
end
