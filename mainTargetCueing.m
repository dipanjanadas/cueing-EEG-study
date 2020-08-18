
clear all;
clc;

sjNum=input('participant number:  ');
age=input('age of participant:    ');
gender=input('gender (M=0/F=1):   ');
eyetracker=input('eyetracker (yes=1;0=no):   ');
eeg=input('eeg (yes=1; no=0):    ');
practice=input('practice (yes=1; no=0):    ');
% sjNum=99;
% eyetracker=1;
% practice=0;
% dispWinNUM=1;
%eeg=0;


%open labjack
pause(1);
lj = labJack('verbose',true);
lj.setDIO([0,0,0]) %zero ports



%% setting up a struct to save experiment information
trialLog=struct(...
    'experiment','',...
    'subNum',{},...
    'age',{},...
    'gender',{},...
    'date','',...
    'eeg',' ',...
'trialInfo', struct(...
    'trial',{},...
    'block',{},...
    'cue',{},...
    'distractor',{},...
    'target',{},...
    'congruent',{},...
    'trialType',{},...
    'brokenTrial',{},...
    'TOrient',{},...
    'DOrient',{},...
    'fixDur',{},...
    'respDur',{},...
    'postCueDur',{},...
    'response',{},...
    'accuracy',{},...
    'rt',{}));

trialLog(1).subNum=sjNum;
trialLog(1).date=datestr(now);
trialLog(1).experiment='mainTargetCueingExp';
trialLog(1).age=age;
trialLog(1).gender=gender;
trialLog(1).eyetracker=eyetracker;
trialLog(1).eeg=eeg;
trialLog(1).practice=practice;

%% Clean up
HideCursor(0);
FlushEvents;
ListenChar(2);


%% setting up the trial matrix

%before adding congruent and incongruent trials, there are 960 valid
%trials, 120 invalid other trials, 120 invalid target trials

%480 valid trials
nSearchLocs=6;
nRepsV=16;

% making valid trials

trialCount=1;

for t=1:nSearchLocs
    
    for d=1:nSearchLocs
        for rep=1:nRepsV
            
            if t~=d
                cue(trialCount)=t;
                targ(trialCount)=t;
                dist(trialCount)=d;
                trialType(trialCount)=200;
                trialCount=trialCount+1;
            end
        end
    end
end
%code=[cue;dist;targ];


totCount=trialCount;
trialCount=totCount;

%% for invalid trials
nRepsI=1;
nSearchLocs=6; 
if mod(sjNum,2)>0 %odd number participants
    
    for c=1:nSearchLocs
        for t=1:nSearchLocs
            for d=1:nSearchLocs
                for rep= 1:nRepsI
                    if (c~=t) & (t~=d) & (c~=d) & (t<d)
                        cue(trialCount)=c;
                        targ(trialCount)=t;
                        dist(trialCount)=d;
                        trialType(trialCount)=201;
                        trialCount=trialCount+1;
                    end
                end
            end
        end
    end
%     codeOdd=[cue;dist;targ]';
else
    
    for c=1:nSearchLocs
        for t=1:nSearchLocs
            for d=1:nSearchLocs
                for rep= 1:nRepsI
                    if (c~=t) & (t~=d) & (c~=d) & (t>d)
                        cue(trialCount)=c;
                        targ(trialCount)=t;
                        dist(trialCount)=d;
                        trialType(trialCount)=201;
                        trialCount=trialCount+1;
                    end
                end
            end
        end
    end
end

totCount=trialCount;
trialCount=totCount;

%negative priming trials
% trialCount=1;
nSearchLocs=6;
nRepsNP=2;
for t=1:nSearchLocs
    
    for d=1:nSearchLocs
        for rep=1:nRepsNP
            
            if t~=d
                cue(trialCount)=t;
                targ(trialCount)=d;
                dist(trialCount)=t;
                trialType(trialCount)=202;
                trialCount=trialCount+1;
            end
        end
    end
end
code=[cue;targ; dist]';

totCount=trialCount;
trialCount=totCount;

trialMatrix=[num2cell(cue); num2cell(dist); num2cell(targ); num2cell(trialType)]';

totCount=600;
trialCount=1;
nRepCong=2;
orientL=60;
orientR=120;
%left=60
%right=120

%target and distractor have either congruent or incongruent orientations

for i=1:nRepCong
    for j=1:totCount
        if mod(j,2)>0
            tOrient(trialCount)= orientL; %  both target and distractor in odd numbered trials are 45 degrees
            dOrient(trialCount)= orientL;
        else
            tOrient(trialCount)= orientR; %  both target and distractor in even numbered trials are 90 degrees.
            dOrient(trialCount)= orientR;
        end
        
        if i==2
            targ(totCount+j)=targ(j);   % for the second part of the loop, add 528 more targets, distractors and cues.
            dist(totCount+j)=dist(j);
            cue(totCount+j)=cue(j);
            trialType(totCount+j)=trialType(j);
            
            if mod(j,2)>0
                dOrient(trialCount)= orientR; % for the second half of trials, odd distractor trials are 90 degrees
            else
                dOrient(trialCount)= orientL; % for the second half of trials, even distractors are 45 degrees
            end
        end
        cong(trialCount)=i;
        trialCount=trialCount+1;
    end
    
end

%changing the cong and incong to 10 and 20 for triggers down the line.
countCong=1;
countFin=1;
congMatrix=zeros(1,1200);
for countCong=1:size(cong,2)
    if cong(countCong)==1
        congMatrix(countFin)=10;
    elseif cong(countCong)==2
        congMatrix(countFin)=20;
    end
    countCong=countCong+1;
    countFin=countFin+1;
    
end

totCount=trialCount;
trialCount=totCount;

nSearchLocs=6;
nRepsCue=20;


% no cue trials
for c=1:nSearchLocs
    for rep=1:nRepsCue
        cue(trialCount)=c;
        dist(trialCount)=99;
        targ(trialCount)=99;
        congMatrix(trialCount)=99;
        tOrient(trialCount)=99;
        dOrient(trialCount)=99;
        trialType(trialCount)=203;
        trialCount=trialCount+1;
    end
end

trialMatrixCheck=[cue;targ;dist;congMatrix;tOrient;dOrient;trialType]';


%% creating the stimuli


Screen('Preference', 'SkipSyncTests', 0)
%  Screen('Preference', 'SkipSyncTests', 1);

keyboardIndices=-1;% what does this do?
fixtol=100;

% Seed the random number generator. Here we use the an older way to be
% compatible with older systems. Newer syntax would be rng('shuffle'). Look
% at the help function of rand "help rand" for more information
rand('seed', sum(100 * clock));

nScreens=1;
dual=1;
%open window (always presentation screen) and window2 (exp screen if n=2)
if nScreens==1
    [window, wRect] = Screen('OpenWindow',1,[127.5, 127.5, 127.5]);
elseif nScreens==2
    [window, wRect] = Screen('OpenWindow',1,[127.5, 127.5, 127.5]);
    [window2,wRect2] = Screen('OpenWindow',0,[127.5, 127.5, 127.5]);
end



%base window setup
dispWinNum = max(Screen('Screens')); %use the max screen
white = WhiteIndex(dispWinNum);
black = BlackIndex(dispWinNum);
%gray = (white+black)/2;

%
gray=[130 130 130];
darkGray=[128 128 128];
green2=[0 255 0];
inc = white-gray;
fontSize = 32;
messageFontSize = 18;

%%TOM SCRIPT
% Open Screen and define center;
% [window, wRect] = Screen('OpenWindow',dispWinNum,gray,[],[],2);

dispRect = Screen('Rect',dispWinNum);
xCenter = dispRect(3)/2;
yCenter = dispRect(4)/2;

%check to ensure correct frame rate (60Hz)
frmRate = Screen('GetFlipInterval',window);
if 1/frmRate  > 61  ||  1/frmRate < 59
    disp(frmRate);
    Screen('Closeall');
    disp(frmRate);
    error('CHECK FRAMERATE');
    return;
end

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% set up some gaze contingent stuff
% fixcoords=[xCenter yCenter];
[winw,winh]=Screen('WindowSize',window);
bfixw=Screen('TextBounds', window, 'BROKEN FIXATION');

%define some stim sizes
% fixDims = [xCenter-6 yCenter-6 xCenter+6 yCenter+6];
fixDims = [xCenter-8 yCenter-8 xCenter+8 yCenter+8];

% stimSize = 10;

dotColor=[0 0 0];
% dotSizePix=15; %changed from 20
dotSizePix=60;




%% Gabor stuff
% %%%%%%Target Gabor%%%%%%%%%%

%Dimension of the region where will draw the Gabor in pixels
gaborDimPixT = dispRect(4) / 2;
% %
% Sigma of Gaussian
% sigmaT = gaborDimPixT / 10;
sigmaT = gaborDimPixT / 8;

contrastT =1.0;
aspectRatioT = 1;  %width v height
phaseT = 0;
% %
% Spatial Frequency (Cycles Per Pixel)
% One Cycle = Grey-Black-Grey-White-Grey i.e. One Black and One White Lobe
numCyclesT = 11;
freqT = numCyclesT / gaborDimPixT;

% Build a procedural gabor texture (Note: to get a "standard" Gabor patch
% we set a grey background offset, disable normalisation, and set a
% pre-contrast multiplier of 0.5.
% For full details see:
% https://groups.yahoo.com/neo/groups/psychtoolbox/conversations/topics/9174
backgroundOffsetT = [0.51 0.51 0.51 0.7];
disableNormT = 1;
preContrastMultiplierT = 1;
gabortexTarg = CreateProceduralGabor(window, gaborDimPixT, gaborDimPixT, [],...
    backgroundOffsetT, disableNormT, preContrastMultiplierT);
% Randomise the phase of the Gabors and make a properties matrix.
propertiesMatT = [phaseT, freqT, sigmaT, contrastT, aspectRatioT, 0, 0, 0];

%%%%%Distractor Gabor%%%%%%%%%%%
gaborDimPixD = dispRect(4) / 2;

% Sigma of Gaussian
% sigmaD = gaborDimPixD / 10;
sigmaD = gaborDimPixD / 8;

% Obvious Parameters
% orientationD = 0;
contrastD = 1.0;
aspectRatioD = 1.0;
phaseD = 0;
numCyclesD = 5;
freqD = numCyclesD / gaborDimPixD;
backgroundOffsetD = [0.51 0.51 0.51 0.7];
disableNormD = 1;
preContrastMultiplierD = 1;

gabortexDist = CreateProceduralGabor(window, gaborDimPixD, gaborDimPixD, [],...
    backgroundOffsetD, disableNormD, preContrastMultiplierD);
% Randomise the phase of the Gabors and make a properties matrix.
propertiesMatD = [phaseD, freqD, sigmaD, contrastD, aspectRatioD, 0, 0, 0];
%% Locations for different things

%gabors
radCon = .0174532925;

[stimLocX1TD, stimLocY1TD] = pol2cart(330*radCon, 150);%loc 1 315
[stimLocX2TD, stimLocY2TD] = pol2cart(270*radCon, 150); %loc 2 270
[stimLocX3TD, stimLocY3TD] = pol2cart(210*radCon, 150);%loc 3 225
[stimLocX4TD, stimLocY4TD] = pol2cart(150*radCon, 150);%loc 4 135
[stimLocX5TD, stimLocY5TD] = pol2cart(90*radCon, 150);%loc 5 90
[stimLocX6TD, stimLocY6TD] = pol2cart(30*radCon, 150);%loc6 45

%changed from 190 on 11_17_16
stimSize=50;

locMatrix=[xCenter-stimSize/1+stimLocX1TD  yCenter-stimSize+stimLocY1TD xCenter+stimSize/1+stimLocX1TD yCenter+stimSize/1+stimLocY1TD;...
    xCenter-stimSize/1+stimLocX2TD  yCenter-stimSize+stimLocY2TD xCenter+stimSize/1+stimLocX2TD yCenter+stimSize/1+stimLocY2TD;...
    xCenter-stimSize/1+stimLocX3TD  yCenter-stimSize+stimLocY3TD xCenter+stimSize/1+stimLocX3TD yCenter+stimSize/1+stimLocY3TD;...
    xCenter-stimSize/1+stimLocX4TD  yCenter-stimSize+stimLocY4TD xCenter+stimSize/1+stimLocX4TD yCenter+stimSize/1+stimLocY4TD;...
    xCenter-stimSize/1+stimLocX5TD  yCenter-stimSize+stimLocY5TD xCenter+stimSize/1+stimLocX5TD yCenter+stimSize/1+stimLocY5TD;...
    xCenter-stimSize/1+stimLocX6TD  yCenter-stimSize+stimLocY6TD xCenter+stimSize/1+stimLocX6TD yCenter+stimSize/1+stimLocY6TD];

stimSizePlacehold=70;
locMatrixPlacehold=[xCenter-stimSizePlacehold/1+stimLocX1TD  yCenter-stimSizePlacehold+stimLocY1TD xCenter+stimSizePlacehold/1+stimLocX1TD yCenter+stimSizePlacehold/1+stimLocY1TD;...
    xCenter-stimSizePlacehold/1+stimLocX2TD  yCenter-stimSizePlacehold+stimLocY2TD xCenter+stimSizePlacehold/1+stimLocX2TD yCenter+stimSizePlacehold/1+stimLocY2TD;...
    xCenter-stimSizePlacehold/1+stimLocX3TD  yCenter-stimSizePlacehold+stimLocY3TD xCenter+stimSizePlacehold/1+stimLocX3TD yCenter+stimSizePlacehold/1+stimLocY3TD;...
    xCenter-stimSizePlacehold/1+stimLocX4TD  yCenter-stimSizePlacehold+stimLocY4TD xCenter+stimSizePlacehold/1+stimLocX4TD yCenter+stimSizePlacehold/1+stimLocY4TD;...
    xCenter-stimSizePlacehold/1+stimLocX5TD  yCenter-stimSizePlacehold+stimLocY5TD xCenter+stimSizePlacehold/1+stimLocX5TD yCenter+stimSizePlacehold/1+stimLocY5TD;...
    xCenter-stimSizePlacehold/1+stimLocX6TD  yCenter-stimSizePlacehold+stimLocY6TD xCenter+stimSizePlacehold/1+stimLocX6TD yCenter+stimSizePlacehold/1+stimLocY6TD];

% locMatrixPlaceholdColor=[233 0 199 17 22 122; 0 0 40 103 128 122;0 0 154 241 109 0];

%% Eye tracking stuff

if eyetracker == 1
    EyelinkInit([], 1);
    edfFile = [num2str(sjNum) '_' 'tc' '.edf']; % Name of eyetracking data file - has to be in the working directory unfortunately
    el=EyelinkInitDefaults(window);
    [~, vs]=Eyelink('GetTrackerVersion');
    fprintf('Running experiment on a ''%s'' tracker.\n', vs );
    % Open file to record data to
    if(length(edfFile) > 12)
        sca
        error('EDF file name must conform to DOS 8.3 naming standard!')
    end
    i = Eyelink('Openfile', edfFile);
    if i~=0
        printf('Cannot create EDF file ''%s'' ', edfFile);
        Eyelink( 'Shutdown');
        return;
    end
    Eyelink('command', 'add_file_preamble_text ''Recorded by EyelinkToolbox for Visual Search Experiment''');
    % Setting the proper recording resolution, proper calibration type,
    % as well as the data file content
    Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, dispRect(3)-1, dispRect(4)-1);
    Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, dispRect(3)-1, dispRect(4)-1);
    % Set calibration type
    Eyelink('command', 'calibration_type = HV9');
    % Set EDF file contents
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
    Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS');
    % Set link data (used for gaze cursor)
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
    Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS');
    % Set eye to be tracked
    Eyelink('command', 'active_eye = RIGHT') % NORMALLY RIGHT
    % Make sure we're still connected
    if Eyelink('IsConnected')~=1
        return;
    end;
    % Setup the proper calibration foreground and background colors
    el.backgroundcolour = 127;
    el.foregroundcolour = 0;
    % Hide the mouse cursor
    Screen('HideCursorHelper', window);
    if dual == 1
        [window2,wRect2] = Screen('OpenWindow',0,[127.5, 127.5, 127.5]);
        [normBoundsRect]=Screen('TextBounds',window2,'Calibrate eye tracker');
        Screen('DrawText',window2,'Calibrate eye tracker',xCenter-round(normBoundsRect(3)/2),yCenter,white, black);
        Screen('Flip',window2);
    end
    EyelinkDoTrackerSetup(el); %%EYETRACKER RUN CALIBRATION
end

%% starting the experimental loop


trialMatrix=[cue;targ;dist;congMatrix;tOrient;dOrient;trialType];
trialMatrixRand = trialMatrix(:, randperm(size(trialMatrix,2)))';
valsPerLoop = 88;
startLoop = 1;
totMatrices = 15;


for i = 1:totMatrices
    endLoop = startLoop + valsPerLoop - 1;
    trialMatrixAll(:,:,i) = trialMatrixRand(startLoop:endLoop,:)';
    startLoop = startLoop + valsPerLoop;
end

%start eyetracker recording for this block
Eyelink('Command', 'set_idle_mode');
WaitSecs(0.05);
Eyelink('StartRecording', 1, 1, 1, 1);
WaitSecs(0.1); %wait to avoid sample loss

%flush keyboard presses
FlushEvents('KeyDown');


nBlocks=15;   %15 
thisBlock=1;



while thisBlock<=nBlocks % keeping track of trial numbers while adding broken trials
    for m= 1:nBlocks
        thisTrialMatrix=trialMatrixAll(:,:, thisBlock)';
    end
    
    if thisBlock==1
        trialCounter=0;
        nTrials=length(thisTrialMatrix);
    else
        trialCounter=(trialCounter+nTrials);
        nTrials=length(thisTrialMatrix);
    end
    
%     % block message
%     thisMessage = sprintf('This is Block %d of %d',thisBlock, nBlocks);
%     Screen('TextSize',window,18);
%     Screen('TextStyle',window,0);
%     [textBounds, textOffset] = Screen('TextBounds',window,thisMessage);
%     Screen('DrawText',window,thisMessage,xCenter-textBounds(3)/2,yCenter+200,white);
%     [normBoundsRect]=Screen('TextBounds',window,'Please press space bar to begin...');
%     Screen('DrawText',window,'Please press the space bar again',xCenter-round(normBoundsRect(3)/2),yCenter+150, white,gray);
%     Screen('DrawingFinished',window,0);
%     Screen('Flip',window);

 % block message
    thisMessage = sprintf('This is Block %d of %d',thisBlock, nBlocks);
    thisMessage2= sprintf('Please actively use the cue to attend the target location');
    thisMessage3=sprintf('Respond as quickly and as accurately as possible');
    Screen('TextSize',window,24);
    Screen('TextStyle',window,0);
    [textBounds, textOffset] = Screen('TextBounds',window,thisMessage);
    [textBounds, textOffset] = Screen('TextBounds',window,thisMessage2);
    [textBounds, textOffset] = Screen('TextBounds',window,thisMessage3);
    Screen('DrawText',window,thisMessage,xCenter-100,yCenter+200,white);
    Screen('DrawText',window,thisMessage2,xCenter-round(textBounds(3)/2),yCenter,white);
    Screen('DrawText',window,thisMessage3,xCenter-round(textBounds(3)/2),yCenter+50,white);
    [normBoundsRect]=Screen('TextBounds',window,'Please press space bar to begin...');
    Screen('DrawText',window,'Please press the space bar again',xCenter-round(normBoundsRect(3)/2),yCenter+150, white,gray);
    Screen('DrawingFinished',window,0);
    Screen('Flip',window);




    
    
    %press space to start block
    FlushEvents('keyDown');
    keepchecking = 1;
    while keepchecking == 1;
        [keyIsDown, secs, keyCode] = KbCheck(keyboardIndices);
        if keyIsDown
            if find(keyCode ~= 0) == KbName('SPACE')
                keepchecking = 0;
                go = ' ';
            end
        end
    end
    
    %send trigger to mark start of block
    sendTrigger(lj,thisBlock,eyetracker,eeg) %send trigger
    
%     trialInfo=[]; %reset trialinfo for each block
    brokenTrial=0;
   
    %Start of Trial Loop
    i = 1;
    while i<=nTrials     %for future ref, don't do: 'while i<= 1:nTrials'. it won't work!
        
        %Write a message to the experimenter's screen updating which trial
        %and block participants are completing
        if dual == 1
            trialMessage = sprintf('This is trial %d of %d ',i,nTrials);
            [normBoundsRect]=Screen('TextBounds',window2,trialMessage);
            Screen('DrawText',window2,trialMessage,xCenter-round(normBoundsRect(3)/2),yCenter,white, black);
            blockMessage = sprintf('This is block %d of %d ',thisBlock,nBlocks);
            [normBoundsRect]=Screen('TextBounds',window2,blockMessage);
            Screen('DrawText',window2,blockMessage,xCenter-round(normBoundsRect(3)/2),yCenter+normBoundsRect(4)*2,white, black);
            Screen('Flip',window2);
        end
        
        trialLog.trialInfo(i+trialCounter).trial=i+trialCounter;
        trialLog.trialInfo(i+trialCounter).block=thisBlock;
        
        %this part tells the program what each column in trialMatrixRand is
        thisCue=thisTrialMatrix(i,1);
        thisTarg=thisTrialMatrix(i,2);
        thisDist=thisTrialMatrix(i,3);
        thisCong=thisTrialMatrix(i,4);
        thisTOrient=thisTrialMatrix(i,5);
        thisDOrient=thisTrialMatrix(i,6);
        thisTrialType=thisTrialMatrix(i,7);
        
        % Define correct response
        if thisTOrient == orientL
            cResp = 1;
        elseif thisTOrient == orientR
            cResp = 2;
        end
        
        
        %clear all the eyelink logging info (PREALLOCATE BEFORE EACH ROUTINE)
        fixET.elSampleTime = [];
        fixET.paTrial = [];
        fixET.xyDrift = [];
        fixET.distXY = [];
        fixET.driftTotal = [];
        
        cueET.elSampleTime = [];
        cuexET.paTrial = [];
        cueET.xyDrift = [];
        cueET.distXY = [];
        cueET.driftTotal = [];
        
        postCueET.elSampleTime = [];
        postCuexET.paTrial = [];
        postCueET.xyDrift = [];
        postCueET.distXY = [];
        postCueET.driftTotal = [];
        
        stimET.elSampleTime = [];
        stimET.paTrial = [];
        stimET.xyDrift = [];
        stimET.distXY = [];
        stimET.driftTotal = [];
        
        
        %some start of trial stuff
        brokenTrial=0; %important - if this ever equals 1 then the trial is broken
        stimTrigger=-1; %default to -1 (appears as -1 in the logfile on broken trials)
        subResponse=0;
        % define fixation coordinates for eyetracker
        fixcoords=[xCenter yCenter];
        
        %send message to eyetracker display indicating trial/nTrials
        Eyelink('command', 'record_status_message "BLOCK_%02d TRIAL %02d of %02d"',thisBlock, i, nTrials );
        
        %% pre fixation screen not gaze contingent
        % OPEN FIXATION circle is presented here to make the presentation
        %of trials seem continuous. This part is not gaze contingent.
        %Subjects have to align their eye with the fixation and then start
        %the trial
        
        %pre-fixation screen (sj get ready and align eyes)
        sendTrigger(lj,101,eyetracker,eeg) %send trigger
        
        %press space to start block
        FlushEvents('keyDown');
        keepchecking = 1;
        while keepchecking == 1;
            
            %if gaze position, show green dot to sj
            evt=Eyelink('NewestFloatSample');   % get sample
            x=evt.gx(2);    % x-position
            y=evt.gy(2);    % y-position
            
            
            
            if x>50 && y>50
                Screen('TextSize',window,50);
                Screen('DrawText', window, 'o', x, y,green2);
            end
            
            %             Screen('FillRect', window, gray );
            Screen('FrameOval',window,[black],fixDims,[3]);%draw fixation oval
            Screen('Flip',window);
            %WaitSecs(.8);
            %if keypress, then start trial
            [keyIsDown, secs, keyCode] = KbCheck(keyboardIndices);
            if keyIsDown
                if find(keyCode ~= 0) == KbName('SPACE')
                    keepchecking = 0;
                    go = ' ';
                end
            end
        end
        
        
        
        %% fixation window- gaze contingent starts
        %fixation screen (gaze contingent!)
        fixVblInit = 0; %timing (prevent crash)
        fixVbl = 0; %timing (prevent crash)
        thisCheck  = 1; %counter for eyelink logging
        thisPerm = randperm(7) + 29; %29
        nFixFrames=thisPerm(1); % gives a frames value between 1:6 (500-600 ms jittered)
        sendTrigger(lj,102,eyetracker,eeg) %send trigger
        for fixFrames = 1:nFixFrames
            
            evt=Eyelink('NewestFloatSample');   % get sample
            x=evt.gx(2);    % x-position
            y=evt.gy(2);    % y-position
            diff=sqrt((fixcoords(1)-x)^2+(fixcoords(2)-y)^2);   % calculates difference between eye position and fixation coords
            
            if diff > fixtol % if diff is greater than fixation tolerance
                
                % log everytthing from last available sample
                evtype=Eyelink('GetNextDataType');  % is the sample a standard float, or an event (e.g. saccade blink etc)
                
                %log the eye data to a matlab structue **PREALLOCATE**?
                if Eyelink('NewFloatSampleAvailable') > 0
                    evt=Eyelink('NewestFloatSample');   % get sample
                    fixET.elSampleTime(thisCheck,:) = evt.time;  % gets sample times
                    fixET.paTrial(thisCheck,:)=evt.pa; % gets pupil areas
                    fixET.xyDrift(thisCheck,:)=[evt.gx(2) evt.gy(2)];
                    fixET.distXY(thisCheck,:)=[xCenter-evt.gx(2) yCenter-evt.gy(2)];
                    fixET.driftTotal(thisCheck,:)=diff;
                end
                
                %mark trial as broken and send trigger and eyelink message to screen
                sendTrigger(lj,95,eyetracker,eeg)
                Eyelink('command', 'record_status_message "DRIFT BREAK!!!"');
                brokenTrial=1;
                
                
                % display broken fix message on screen for sub
                Screen('DrawText',window,'BROKEN FIXATION',winw/2-bfixw(3)/2,winh/2-bfixw(4)/2, [0 0 0]);
                Screen('Flip',window);
                WaitSecs(.5);
                
                %break out of trial
                break
                
            else %if fixated correctly
                
                %present fixation
                %Screen('FillRect', window, gray ) %is this needeD?
                Screen('FillOval',window,[black],fixDims);%draw fixation oval
                %Screen('FrameOval', windowPtr [,color] [,rect] [,penWidth] [,penHeight] [,penMode]);
                Screen('FrameOval', window, [0 0 0],[locMatrixPlacehold'], [],[],[]);
                Screen('DrawLine',window, [0 0 0], xCenter+10,yCenter-10, xCenter+50,yCenter-50, 4);%loc 6(45 deg)
                Screen('DrawLine',window, [0 0 0], xCenter,yCenter-10, xCenter,yCenter-60, 4);%location5 (90 degree)
                Screen('DrawLine',window, [0 0 0], xCenter-10,yCenter-10, xCenter-50,yCenter-50, 4);%location4 (135degree)
                Screen('DrawLine',window, [0 0 0], xCenter-10,yCenter+10, xCenter-50,yCenter+50, 4);%location 3(225 deg)
                Screen('DrawLine',window, [0 0 0], xCenter,yCenter+10, xCenter,yCenter+60, 4); %location 2 (270 deg)
                Screen('DrawLine',window, [0 0 0], xCenter+10,yCenter+10, xCenter+50,yCenter+50, 4);%locaiton 1(315 deg)
                
                if fixFrames==1
                    fixVblInit = Screen('Flip',window);
                else
                    fixVbl = Screen('Flip',window);
                end
                
                %log the eye data to a matlab structue **PREALLOCATE**?
                if Eyelink('NewFloatSampleAvailable') > 0
                    evt=Eyelink('NewestFloatSample');   % get sample
                    fixET.elSampleTime(thisCheck,:) = evt.time;  % gets sample times
                    fixET.paTrial(thisCheck,:)=evt.pa; % gets pupil areas
                    fixET.xyDrift(thisCheck,:)=[evt.gx(2) evt.gy(2)];
                    fixET.distXY(thisCheck,:)=[xCenter-evt.gx(2) yCenter-evt.gy(2)];
                    fixET.driftTotal(thisCheck,:)=diff;
                end
                
            end
            
            thisCheck = thisCheck+1; %counter for eyelink logging
        end
        
        %get fixation timing
        if brokenTrial==0
            fixDur = fixVbl - fixVblInit;
        end
        
        
        
        %% cue window
     red=[233 0 0];
        green=[122 122 0];
        teal=[22 128 109];
        brown=[146 111 16];
        brickRed=[186 93 16];
        blue=[17 103 241];
        darkGreen=[63 129 45];
        brown2=[140 111 78];
        
        
        if mod(sjNum,2)>0 %odd numbered subjects blue is the target cue
            if thisCue==1
                color1=[blue];color2=[brown2]; color3=[teal];color4=[brown];color5=[green]; color6=[darkGreen];
            elseif thisCue==2
                color1=[brown2];color2=[blue]; color3=[teal];color4=[brown];color5=[green]; color6=[darkGreen];
            elseif thisCue==3
                color1=[teal];color2=[brown2]; color3=[blue];color4=[brown];color5=[green]; color6=[darkGreen];
            elseif thisCue==4
                color1=[brown];color2=[brown2]; color3=[teal];color4=[blue];color5=[green]; color6=[darkGreen];
            elseif thisCue==5
                color1=[green];color2=[brown2]; color3=[teal];color4=[brown];color5=[blue]; color6=[darkGreen];
            elseif thisCue==6
                color1=[darkGreen];color2=[brown2]; color3=[teal];color4=[brown];color5=[green]; color6=[blue];
            end 
            
        else%even numbered subjects red is the target cue
          if thisCue==1
                color1=[red];color2=[brown2]; color3=[teal];color4=[brown];color5=[green]; color6=[darkGreen];
            elseif thisCue==2
                color1=[brown2];color2=[red]; color3=[teal];color4=[brown];color5=[green]; color6=[darkGreen];
            elseif thisCue==3
                color1=[teal];color2=[brown2]; color3=[red];color4=[brown];color5=[green]; color6=[darkGreen];
            elseif thisCue==4
                color1=[brown];color2=[brown2]; color3=[teal];color4=[red];color5=[green]; color6=[darkGreen];
            elseif thisCue==5
                color1=[green];color2=[brown2]; color3=[teal];color4=[brown];color5=[red]; color6=[darkGreen];
            elseif thisCue==6
                color1=[darkGreen];color2=[brown2]; color3=[teal];color4=[brown];color5=[green]; color6=[red];
            end    
        end
        

        cueVbl = 0;
        thisCheck=1;
        cueTrigger = thisCue+50;
        if brokenTrial==0 %skip this if already broken
            
            
            sendTrigger(lj,cueTrigger,eyetracker,eeg) %send trigger
            for cueFrames = 1:30 %500ms
                
                evt=Eyelink('NewestFloatSample');   % get sample
                x=evt.gx(2);    % x-position
                y=evt.gy(2);    % y-position
                diff=sqrt((fixcoords(1)-x)^2+(fixcoords(2)-y)^2);   % calculates difference between eye position and fixation coords
                
                if diff > fixtol || evt.pa(2)==0 % if diff is greater than fixation tolerance ADDED PA MEASURE????????????????
                    
                    
                    %log the eye data to a matlab structue **PREALLOCATE**?
                    if Eyelink('NewFloatSampleAvailable') > 0
                        evt=Eyelink('NewestFloatSample');   % get sample
                        cueET.elSampleTime(thisCheck,:) = evt.time;  % gets sample times
                        cueET.paTrial(thisCheck,:)=evt.pa; % gets pupil areas
                        cueET.xyDrift(thisCheck,:)=[evt.gx(2) evt.gy(2)];
                        cueET.distXY(thisCheck,:)=[xCenter-evt.gx(2) yCenter-evt.gy(2)];
                        cueET.driftTotal(thisCheck,:)=diff;
                    end
                    
                    %mark trial as broken and send trigger and eyelink message to screen
                    sendTrigger(lj,95,eyetracker,eeg)
                    Eyelink('command', 'record_status_message "DRIFT BREAK!!!"');
                    brokenTrial=1;
                    
                    % display broken fix message on screen for sub
                    Screen('DrawText',window,'BROKEN FIXATION',winw/2-bfixw(3)/2,winh/2-bfixw(4)/2, [0 0 0]);
                    Screen('Flip',window);
                    WaitSecs(.5);
                    
                    %break out of trial
                    break
                    
                else %if fixated correctly
                    
                    % CUE PRESENTATION
                    Screen('FillOval',window,[black],fixDims);%draw fixation oval
                    Screen('FrameOval', window, [0 0 0],[locMatrixPlacehold'], [],[],[]);
                    Screen('DrawLine',window, [color1], xCenter+10,yCenter-10, xCenter+50,yCenter-50, 4);%loc 6 (45 deg)
                    Screen('DrawLine',window, [color2], xCenter,yCenter-10, xCenter,yCenter-60, 4);%location 5 (90 degree)
                    Screen('DrawLine',window, [color3], xCenter-10,yCenter-10, xCenter-50,yCenter-50, 4);%location 4 (135degree)
                    Screen('DrawLine',window, [color4], xCenter-10,yCenter+10, xCenter-50,yCenter+50, 4);%location 3(225 deg)
                    Screen('DrawLine',window, [color5], xCenter,yCenter+10, xCenter,yCenter+60, 4); %location2 (270 deg)
                    Screen('DrawLine',window, [color6], xCenter+10,yCenter+10, xCenter+50,yCenter+50, 4);%locaiton 1(315 deg)
                    cueVbl=Screen('Flip', window);
                    
                    %log the eye data to a matlab structue **PREALLOCATE**?
                    if Eyelink('NewFloatSampleAvailable') > 0
                        evt=Eyelink('NewestFloatSample');   % get sample
                        cueET.elSampleTime(thisCheck,:) = evt.time;  % gets sample times
                        cueET.paTrial(thisCheck,:)=evt.pa; % gets pupil areas
                        cueET.xyDrift(thisCheck,:)=[evt.gx(2) evt.gy(2)];
                        cueET.distXY(thisCheck,:)=[xCenter-evt.gx(2) yCenter-evt.gy(2)];
                        cueET.driftTotal(thisCheck,:)=diff;
                    end
                    
                end
                
                
                thisCheck = thisCheck+1; %counter for eyelink logging
                
            end
        end
        
        %get target timing
        if brokenTrial==0
            cueDur = cueVbl - fixVbl;
        end
        
        %% post cue window
        postCueVbl = 0;
        thisCheck=1;
        
        if brokenTrial==0 %skip this if already broken
            
            sendTrigger(lj,103,eyetracker,eeg) %send trigger
            for postCueFrames = 1:15 %250 ms
                
                evt=Eyelink('NewestFloatSample');   % get sample
                x=evt.gx(2);    % x-position
                y=evt.gy(2);    % y-position
                diff=sqrt((fixcoords(1)-x)^2+(fixcoords(2)-y)^2);   % calculates difference between eye position and fixation coords
                
                if diff > fixtol || evt.pa(2)==0 % if diff is greater than fixation tolerance ADDED PA MEASURE????????????????
                    
                    
                    %log the eye data to a matlab structue **PREALLOCATE**?
                    if Eyelink('NewFloatSampleAvailable') > 0
                        evt=Eyelink('NewestFloatSample');   % get sample
                        postCueET.elSampleTime(thisCheck,:) = evt.time;  % gets sample times
                        postCueET.paTrial(thisCheck,:)=evt.pa; % gets pupil areas
                        postCueET.xyDrift(thisCheck,:)=[evt.gx(2) evt.gy(2)];
                        postCueET.distXY(thisCheck,:)=[xCenter-evt.gx(2) yCenter-evt.gy(2)];
                        postCueET.driftTotal(thisCheck,:)=diff;
                    end
                    
                    %mark trial as broken and send trigger and eyelink message to screen
                    sendTrigger(lj,95,eyetracker,eeg)
                    Eyelink('command', 'record_status_message "DRIFT BREAK!!!"');
                    brokenTrial=1;
                    
                    % display broken fix message on screen for sub
                    Screen('DrawText',window,'BROKEN FIXATION',winw/2-bfixw(3)/2,winh/2-bfixw(4)/2, [0 0 0]);
                    Screen('Flip',window);
                    WaitSecs(.5);
                    
                    %break out of trial
                    break
                    
                else %if fixated correctly
                    
                    %POSTCUE PRESENTATION
                    Screen('FillRect', window, gray )
                    Screen('FillOval',window,[black],fixDims);%draw fixation oval
                    Screen('FrameOval', window, [0 0 0],[locMatrixPlacehold]', [],[],[]);
                    Screen('DrawLine',window, [0 0 0], xCenter+10,yCenter-10, xCenter+50,yCenter-50, 4);%loc 6 (45 deg)
                    Screen('DrawLine',window, [0 0 0], xCenter,yCenter-10, xCenter,yCenter-60, 4);%location 5 (90 degree)
                    Screen('DrawLine',window, [0 0 0], xCenter-10,yCenter-10, xCenter-50,yCenter-50, 4);%location 4 (135degree)
                    Screen('DrawLine',window, [0 0 0], xCenter-10,yCenter+10, xCenter-50,yCenter+50, 4);%location 3(225 deg)
                    Screen('DrawLine',window, [0 0 0], xCenter,yCenter+10, xCenter,yCenter+60, 4); %location 2 (270 deg)
                    Screen('DrawLine',window, [0 0 0], xCenter+10,yCenter+10, xCenter+50,yCenter+50, 4);%locaiton 1(315 deg)
                    postCueVbl=Screen('Flip', window);
                    
                    %log the eye data to a matlab structue **PREALLOCATE**?
                    if Eyelink('NewFloatSampleAvailable') > 0
                        evt=Eyelink('NewestFloatSample');   % get sample
                        targET.elSampleTime(thisCheck,:) = evt.time;  % gets sample times
                        targET.paTrial(thisCheck,:)=evt.pa; % gets pupil areas
                        targET.xyDrift(thisCheck,:)=[evt.gx(2) evt.gy(2)];
                        targET.distXY(thisCheck,:)=[xCenter-evt.gx(2) yCenter-evt.gy(2)];
                        targET.driftTotal(thisCheck,:)=diff;
                    end
                    
                end
                
                
                thisCheck = thisCheck+1; %counter for eyelink logging
                
            end
        end
        
        %get postCue timing
        if brokenTrial==0
            postCueDur = postCueVbl - fixVbl;
        end
        
        %% stim presentation window
        subResponse=1;
        ind=0;
        resp=0;
        reactionTime=0;
        acc=0;
        stimVbl = 0;
        thisCheck=1;
        stimTrigger = thisTrialType+thisCong;
        if brokenTrial==0
            sendTrigger(lj, stimTrigger,eyetracker,eeg) %send trigger
            for stimFrames=1:15 %400ms=24 %21=350ms, 18=300ms. 15=250ms
                evt=Eyelink('NewestFloatSample');   % get sample
                x=evt.gx(2);    % x-position
                y=evt.gy(2);    % y-position
                diff=sqrt((fixcoords(1)-x)^2+(fixcoords(2)-y)^2);   % calculates difference between eye position and fixation coords
                
                if diff > fixtol || evt.pa(2)==0 % if diff is greater than fixation tolerance ADDED PA MEASURE????????????????
                    
                    
                    %log the eye data to a matlab structue **PREALLOCATE**?
                    if Eyelink('NewFloatSampleAvailable') > 0
                        evt=Eyelink('NewestFloatSample');   % get sample
                        stimET.elSampleTime(thisCheck,:) = evt.time;  % gets sample times
                        stimET.paTrial(thisCheck,:)=evt.pa; % gets pupil areas
                        stimET.xyDrift(thisCheck,:)=[evt.gx(2) evt.gy(2)];
                        stimET.distXY(thisCheck,:)=[xCenter-evt.gx(2) yCenter-evt.gy(2)];
                        stimET.driftTotal(thisCheck,:)=diff;
                    end
                    
                    %mark trial as broken and send trigger and eyelink message to screen
                    sendTrigger(lj,95,eyetracker,eeg)
                    Eyelink('command', 'record_status_message "DRIFT BREAK!!!"');
                    brokenTrial=1;
                    
                    % display broken fix message on screen for sub
                    Screen('DrawText',window,'BROKEN FIXATION',winw/2-bfixw(3)/2,winh/2-bfixw(4)/2, [0 0 0]);
                    Screen('Flip',window);
                    WaitSecs(.5);
                    
                    %break out of trial
                    break
                    
                else
                    %%present stimulus
                    Screen('FillOval',window,[black],fixDims);%draw fixation oval
                    %Screen('FillOval',window,[black],fixDims);%draw fixation oval
                    Screen('FrameOval', window, [0 0 0],[locMatrixPlacehold'], [],[],[]);
                    Screen('DrawLine',window, [0 0 0], xCenter+10,yCenter-10, xCenter+50,yCenter-50, 4);%loc 6 (45 deg)
                    Screen('DrawLine',window, [0 0 0], xCenter,yCenter-10, xCenter,yCenter-60, 4);%location 5 (90 degree)
                    Screen('DrawLine',window, [0 0 0], xCenter-10,yCenter-10, xCenter-50,yCenter-50, 4);%location 4 (135degree)
                    Screen('DrawLine',window, [0 0 0], xCenter-10,yCenter+10, xCenter-50,yCenter+50, 4);%location 3(225 deg)
                    Screen('DrawLine',window, [0 0 0], xCenter,yCenter+10, xCenter,yCenter+60, 4); %location 2 (270 deg)
                    Screen('DrawLine',window, [0 0 0], xCenter+10,yCenter+10, xCenter+50,yCenter+50, 4);%locaiton 1(315 deg)
                    if thisTrialType~=203
                        Screen('DrawTextures', window, gabortexTarg, [], [locMatrix(thisTarg,:)], thisTOrient, [], [], [], [],...
                            kPsychDontDoRotation, propertiesMatT');
                        Screen('DrawTextures', window, gabortexDist, [], [locMatrix(thisDist,:)], thisDOrient, [], [], [], [],...
                            kPsychDontDoRotation, propertiesMatD');
                    end
                    stimVbl = Screen('Flip', window);
                     if stimFrames == 1
                        stimVblInit = stimVbl;
                    end
                    
                    %log the eye data to a matlab structue **PREALLOCATE**?
                    if Eyelink('NewFloatSampleAvailable') > 0
                        evt=Eyelink('NewestFloatSample');   % get sample
                        stimET.elSampleTime(thisCheck,:) = evt.time;  % gets sample times
                        stimET.paTrial(thisCheck,:)=evt.pa; % gets pupil areas
                        stimET.xyDrift(thisCheck,:)=[evt.gx(2) evt.gy(2)];
                        stimET.distXY(thisCheck,:)=[xCenter-evt.gx(2) yCenter-evt.gy(2)];
                        stimET.driftTotal(thisCheck,:)=diff;
                    end
                    %                 end % original end for diff>tol
                    %
                    %                 thisCheck = thisCheck+1; %counter for eyelink loggin
                    %
                    
                   if thisTrialType~=203 
                    FlushEvents('keyDown');
                    if subResponse == 1;%prev if statement
                        [keyIsDown, secs, keyCode, delta] = KbCheck(keyboardIndices);
                        if c == 0;
                            c = 1;
                            delta =0;
                        end;
                        ind=0; % default no response
                        reactionTime=-1;
                        resp=-1;
                        acc=-1;
                        if keyIsDown
                            ind = find(keyCode ~=0);
                            if ind == KbName('j')
                                resp=1;
                                sendTrigger(lj, 150,eyetracker,eeg) %send trigger
                                reactionTime = (secs - stimVblInit)*1000;
                                subResponse =0;
                            end
                            if ind == KbName('k')
                                resp=2;
                               sendTrigger(lj,165,eyetracker,eeg) %send trigger
                                reactionTime = (secs - stimVblInit)*1000;
                                subResponse =0;
                            end
                            % Calculate accuracy
                            if resp==cResp;
                                acc = 1;
                            else acc = 0;
                            end
                        else
                            keyIsDown = 0;
                            subResponse=1;
                        end
                    end
                   end %if thistrialtype not 203
                    
                end  %new end for diff>tol
                
                thisCheck=thisCheck+1; %new
                
            end %stim frame loop

        end %brokentrial=0 loop
        
        
        %get target timing
        if brokenTrial==0
            stimDur = stimVbl - fixVbl;
        end
    
        %% added window to get response
        
        thisCheck=1;
        respVbl=0;
        endOnset=0;
        if brokenTrial==0
            
            Screen('FillRect', window, gray );
            Screen('FillOval',window,[black],fixDims);%draw fixation oval
            endOnset=Screen('Flip',window);
            if thisTrialType==203
                evt=Eyelink('NewestFloatSample');   % get sample
                x=evt.gx(2);    % x-position
                y=evt.gy(2);    % y-position
                diff=sqrt((fixcoords(1)-x)^2+(fixcoords(2)-y)^2);
                
                %log the eye data to a matlab structue **PREALLOCATE**?
                if Eyelink('NewFloatSampleAvailable') > 0
                    evt=Eyelink('NewestFloatSample');   % get sample
                    stimET.elSampleTime(thisCheck,:) = evt.time;  % gets sample times
                    stimET.paTrial(thisCheck,:)=evt.pa; % gets pupil areas
                    stimET.xyDrift(thisCheck,:)=[evt.gx(2) evt.gy(2)];
                    stimET.distXY(thisCheck,:)=[xCenter-evt.gx(2) yCenter-evt.gy(2)];
                    stimET.driftTotal(thisCheck,:)=diff;
                end
                thisCheck=thisCheck+1;
                WaitSecs(.5);
            end
            
            if thisTrialType~=203
                while subResponse==1
      
                    [keyIsDown, secs, keyCode, delta] = KbCheck(keyboardIndices);
                    if c == 0;
                        c = 1;
                        delta =0;
                    end;
                    if keyIsDown
                        ind = find(keyCode ~=0);
                        if ind == KbName('j')
                            resp=1;
                           sendTrigger(lj, 150,eyetracker,eeg) %send trigger
                            reactionTime = (secs - stimVblInit)*1000;
                            subResponse =0;
                            %                     break;
                        end
                        if ind == KbName('k')
                            resp=2;
                            sendTrigger(lj, 165,eyetracker,eeg) %send trigger
                            reactionTime = (secs - stimVblInit)*1000;
                            subResponse =0;
                            %                     break;
                        end
                        % Calculate accuracy
                        if resp==cResp;
                            acc = 1;
                        else acc = 0;
                        end
                    else
                        keyIsDown = 0;
                    end
             
                    evt=Eyelink('NewestFloatSample');   % get sample
                    x=evt.gx(2);    % x-position
                    y=evt.gy(2);    % y-position
                    diff=sqrt((fixcoords(1)-x)^2+(fixcoords(2)-y)^2);
                    
                    %log the eye data to a matlab structue **PREALLOCATE**?
                    if Eyelink('NewFloatSampleAvailable') > 0
                        evt=Eyelink('NewestFloatSample');   % get sample
                        stimET.elSampleTime(thisCheck,:) = evt.time;  % gets sample times
                        stimET.paTrial(thisCheck,:)=evt.pa; % gets pupil areas
                        stimET.xyDrift(thisCheck,:)=[evt.gx(2) evt.gy(2)];
                        stimET.distXY(thisCheck,:)=[xCenter-evt.gx(2) yCenter-evt.gy(2)];
                        stimET.driftTotal(thisCheck,:)=diff;
                    end
                    thisCheck=thisCheck+1;
                end %END OF WHILE LOOP
                
                if practice==1
                    if acc==1
                        Screen('FillRect', window, gray )
                        [normBoundsRect]=Screen('TextBounds',window,'CORRECT!');
                        width = normBoundsRect(3);
                        height = normBoundsRect(4);
                        Screen('DrawText',window,'CORRECT!',xCenter-(width/2),yCenter-(height/2),[0 255 0]);
                        Screen('Flip',window);
                        WaitSecs(.5);
                    else
                        Screen('FillRect', window, gray )
                        [normBoundsRect]=Screen('TextBounds',window,'INCORRECT!');
                        width = normBoundsRect(3);
                        height = normBoundsRect(4);
                        Screen('DrawText',window,'INCORRECT!',xCenter-(width/2),yCenter-(height/2),[255 0 0]);
                        Screen('Flip',window);
                        WaitSecs(.5);
                    end
                end 
                
                
                
                
            end %if thisTrialtYPE NOT 203
            
            respVbl= Screen('Flip', window);
        end
        
        if brokenTrial==0
            respDur=respVbl-endOnset;
        end
        
        
        %adding trials that were broken to the end of the block
        if brokenTrial==1
            nTrials = nTrials+1; %increasing the number of trials by 1
            thisTrialMatrix = [thisTrialMatrix; 0 0 0 0 0 0 0]; %adding a row to the trialMatrix
            thisTrialMatrix(nTrials,:) = thisTrialMatrix(i,:);% updating the trial that was broken to the updated nTrial
            fixDur=-1;
            cueDur=-1;
            postCueDur=-1;
            stimDur=-1
            respDur=-1;
        end
        
        RestrictKeysForKbCheck([]);
        
        %saving all trial information
        
        trialLog.trialInfo(i+trialCounter).response=resp;
        trialLog.trialInfo(i+trialCounter).accuracy=acc;
        trialLog.trialInfo(i+trialCounter).rt=reactionTime;
        trialLog.trialInfo(i+trialCounter).cue=thisCue;
        trialLog.trialInfo(i+trialCounter).distractor=thisDist;
        trialLog.trialInfo(i+trialCounter).target=thisTarg;
        trialLog.trialInfo(i+trialCounter).congruent=thisCong;
        trialLog.trialInfo(i+trialCounter).trialType=thisTrialType;
        trialLog.trialInfo(i+trialCounter).TOrient=thisTOrient;
        trialLog.trialInfo(i+trialCounter).DOrient=thisDOrient;
        trialLog.trialInfo(i+trialCounter).brokenTrial=brokenTrial;
        trialLog.trialInfo(i+trialCounter).fixDur=fixDur;
        trialLog.trialInfo(i+trialCounter).postCueDur=postCueDur;
        trialLog.trialInfo(i+trialCounter).cueDur=cueDur;
        trialLog.trialInfo(i+trialCounter).stimDur=stimDur;
        trialLog.trialInfo(i+trialCounter).respDur=respDur;
        trialLog.trialInfo(i+trialCounter).fixEye=fixET;
        trialLog.trialInfo(i+trialCounter).cueEye=cueET;
        trialLog.trialInfo(i+trialCounter).postCueEye=postCueET;
        trialLog.trialInfo(i+trialCounter).stimEye=stimET;
        
        %finish drawing
        Screen('DrawingFinished', window, [],0);
        
        i=i+1;
        
        
    end %end of trial loop
    
    save(sprintf('sj%02d_targCueTF', sjNum),'trialLog');
    
    thisBlock=thisBlock+1;
    
end    %end of block loop
%% End eye tracking and save data
%close down the eyetracker and transfer the file
if(eyetracker)
    if nScreens==2
        Screen('TextSize',window2,32);
        [normBoundsRect]=Screen('TextBounds',window2,'TRANSFERING EYE DATA.');
        Screen('DrawText',window2,'TRANSFERING EYE DATA.',xCenter-round(normBoundsRect(3)/2),yCenter,[255 255 255]);
        Screen('Flip', window2);
    end
    
    Eyelink('Stoprecording')
    
    % Eyelink('Command', 'set_idle_mode');
    WaitSecs(0.5);
    Eyelink('CloseFile');
    
    % download data file
    try
        fprintf('Receiving data file ''%s''\n', edfFile );
        status=Eyelink('ReceiveFile');
        if status > 0
            fprintf('ReceiveFile status %d\n', status);
        end
        if 2==exist(edfFile, 'file')
            fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
        end
    catch
        fprintf('Problem receiving data file ''%s''\n', edfFile );
    end
    
    %close the eye tracker.
    Eyelink('ShutDown');
    
end
%eyetracker shutdown finished

%close screen
sca

%close labjack
lj.close

%release keyboard
ListenChar(0);


return

%Command to send stuff to EYELINK Screen
%Eyelink('command', 'record_status_message "TEST2"');

%
% %%% SUBFUNCTIONS %%%
%
% %send labjack triggers and eyetracker messages
% function sendTrigger(lj,stim)
% lj.setDIO([0,stim,0]) % set FIO EIO and CIO channel 0 and 3 high
% pause(.005);
% lj.setDIO([0,0,0]) % set FIO EIO and CIO channel 0 and 3 high
% Eyelink('Message', ['TRIGGER ' sprintf('%d',stim)]); %sent stim to ET
% return
























