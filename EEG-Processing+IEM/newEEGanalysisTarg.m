function newEEGanalysisTarg(fName,root,permute)
cd /home/diya/Projects/distCueTF/eeglab14_1_1b
eeglab
close all
cd(root)


% 
% fName='sj01_targCueTF.set';
% eegdir = '/eegSetFiles2';
% behdir = '/beh';
% root=pwd;

eegdir = '/eegSetFiles2';
eegEpoched2CueDir = '/epoched2Cue_newEEGanalysisTarg2';
% eegEpoched2StimDir = 'eegEpoched2StimNew';
% eegEpochedFiltDir= 'eegEpochedFilt';
% eegEpoched2Dir='/eegEpoched2';
behdir = '/beh';
iemdir = '/iem_newEEGanalysisTarg2';
% stimlockiemdir='/iemStim_newCodes';

 if strcmp(fName(6:9),'targ')
%load in .set files
EEG = pop_loadset([pwd eegdir '/' fName]);
 end 

EEG=pop_chanedit(EEG, 'lookup','/home/diya/Projects/distCueTF/eeglab14_1_1b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp'); % edit channel locations

% re referencing 
EEG=pop_reref(EEG,[65, 66]);

% Resample data
EEG = pop_resample(EEG,256);

%filter data
EEG = pop_eegfiltnew(EEG, .1, 30);
 
% Epoch around onset of fixation
EEG = pop_epoch( EEG, {'102'}, [-0.2  2], 'newname', 'BDF file epochs', 'epochinfo', 'yes'); % MAYBE CHANGE TO 101???///?? % changed from [-1 3]
% Reject broken fixation trials based off data from task
fName2 = [root behdir '/' fName(1:end-4) '.mat'];
data = load(fName2);
trialLog = data.trialLog;

brokenFix = [trialLog.trialInfo.brokenTrial]';

if strcmp(fName(3:9),'11_targ')
    brokenFix = [trialLog.trialInfo([12:1501]).brokenTrial]';
elseif strcmp(fName(3:9),'15_targ')
    EEG = pop_select(EEG,'notrial',1:17)
elseif strcmp(fName(3:9),'20_targ')
    EEG = pop_select(EEG,'notrial',1:111)
elseif strcmp(fName(3:9),'15_targ')
    EEG = pop_select(EEG,'notrial',1:17)
elseif strcmp(fName(3:9),'27_targ')
    brokenFix = [trialLog.trialInfo([12:1379]).brokenTrial]';
end

% remove broken fixations and add trialLog to EEG struct
EEG.trialLogNew = trialLog.trialInfo(find(brokenFix==0));

%save a beh triallog in the workspace outside of eeg struct
trialLogNew = EEG.trialLogNew;

% check EEG.epoch and beh for consistent no. of trials
if length(EEG.epoch) == length(brokenFix)
    disp('DATA ARE CONSISTENT MF! YAY!!!')
else
    disp('DATA ARE NOT CONSISTENT! CHECK YO SHIT MF!!')
    return
end

%%correct for baseline
EEG = pop_rmbase( EEG, [-200  0]); 


%reject trials with broken fixations 
EEG = pop_rejepoch(EEG, brokenFix, 0);


% get indices for valid trials
cnt=0;
for iTrial=1:length(trialLogNew)
    if trialLogNew(iTrial).accuracy==1
    
    if trialLogNew(iTrial).cue == trialLogNew(iTrial).target
       
        cnt=cnt+1;
        
        validVec(cnt) = iTrial;
        
    end
    end 
    
end

EEG = pop_select(EEG,'trial',validVec);

EEG= pop_epoch(EEG, {'51' '52' '53' '54' '55' '56'}, [-0.2  1.12], 'newname', 'BDF file epochs', 'epochinfo', 'yes');

%%correct for baseline
EEG = pop_rmbase( EEG, [-200  0]); 

validVec=validVec';
trialLog_valid=trialLogNew([validVec]);

save([root eegEpoched2CueDir '/' fName(1:end-4) '.mat'],'EEG')

% epoch to specific time segment

%EEG_test = pop_select(EEG_valid,'time',[1.25,1.5])  %are the time points right?
                                                    
%500-600ms for fix, 500 ms cue , 250 post cue and 250 ms stim presentation

%% IEM stuf 
% EEGorg=EEG;
% clear EEG;

% EEG=EEG_valid_test;

% Filter the data and hilbert transform
[z1,p1] = butter(3, [7.5, 13.5]./(EEG.srate/2),'bandpass');
%     fEEG = pop_eegfiltnew(EEG,7.5,13.5);   %change this to a butterworth filter


data=double(EEG.data);
fEEG = NaN(size(data,1),size(data,2),size(data,3));
for x = 1:size(data,1)
    for y = 1:size(data,3)
        dataFilt1 = filtfilt(z1,p1,data(x,:,y));
        fEEG(x,:,y) = dataFilt1;
    end
end

fEEGS.data=single(fEEG);

hilbertEEG = [];
for chan = 1:64
    for t = 1:size(fEEGS.data,3)
        hilbertEEG(chan,:,t) = hilbert(squeeze(fEEGS.data(chan,:,t))')';
    end
end
% fEEGS.data(1:64,:,:) = hilbertEEG; %didn't run this part when IEM worked 
% hilbertEEG = fEEGS.data;


% Basis Set
tbasis = [sind(0:30:150)].^7;
for i = 1:6
    call(i,:) = circshift(tbasis',i-4);
end

% get location labels
cnt=0;
for iTrial=1:length(trialLogNew)
    if trialLogNew(iTrial).accuracy==1
        if trialLogNew(iTrial).cue == trialLogNew(iTrial).target
            
            cnt=cnt+1;
            
            locVec(cnt) = trialLogNew(iTrial).target;
            
        end
    end
end

locVec=locVec';
% Create C1
C1= [];
for i = 1:size(locVec,1)
    C1(i,:) = call(locVec(i,:),:);
end

% Leave-one-out cross validation definition
tpart = cvpartition(locVec(:,1),'Leaveout');
    
% Time point loop
for i = 1:size(hilbertEEG,2) %52:size(hilbertEEG,2) 
    % Define EEG (observed data)
    B = squeeze(hilbertEEG(1:64,i,:));
    % Cross validation
    for w = 1:tpart.NumTestSets
        tWeights = C1(tpart.training(w),:)\B(:,tpart.training(w))'; %estimate channel weights
        C2(w,:) = (tWeights'\B(:,tpart.test(w)))'; %invert model to estimate C2
    end
    % Center C2
    for w = 1:tpart.NumTestSets
        centerind = find(C1(tpart.test(w),:)==1);
        if centerind == 4
            centeredC1(w,:) = C1(tpart.test(w),:);
            centeredC2(w,:) = C2(w,:);
        else
            centeredC1(w,:) = circshift(C1(tpart.test(w),:)',4-centerind)';
            centeredC2(w,:) = circshift(C2(w,:)',4-centerind)';
        end
    end
    allC2(:,i,:) = centeredC2;
    allC1(:,i,:) = centeredC1;
end
 fName = [pwd iemdir '/' fName(1:length(fName-4)) '_iem' '.mat'];
    

 save(fName,'allC2','allC1','trialLog_valid','-v7.3'); 



% end 
end 
