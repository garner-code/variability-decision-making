function SMI_Redm_StartRecordingData

% clear recording buffer
calllib('iViewXAPI', 'iV_ClearRecordingBuffer');

% start recording
calllib('iViewXAPI', 'iV_StartRecording');