function [] = generate_task_metadata(raw_data_folder)
% written by K. Garner, 2019
% generate 1st level metadata file for the iforage-v1 experiment
% input - raw data folder within which to place top level metadata (i.e.
% all folders inherit the property)
% output - json file with the following info:

addpath('JSONio');
root_dir = raw_data_folder;
name = 'task-iforage-v1-studyinfo';
meta_json_name = fullfile(root_dir,...
                 [name '.json']);

study_meta.Authors = 'Garner, K & Garrido, M';
study_meta.BIDSvers = 1.1;
study_meta.task = 'iforage_task_code_redSMI-v1';

% hardware dependencies
study_meta.matlab_version = 'Matlab 2012a 32 bit';
study_meta.psychtoolbox = 'Psychtoolbox 3.0.14 - Flavor: beta';
study_meta.pc = '';
study_meta.pc_processor = '';
study_meta.monitor = 'TSUS NVIDIA monitor';
study_meta.monitor_dim = '530 mm x 300 mm';
study_meta.monitor_res = '';
study_meta.distance_from_monitor = '570 mm';

% eeg system
study_meta.eeg_system = '';
study_meta.amplifier = '';
study_meta.hardware_filter = '';
study_meta.cap = '64 electrodes';
study_meta.placement_scheme = '';
study_meta.sample_rate = '';

% eyetracking
study_meta.eyetracker_model = 'red SMI';
study_meta.eyetracker_vertical_distance = '-2 mm'; % vertical distance that redM sensor is to the viewable screen
study_meta.eyetracker_horizontal_distance = '60 mm'; % horizontal distance that redM sensor is to the viewable screen
study_meta.eyetracker_screen_deg = 20; % angle of inclination that the redM sensor is to the viewable screen surface
study_meta.calibration_adjust = 0.9; % proportion of full screen used for calibration/validation area
study_meta.validation_accuracy = 1; % maximum degrees of error for validation to be considered ok

json_options.indent = '    '; % this makes the json look pretier when opened in a txt editor
%    jsonwrite(elec_json_name,anat_json,json_options)
jsonwrite(meta_json_name, study_meta, json_options)




