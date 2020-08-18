clear 
close all


%run in parallel? 0=no, 1=yes
runInParallel=1;

% permuted or not
permute = 0;

% this is the current directory
 cd('/home/diya/Projects/distCueTF') 
%  root will print the current working directory
root = pwd;
% then we can add these extensions to the wd for each of these folders
eegdir = '/eegSetFiles';
behdir = '/beh';
iemdir =  '/iem_newEEGanalysisDist2';        %'/iem_newEEGanalysis1';
% stimlockiemdir='/iemStim_newCodes';
eegEpoched2CueDir = '/epoched2Cue_newEEGanalysisDist2';          % 'epoched2Cue_newEEGanalysis1';
% eegEpoched2StimDir = '/eegEpoched2StimNew_newCodes';
% eeg2SetDir='/eegSetFiles';


% add shit to path
addpath(genpath('/home/diya/Projects/distCueTF/analysis'))

if runInParallel
 cluster=parcluster();
 cluster.ResourceTemplate = '--ntasks-per-node=6 --mem=65536'; %well, if you send 60 jobs to the cluster, and less than 60 come back...
 job=createJob(cluster);
end

% cd to EEG raw source folder; set the current directory to the eeg folder
% if thisStep==1
cd([root eegdir])  
% end %FOR STEP 1
% if thisStep==2
%  cd([root '/' eegEpoched2StimDir]) %FOR STEP 2
% end 
% if thisStep == 1
%     d =[ dir('*.edf'); dir('*.bdf'); dir('*.set'); dir('*.mat')]
%     disp('REMEMBER EDF MF!!!!')
%     %d = dir('*.bdf');
% else
    d = dir('*.set');
% end
% set it back to the main folder directory
cd(root)

% for length of the directory with the bdf files
for iFile =1:length(d)
%     this line below sets thisFname to each file 
    thisFname = d(iFile).name;
    if runInParallel
    createTask(job, @newEEGanalysis,0,{thisFname,root,permute});
    else
    
%     run this program for each file
    newEEGanalysis(thisFname,root,permute)
    end 
end

if runInParallel
submit(job)
end 


