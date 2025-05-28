function SMI_Redm_Shutdown
% clear all
% unload iViewX API libraray

% shutdown the iviewX data software server
calllib('iViewXAPI', 'iV_Quit');

% empty library functions from memory
unloadlibrary('iViewXAPI');