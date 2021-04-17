function el=initialise_eyes(window)

% initialise EYE TRACKER
    el=EyelinkInitDefaults(window);
    if ~EyelinkInit(0, 1)
        fprintf('Eyelink Init aborted.\n');
        cleanup;  % cleanup function
        return;
    end

end