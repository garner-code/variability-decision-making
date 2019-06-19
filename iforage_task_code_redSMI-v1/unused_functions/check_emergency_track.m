function [] = check_emergency_track(el)

[key_down, ~, key_code] = KbCheck;
if KbName(find(key_code)) == 'x'
    ShowCursor;
    EyelinkDoTrackerSetup(el); % calibrate
    WaitSecs(0.1);
    Eyelink('StartRecording');
    WaitSecs(0.1);
    HideCursor;
end

end