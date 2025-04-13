function [trials, n_trls_per_block] = allocate_dual_task_trials(search_trials, ...
                                                n_trials_between_mem_probe)

% add an extra two columns to search trials, the first denotes if there
% should be a memory display at the start of the trial, and the second
% denotes if there should be a probe at the end
dt_strt_col = size(search_trials,2)+1;
dt_end_col = dt_strt_col+1;
mem_context_col = dt_end_col+1;

search_trials(:,[dt_strt_col, dt_end_col, mem_context_col]) = 0;

context_a_trials = search_trials(search_trials(:,2) == 1, :);
context_b_trials = search_trials(search_trials(:,2) == 2, :);

%%%%%%%%%%
end_idx = cumsum(n_trials_between_mem_probe);
strt_idx = end_idx - n_trials_between_mem_probe + 1;
mx = max(end_idx);
% below is ugly and hardcoded, but just setting up contexts from which to 
% draw memory trials, could do a linear transform, but for future me
context_a_trials(:,mem_context_col) = repelem([2,3,0], mx);
context_b_trials(:,mem_context_col) = repelem([1,4,0], mx);

end_idx = [end_idx, end_idx+mx, end_idx+(2*mx)];
strt_idx = [strt_idx, strt_idx+mx, strt_idx+(2*mx)];

collect_trial_blocks = cell(2,length(end_idx));
for i = 1:length(end_idx)

    collect_trial_blocks{1,i} = context_a_trials(strt_idx(i):end_idx(i), :);
    collect_trial_blocks{2,i} = context_b_trials(strt_idx(i):end_idx(i), :);
    if strt_idx(i) <= mx*2
        collect_trial_blocks{1,i}(1,dt_strt_col) = 1;
        collect_trial_blocks{1,i}(size(collect_trial_blocks{1,i},1),dt_end_col) = 1;
        collect_trial_blocks{2,i}(1,dt_strt_col) = 1;
        collect_trial_blocks{2,i}(size(collect_trial_blocks{2,i},1),dt_end_col) = 1;
    end
end

% now randomise the order of the blocks
n_blocks = length(collect_trial_blocks);
% now randomly order the blocks on each row
collect_trial_blocks(1,:) = collect_trial_blocks(1,randperm(n_blocks));
collect_trial_blocks(2,:) = collect_trial_blocks(2,randperm(n_blocks));
% now collate the sub blocks into bigger blocks of 6 subsets each
n_subset_per_block = 6;
strt_subsets = 1:n_subset_per_block:n_blocks;
nd_subsets = n_subset_per_block:n_subset_per_block:n_blocks;
subsets = cell(size(collect_trial_blocks,1), length(strt_subsets));
for isub = 1:length(strt_subsets)
   subsets{1, isub} = cat(1, collect_trial_blocks{1,strt_subsets(isub):nd_subsets(isub)});
   subsets{2, isub} = cat(1, collect_trial_blocks{2,strt_subsets(isub):nd_subsets(isub)});
end
collect_subsets = reshape(subsets, 1, length(subsets)*2);
collect_subsets = collect_subsets(randperm(length(subsets)*2));
% get the number of rows before concatenating into trial matrix
n_trls_per_block = arrayfun(@(x) size(x{:},1), collect_subsets);

trials = cell2mat(collect_subsets');
trials(:,1) = 1:size(trials,1);