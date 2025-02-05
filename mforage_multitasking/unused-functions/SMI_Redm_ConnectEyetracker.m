function connected = SMI_Redm_ConnectEyetracker(REDm_info,redmlogfilename,sendIP,sendport,recIP,recport)
% connected = 1   -> successful connection and communication between eyetracker and matlab
% connected = 0   -> connection not established.
% redmlogfilename -> name of a logfile where the eyatracker operation can be
%       written to. Normally nothing of real interest goes in here as far as I can
%       tell. i.e. it only has operating info, not actual data written to it.
% sendIP,sendport,recIP,recport -> these are the values (default is below) for
%       operating the eyetracker on the same PC as the stimulus presentation
%       software (matlab) session.

connected = 0;

if nargin <6
    recport = REDm_info.DefaultComms.recport;
end
if nargin <5
    recIP = REDm_info.DefaultComms.recIP;
end
if nargin <4
    sendport = REDm_info.DefaultComms.sendport;
end
if nargin <3
    sendIP = REDm_info.DefaultComms.sendIP;
end
if nargin <2
    redmlogfilename = REDm_info.DefaultComms.logfilename;
end
if nargin <1
    disp('ERROR - SMI_Redm_ConnectEyetracker - not enough arguments')
    return
end



disp('Define Logger')
calllib('iViewXAPI', 'iV_SetLogger', int32(1), redmlogfilename )

disp('Connect to iViewX')
ret = calllib('iViewXAPI', 'iV_Connect', sendIP, int32(sendport), recIP, int32(recport))
switch ret
    case 1
        connected = 1;
    case 104
         msgbox('Could not establish connection. Check if Eye Tracker is running', 'Connection Error', 'modal');
    case 105
         msgbox('Could not establish connection. Check the communication Ports', 'Connection Error', 'modal');
    case 123
         msgbox('Could not establish connection. Another Process is blocking the communication Ports', 'Connection Error', 'modal');
    case 200
         msgbox('Could not establish connection. Check if Eye Tracker is installed and running', 'Connection Error', 'modal');
    otherwise
         msgbox('Could not establish connection', 'Connection Error', 'modal');
end