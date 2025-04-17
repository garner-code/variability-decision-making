function make_transparent_badges()

badge_files = dir('Badges/');
badge_names = {'Bronze', 'Silver', 'Gold', 'Champion'};

for ibadge = 1:length(badge_names)

    badge_fname = fullfile(badge_files(1).folder, ...
        sprintf('%s.png', badge_names{ibadge}));
    [badge, ~, alpha] = imread(badge_fname);
    alpha = uint8(double(alpha) * 0.2);
    new_badge_fname = fullfile(badge_files(1).folder, ...
        sprintf('%s_locked.png', badge_names{ibadge}));
    imwrite(badge, new_badge_fname, 'Alpha', alpha);

end