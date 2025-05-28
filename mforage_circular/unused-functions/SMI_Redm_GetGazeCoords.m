function [x,y,t] = SMI_Redm_GetGazeCoords(REDm_info)
% x - xcoord of gaze
% y - ycoord of gaze
% t  - timestamp of data sample

if (calllib('iViewXAPI', 'iV_GetSample', REDm_info.pSampleData) == 1)
    
    % get sample
    Smp = libstruct('SampleStruct', REDm_info.pSampleData);
    
    x = Smp.leftEye.gazeX;
    y = Smp.leftEye.gazeY;
    t = Smp.timestamp;
else
    x = [];
    y = [];
    t = [];
end