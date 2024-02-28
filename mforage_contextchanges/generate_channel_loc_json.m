function [] = generate_channel_loc_json(head_circ, sub, sub_dir)
% written by K. Garner, 2019
% this code generates the subject specific channel location meta data file
% for each participant in json format
% uses the polar to cartesian transform from the freely available
% 'Cap_coords_all_Biosemi.xls'
% input:
% head_circ = head circumference in mm
% output:
% json file 'eeg/sub-xx-task-yy-coordsystem.json

addpath('JSONio');
% generate the electrode location file 
root_dir = sub_dir;
eeg_fol = 'eeg';
name = sprintf('sub-%d-task-iforage-v1_channel-coordsystem', sub);
elec_json_name = fullfile(root_dir,eeg_fol,...
                 [name '.json']);

radius = head_circ/0.6283185;
% Assign the fields in the Matlab structure that can be saved as a json:
elec_json.sub = sub;
elec_json.ChannelName = ['Fp1 AF7 AF3 F1 F3 F5 F7 FT7 FC5 FC3 FC1 C1 C3 C5 T7(T3) TP7 CP5 CP3 CP1 P1 P3 P5 P7 P9 PO7 PO3 O1 Iz Oz POz Pz CPz Fpz Fp2 AF8 AF4 Afz Fz F2 F4 F6 F8 FT8 FC6 FC4 FC2 FCz Cz C2 C4 C6 T8 TP8 CP6 CP4 CP2 P2 P4 P6 P8 P10 PO8 PO4 O2'];
elec_json.Inclination = [-92	-92	-74	-50	-60	-75	-92	-92	-72	-50	-32	-23	-46	-69	-92	-92	-72	-50	-32	-50	-60	-75	-92	-115	-92	-74	-92	115	92	69	46	23	92	92	92	74	69	46	50	60	75	92	92	72	50	32	23	0	23	46	69	92	92	72	50	32	50	60	75	92	115	92	74	92];
elec_json.Azimuth = [ -72	-54	-65	-68	-51	-41	-36	-18	-21	-28	-45	0	0	0	0	18	21	28	45	68	51	41	36	36	54	65	72	-90	-90	-90	-90	-90	90	72	54	65	90	90	68	51	41	36	18	21	28	45	90	0	0	0	0	0	-18	-21	-28	-45	-68	-51	-41	-36	-36	-54	-65	-72];
elec_json.x = -radius*sin(degtorad(elec_json.Inclination)).*sin(degtorad(elec_json.Azimuth));
elec_json.y = radius*sin(degtorad(elec_json.Inclination)).*cos(degtorad(elec_json.Azimuth));
elec_json.z = radius*cos(degtorad(elec_json.Inclination));

json_options.indent = '    '; % this makes the json look pretier when opened in a txt editor
%    jsonwrite(elec_json_name,anat_json,json_options)
jsonwrite(elec_json_name,elec_json,json_options)