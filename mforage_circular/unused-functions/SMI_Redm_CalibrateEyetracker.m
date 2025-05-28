function SMI_Redm_CalibrateEyetracker(REDm_info, monitorID, screensizeX, screensizeY, cal_area_scale, mode_filename )
% monitor ID                -> screenID - i.e. 1,2 for where the calibration is to take place
% mode_filename (optional)  -> calibration filename if want to save calibration or [] if not saving calibration data
% screensizeX,Y (optional)  -> screen pixel size in case using a different one than the default screen resolution
% cal_area_scale            -> a multiplier 0-1 to shrink the calibration area
if nargin < 1
   % error
   return
end
if nargin < 2
    monitorID = 0; % set to the default monitor value in the InitiViewXAPI function
end
if nargin < 4
    screensizeX = [];
    screensizeY = [];
end
if nargin < 5
    cal_area_scale = 1;
end
if nargin < 6
    mode_filename = [];
end


% load monitor
if int32(monitorID) ~= REDm_info.CalibrationData.displayDevice
    REDm_info.CalibrationData.displayDevice = int32(monitorID-1); % 0 - primary, 1 - secondary
end
% initiate structure pointer
pCalibrationData = libpointer('CalibrationStruct', REDm_info.CalibrationData);

pCalibrationPointData = libpointer('CalibrationPointStruct'); % calibration point structure - no initial values
% % int number number of calibration point
% % int positionX horizontal position of calibration point [pixel]
% % int positionY vertical position of calibration point [pixel]


disp('##################')
disp('Calibrating iViewX')
disp('##################')

% send calibration data over to the eyetracker
calllib('iViewXAPI', 'iV_SetupCalibration', pCalibrationData)

% set the screen size to what we need - only use if defined
if ~isempty(screensizeX)
    calllib('iViewXAPI', 'iV_SetResolution',int32(screensizeX), int32(screensizeY));
end

% this part does the change in calibration area
if cal_area_scale  ~= 1
    
    cx = screensizeX/2;
    cy = screensizeY/2;
    
    for i = 1:REDm_info.CalibrationData.method
        %
        calllib('iViewXAPI','iV_GetCalibrationPoint', int32(i), REDm_info.pCalibrationPointData)
        
        calpointdata = get(REDm_info.pCalibrationPointData,'Value')
        
        % do maths to shrink things about the center
        calpointdata.positionX = (calpointdata.positionX - cx) * cal_area_scale + cx;
        calpointdata.positionY = (calpointdata.positionY - cy) * cal_area_scale + cy;
        
        % rewrite to the clibration data structure
        calllib('iViewXAPI', 'iV_ChangeCalibrationPoint', int32(calpointdata.number), int32(calpointdata.positionX), int32(calpointdata.positionY));
        
    end
end

calllib('iViewXAPI', 'iV_Calibrate')

if ~isempty(mode_filename)
    calllib('iViewXAPI', 'iV_SaveCalibration', mode_filename);
end








