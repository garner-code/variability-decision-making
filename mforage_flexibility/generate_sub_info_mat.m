%%%% this script creates the matrix of target location/condition
%%%% assignments across participants
clear all
rng('default');
rng(42); % meaning of life

nsubs = 128; % NOTE GO TO 64 FOR FIRST LOT OF COUNTERBALANCING

sub_infos = zeros(nsubs, 13); % 
% 1 & 2 = sub and group, 
% 3:6 = ca_idxs, 
% 7:10 = cb_idxs, 
% 11 = colour context mapping
% 12 = do you start with context A or B in the learning stage?
% 13 = do you start with context A or B in the testing stage?
% NOTE: it takes 16 subjects to go through all the counterbalancing for two
% randomly generated contexts
n_counter = 16;
sub_infos(:,1) = 1:nsubs;
sub_infos(:,2) = repmat([1,1,2,2], 1, nsubs/length([1,1,2,2]));
sub_infos(:,11) = repmat([1,2], 1, nsubs/length([1,2]));
sub_infos(:,12) = repmat([1,1,1,1,2,2,2,2], 1, nsubs/length([1,1,1,1,2,2,2,2]));
sub_infos(:,13) = repmat([1,1,1,1,1,1,1,1,...
                          2,2,2,2,2,2,2,2], 1, nsubs/length([1,1,1,1,1,1,1,1,...
                                                             2,2,2,2,2,2,2,2]));

% now assign the doors in blocks of 16
for isub = 1:n_counter:nsubs

    [~, ca_idxs, cb_idxs] = assign_target_locations(isub);

    % make a matrix of context a & b locations, to fit into the 
    % sub info matrix
    drs = repmat([ca_idxs, cb_idxs], n_counter, 1);
    sub_infos(isub:(isub+n_counter-1), 3:10) = drs;
    
end

save('sub_infos', 'sub_infos')