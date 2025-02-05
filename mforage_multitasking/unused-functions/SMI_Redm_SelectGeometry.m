function REDm_info = SMI_Redm_SelectGeometry(REDm_info, profilename)    	


disp(['Loading REDm System Geometry ' profilename])
%   int iV_SelectREDGeometry ( char * profileName )
calllib('iViewXAPI', 'iV_SelectREDGeometry', profilename);




disp('Getting System Info Data')
calllib('iViewXAPI', 'iV_GetSystemInfo', REDm_info.pSystemInfoData)

% print system info data to matlab screen
get(REDm_info.pSystemInfoData, 'Value')
    
