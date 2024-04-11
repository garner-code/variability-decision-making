function [RGBs, locs] = get_rgbs_and_locs_for_subjects(subject_number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET_RGBS_AND_LOCS_FOR_SUBJECTS
% use this function to find out the rbg values and locations for
% a given subject number
% Kwargs:
%   - subject_number [int] - subject number you want the information for
% Outputs
%   - RGBs [int: 2, 3] - a 2 x 3 matrix giving the rgb values for the
%   contexts, in the order the participant sees them
%   - Locs [int: 2, 4] - a 2 x 4 matrix giving the target locations for each
%   context
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define required variables
sub = subject_number;
green = [27, 158, 119]; 
orange = [217, 95, 2];
purple = [117, 112, 179];
pink = [189, 41, 138]; 
colour_options = {green, orange, purple, pink};

% get sub config info
load('sub_infos');
sub_config = sub_infos(sub, :);

% get RGBs
RGBs = [colour_options{sub_config(19)}; ... 
                      colour_options{sub_config(20)}];

locs = [sub_config(3:6); ...
        sub_config(7:10)];

end