%%%% this script creates the matrix of target location/condition
%%%% assignments across participants
clear all
nsubs = 128;

sub_infos = zeros(nsubs/2, 24); % 22 cols, 1 & 2 = sub and group, 3:6 = ca_idxs, 
% 7:10 = cb_idxs, 11:14 = cc_idxs, 15:18 = cd_idxs, 19:22 = colour context
% assignment,
% 23 - do you have A or B for complete transfer?
% 24 - do you do complete or hybrid transfer first?

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

    % transfer counterbalancing (if happening)
    sub_infos([isub,isub+2],23) = 1;
    sub_infos([isub+1,isub+3],23) = 2;
    for icomp = isub:isub+3
        if sub_infos(icomp, 23) == 1
            sub_infos(icomp,11:14) = ca_idxs;
        elseif sub_infos(icomp, 23) == 2
            sub_infos(icomp,11:14) = cb_idxs;
        end
    end

    % now get transfer locations    
    [~, ~, hybrid_idxs] = assign_transfer_conditions(isub, ...
            1, ca_idxs, cb_idxs);
    for ihybrid = isub:isub+3
        sub_infos(ihybrid,15:18) = hybrid_idxs;
    end

    % context colours
    sub_infos(isub, 19:22) = randperm(4);
    for iplus = 1:3
        sub_infos(isub+iplus, 19:22) = sub_infos(isub, 19:22);
    end
    sub_infos(isub:isub+3,24) = 1; % meaning they get complete transfer first
end

tmp = sub_infos;
tmp(:,1) = tmp(:,1)+(nsubs/2);
tmp(:,24) = 2;

sub_infos = [sub_infos; tmp];

save('sub_infos', 'sub_infos')