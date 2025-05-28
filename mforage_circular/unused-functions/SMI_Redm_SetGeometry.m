function REDm_info = SMI_Redm_SetGeometry(REDm_info)    	

pREDGeometryData = libpointer('REDGeometryStruct', REDm_info.REDGeometryData);

disp('Setting REDm System Geometry')
calllib('iViewXAPI', 'iV_SetREDGeometry', pREDGeometryData)

% int iV_SetREDGeometry  ( struct REDGeometryStruct *  redGeometry ) 

disp('Getting System Info Data')
calllib('iViewXAPI', 'iV_GetSystemInfo', REDm_info.pSystemInfoData)

% print system info data to matlab screen
get(REDm_info.pSystemInfoData, 'Value')
    