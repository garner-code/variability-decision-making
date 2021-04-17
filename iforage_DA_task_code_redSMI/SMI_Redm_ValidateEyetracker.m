function [REDm_info, accdata] = SMI_Redm_ValidateEyetracker(REDm_info)

accdata = [];

disp('Validate Calibration')
% begins the validation process
calllib('iViewXAPI', 'iV_Validate')

disp('Showing Mean Validation Accuracy')

% Before accuracy data is accessible the accuracy needs to be validated
% with iV_Validate. If the parameter visualization is set to 1 the accuracy data 
% will be visualized in a dialog window.
calllib('iViewXAPI', 'iV_GetAccuracy', REDm_info.pAccuracyData, int32(1))

% read and return accuracy data
accdata = get(REDm_info.pAccuracyData,'Value');

