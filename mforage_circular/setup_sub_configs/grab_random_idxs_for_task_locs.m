function [idxs, new_outer, new_inner] = grab_random_idxs_for_task_locs(outer, inner)

% first grab some indexes for the current task
inner = inner(~cellfun('isempty', inner));
these_inners = randperm(length(inner), 2); % choose two quadrants from inner layer
these_outers = randperm(length(outer), 2); % EC: choose 2 quadrants from outer layer
tmp_outer = cellfun(@(x) x(randperm(length(x),1)), outer(these_outers)); % EC: choose one door from those quadrants
tmp_inner = cellfun(@(x) x(randperm(length(x),1)), inner(these_inners)); % EC: as above
idxs = sort([tmp_outer, tmp_inner]);

% now remove the selected indeces from outer and inner
new_outer = cellfun(@(x) setdiff(x,tmp_outer), outer, 'UniformOutput', false);
new_inner = cellfun(@(x) setdiff(x,tmp_inner), inner, 'UniformOutput', false);

end