%%%% this script creates the matrix of target location/condition
%%%% assignments across participants
clear all
rng(42); % meaning of life

nsubs = 128; % NOTE GO TO 64 FOR FIRST LOT OF COUNTERBALANCING

sub_infos = zeros(nsubs/2, 12); % 22 cols, 1 & 2 = sub and group, 3:6 = ca_idxs, 
% 7:10 = cb_idxs, 11:12 = colour context
% assignment,13 = do you start with context A or B in the task switching
% stage?

for isub = 1:4:nsubs/2

    % assign subject numbers
    sub_infos(isub,1) = isub;
    for iplus = 1:3
        sub_infos(isub+iplus,1) = isub+iplus;
    end

    sub_infos(isub:isub+1,2) = 1;
    sub_infos(isub+2:isub+3,2) = 2;

    [~, ca_idxs, cb_idxs] = assign_target_locations(isub);

    % context a & b locations
    sub_infos(isub, 3:6) = ca_idxs;
    sub_infos(isub, 7:10) = cb_idxs;
    for iplus = 1:3
        sub_infos(isub+iplus, 3:6) = ca_idxs;
        sub_infos(isub+iplus, 7:10) = cb_idxs;
    end

    % do colours
    sub_infos(isub:isub+3, 11) = [1,2,1,2];
    
end

% now add which context goes first in the task switching staghe
contxt_frst_task_switch = [1,1,1,1,2,2,2,2];
sub_infos(:,12) = repmat(contxt_frst_task_switch, 1, length(sub_infos(:,1))/length(contxt_frst_task_switch));

% now duplicate to get to higher numbers

tmp = sub_infos;
tmp(:,1) = tmp(:,1)+(nsubs/2);

sub_infos = [sub_infos; tmp];

save('sub_infos', 'sub_infos')