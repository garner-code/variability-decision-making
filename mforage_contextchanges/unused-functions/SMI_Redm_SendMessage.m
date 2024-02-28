function SMI_Redm_SendMessage(message)
% Used to send a message to the eyetracker data stream
%
% Usage ->
% SMI_Redm_SendMessage('this is the message')


calllib('iViewXAPI', 'iV_SendImageMessage', message);