function SMI_Redm_DisconnectEyetracker

% disconnect from iViewX 
calllib('iViewXAPI', 'iV_Disconnect')
pause(1);


% end of function