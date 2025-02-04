function SMI_Redm_StopRecordingSaveData(fullfilename,user,description,ovr)
% fullfilename -> dir+filename of where to save data to
% user -> experimeter name
% description -> some description for the file
% ovr -> overwrite any pre-existing data file(1) or not(0)

if nargin <4
    ovr = int32(1);
    % 0: do not overwrite file filename if it already exists 1: overwrite file filename if it
    % already exists
end
if nargin < 3
    description = 'Description1'; % optional experiment description
end
if nargin < 2
    user = 'User1'; % optional name of test person
end
if nargin < 1
    fullfilename = '';  % filename (incl. path) of data files being created 
                        % (.idf: eyetracking data, .avi: scene video data)
end

% clean up the filename format
if ~isempty(fullfilename)
    [a,b,c] = fileparts(fullfilename);
    if isempty(a)
        a = [cd filesep];
    else
        a = [a filesep];
    end
    if isempty(c) || ~strcmpi(c,'.idf')
        c = [c '.idf']
    end
    fullfilename = [a b c];
end

% stop recording
calllib('iViewXAPI', 'iV_StopRecording');

% Write data to the HDD if a filename is given
if ~isempty(fullfilename) 
    calllib('iViewXAPI', 'iV_SaveData', fullfilename, description, user, ovr)
end