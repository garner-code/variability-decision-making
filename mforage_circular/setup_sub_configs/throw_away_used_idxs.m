function [new_outer, new_inner] = throw_away_used_idxs(outer, inner, ...
    outer_idxs_2throw, inner_idxs_2throw)

% now remove the selected indeces from outer and inner
new_outer = cellfun(@(x) setdiff(x,outer_idxs_2throw), outer, 'UniformOutput', false);
new_inner = cellfun(@(x) setdiff(x,inner_idxs_2throw), inner, 'UniformOutput', false);

end