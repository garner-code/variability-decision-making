function [task] = make_third_task(context_a_doors, context_b_doors)
%%% if needed, make a third task, that meets the previous rules
%%% and shares no locations with a or b. it falls out that
%%% the remaining four doors will also be a legal task

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now same for neither context

%%%%%%%%%% set the options for each type of door allocation
%%%%%%%%%% conditionals for original selection:
%%%%%%%%%% A & B have different inner quadrants (so two remain)
%%%%%%%%%% A & B have 1 outer each that is different to their own
%%%%%%%%%% inner and different to each other.
%%%%%%%%%% This means I can select 1 remaining inner, and then
%%%%%%%%%% the remaining outer from the untouched quadrant
%%%%%%%%%% A & B each have two mid locations that are different to the
%%%%%%%%%% inner and outer quadrants, but could be the same as the other
%%%%%%%%%% task. Therefore, if A has inner 1, and outer 2, then B could
%%%%%%%%%% have inner 2,3,4 and outer 3 or 4.

outest = [1, 4, 13, 16]; % outer corners (pick one)
outmid = {[2, 5];... % outer but not a corner (pick 2)
    [3, 8];...
    [9, 14];...
    [12, 15]};
inner = [6, 7, 10, 11]; % (pick 1)
% get remaining doors to pick a set
n_outer = 1;
n_mid = 2;
n_inner = 2;

%%%% first get possible quadrants for the mid-selections
tmp = outmid;
for i = 1:length(tmp)
    tmp{i} = outmid{i}(~ismember(outmid{i}, ...
        [context_a_doors, context_b_doors]));
end
% the above provides an array of the possible inner quadrants from
% which to pick doors

% now work out which quadrants an outer door can be selected from
poss_outest = find(~ismember(outest, [context_a_doors, context_b_doors]));
poss_innest = find(~ismember(inner, [context_a_doors, context_b_doors]));
poss_mids = [];
for i = 1:length(tmp)
    if any(tmp{i})
        poss_mids = [poss_mids,i];
    end
end

% now it follows that there should be a legal task I can attain, if I 
% grab an outer door at random, and work through the remaining steps
this_outest = datasample(poss_outest, 1);
outest_door = outest(this_outest);
% now I can work through the possible quadrants for the inner door
% to determine the impacts on picking mid-doors
% given I have an outer, I can only go through inners that are
% in diff quadrants to the outer one
nu_inner = poss_innest(~ismember(poss_innest, this_outest));
for i_innest = 1:length(nu_inner) 
    this_innest = nu_inner(i_innest);
    % if I use this_outest, and this_innest, what are the remaining
    % quadrants where I must pick mid-doors
    mid_qs = setdiff(1:4, [this_outest, this_innest]);
    % now can I select a door from each of the mid-quadrants?
    n_mids = sum(ismember(poss_mids, mid_qs)); % this should be 2 if all is good
    if n_mids == 2
        this_mids = mid_qs;
        break
    end
end

% the above loop should have made a legal task, now we can get the doors
% and test they don't belong to a or b
% first get some mid locs
get_mids = tmp(this_mids); % scroll through mids from these quadrants
mid_locs = zeros(1,2); % you will use these doors from the mids
for i_get_mids = 1:length(get_mids)
    mid_locs(i_get_mids) = datasample(get_mids{i_get_mids},1);
end

task = [outest_door, mid_locs, inner(this_innest)];

end

