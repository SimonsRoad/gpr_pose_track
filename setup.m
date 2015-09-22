clc;clear all;close all;
% Download the GPML toolbox - for the latest URL check the page
% http://www.gaussianprocess.org/gpml/code/matlab/doc/
unzip('http://gaussianprocess.org/gpml/code/matlab/release/gpml-matlab-v3.6-2015-07-07.zip','gpml_tmp');

% Getting the current directory
me = mfilename;                                            % what is my filename
mydir = which(me); 
curr_dir = mydir(1:end-2-numel(me));        % where am I located
% Cut the contents of the extracted folder and move them to gpml folder for
% version consistency
files = dir(fullfile(curr_dir,'gpml_tmp'));
% Create destination folder
if ~exist(fullfile(curr_dir,'gpml'),'dir')
    fullfile(curr_dir,'gpml');
end
if (size(files,1) == 3)
    % Move all the GPML contents one folder up
    movefile(fullfile(curr_dir,'gpml_tmp',[files(3).name filesep]),fullfile(curr_dir,'gpml/'));
    % Remove the original directory
    rmdir(fullfile(curr_dir,'gpml_tmp'));
else
    disp('Could not download GPML toolbox, please download it manually');
    return;
end

% Add path of src and utils
addpath([curr_dir,'src']);
addpath([curr_dir,'utils']);
clear me files mydir
% Run the startup file of GPML
run(fullfile(curr_dir,'gpml','startup.m'))