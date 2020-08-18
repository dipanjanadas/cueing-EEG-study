filename='baseCueBehTF.xlsx'; %congValid, incongValid, congInvalid, incongInvalid...
distractorCueData=xlsread(filename);

%rt data
observedData=newBaselineData(:,1:2);
observedRTDataNew(:,1) = observedData(:,1); %congruent valid
% observedRTDataNew(:,2) = observedData(:,3); %congruent invalid 
% observedRTDataNew(:,3) = observedData(:,5); %congruent negative priming
% observedRTDataNew(:,4) = observedData(:,7); %congruent neutral
observedRTDataNew(:,2) = observedData(:,2); %incongruent valid
% observedRTDataNew(:,5) = observedData(:,4); %incongruent invalid
% observedRTDataNew(:,6) = observedData(:,6); %incongruent negative priming
% % observedRTDataNew(:,8) = observedData(:,8); %incongruent neutral

% statOuput=teg_repeated_measures_ANOVA(observedRTDataNew,[2,3],{'congruence','cue_type'})
%only a main effect of congruence

%ttest valid
[H P CI stat]=ttest(observedRTDataNew(:,2), observedRTDataNew(:,1))

%% Accuracy data cleaning 

%removing AC outliers: removed all subjects with any condition <=.5
allSjPCdata=distractorCueData(:,4:5);

  find(allSjPCdata(:,:))<=.5;
  PC= allSjPCdata(:,:);
 PC1= zeros(size(PC)); 
for i=1:numel(PC)
if PC(i)<=.5
PC1(i)= PC(i);

end 
end    


%ttest valid
[H P CI stat]=ttest(allSjPCdata(:,2), allSjPCdata(:,1))
%% analysis of accuracy data

dataPC=allSjPCdata(:,:);
dataPC([2],:)=[]; % taking out outlier subjects from the step above
% dataPC([16],:)=[] %taking out outlier from the RT outlier premoval process. 

dataPC([27],:)=[];

observedACData(:,1) = dataPC(:,1); %congruent valid
observedACData(:,2) = dataPC(:,3); %congruent invalid
observedACData(:,3) = dataPC(:,5); %congruent negative priming
observedACData(:,4) = dataPC(:,7); %congruent neutral
observedACData(:,5) = dataPC(:,2); %incongruent valid
observedACData(:,6) = dataPC(:,4); %incongruent invalid
observedACData(:,7) = dataPC(:,6); %incongruent negative priming
observedACData(:,8) = dataPC(:,8); %incongruent neutral

acStandardDev=std(observedACData(:,:));
acsStandardError=acStandardDev(1,:)./sqrt(32);

%flanker
flankerValid=[observedACData(:,5)-observedACData(:,1)]; 
flankerInvalid=[observedACData(:,6)-observedACData(:,2)]; 
flankerNP=[observedACData(:,7)-observedACData(:,3)]; 
flankerNeut=[observedACData(:,8)-observedACData(:,4)]; 


%means
meanACcongValid= mean(observedACData(:,1)); %congruent valid
meanACcongInvalid=mean(observedACData(:,2));  %congruent invalid
meanACCongNP=mean(observedACData(:,3));  %congruent negative priming
meanACCongNeut=mean(observedACData(:,4));  %congruent neutral
meanACIncongValid=mean(observedACData(:,5));  %incongruent valid
meanACIncongInvalid=mean(observedACData(:,6)); %incongruent invalid
meanACIncongNP=mean(observedACData(:,7));  %incongruent negative priming
meanACIncongNeut=mean(observedACData(:,8));  %incongruent neutral

validACTrials=[observedACData(:,1); observedACData(:,5)];
invalidACTrials=[observedACData(:,2); observedACData(:,6)];
npACTrials=[observedACData(:,3); observedACData(:,7)];
neutACTrials=[observedACData(:,4); observedACData(:,8)];

meanValidACTrials=mean(validACTrials);
meanInvalidACTrials=mean(invalidACTrials);
meanNPACTrials=mean(npACTrials);
meanNeutACTrials=mean(neutACTrials);

statOutputAC=teg_repeated_measures_ANOVA(observedACData,[2,4],{'congruence','cue_type'});


%ttest valid
[H P CI stat]=ttest(observedACData(:,5), observedACData(:,1))
%h=0, p=0.1155

%ttest invalid
[H P CI]=ttest(observedACData(:,6), observedACData(:,2));
%h=0, p=0.0935

%ttest np
[H P CI stat]=ttest(observedACData(:,7), observedACData(:,3))
%h=1, p=9.5837e-04

%ttest neut
[H P CI]=ttest(observedACData(:,8), observedACData(:,4));
%h=0, p=0.3289

%valid v invalid
[H P CI]=ttest(flankerValid, flankerInvalid);
%h=0 p=.2145

%valid v np
[H P CI]=ttest(flankerValid, flankerNP);
%h=1 p=.0115


% plot the means for now after outlier removal
x=[1 2 3 4];
yCongruent=[.8509 .8424 .8385 .8359];
eCongruent=[.0147 .0157 .0171 .0189];
yIncongruent=[.8444 .8021 .7734 .8151];
eIncongruent=[.0138 .0201 .0206 .0176];
plot(x, yCongruent, 'g')
errorbar(yCongruent, eCongruent, 'g');
hold on;
plot(x, yIncongruent, 'c')
errorbar(yIncongruent, eIncongruent,'c');
hold off;
axis([0 5 .4 1]);
legend('Congruent', 'incongruent');






%% reaction time 


% data cleaning 
data=observedRTDataNew(:,:);
data([2],:)=[];
statOuput2=teg_repeated_measures_ANOVA(data,[2,3],{'congruence','cue_type'});

% removing RT outliers 
%trial 1
block=data(:,1);
outlier1=find(data(:,1) > mean(data(:,1))+2.5*std(data(:,1)));
outlier2=find(data(:,1) < (mean(data(:,1))-2.5*std(data(:,1))));
deleteRT1=block(outlier1);
deleteRT2=block(outlier2);

block=data(:,2);
outlier1=find(data(:,2) > mean(data(:,2))+2.5*std(data(:,2)));
outlier2=find(data(:,2) < (mean(data(:,2))-2.5*std(data(:,2))));
deleteRT1=block(outlier1);
deleteRT2=block(outlier2);

block=data(:,3);
outlier1=find(data(:,3) > mean(data(:,3))+2.5*std(data(:,3)));
outlier2=find(data(:,3) < (mean(data(:,3))-2.5*std(data(:,3))));
deleteRT1=block(outlier1);
deleteRT2=block(outlier2);

block=data(:,4);
outlier1=find(data(:,4) > mean(data(:,4))+2.5*std(data(:,4)));
outlier2=find(data(:,4) < (mean(data(:,4))-2.5*std(data(:,4))));
deleteRT1=block(outlier1);
deleteRT2=block(outlier2);

block=data(:,5);
outlier1=find(data(:,5) > mean(data(:,5))+2.5*std(data(:,5)));
outlier2=find(data(:,5) < (mean(data(:,5))-2.5*std(data(:,5))));
deleteRT1=block(outlier1);
deleteRT2=block(outlier2);

block=data(:,6);
outlier1=find(data(:,6) > mean(data(:,6))+2.5*std(data(:,6)));
outlier2=find(data(:,6) < (mean(data(:,6))-2.5*std(data(:,6))));
deleteRT1=block(outlier1);
deleteRT2=block(outlier2);

block=data(:,7);
outlier1=find(data(:,7) > mean(data(:,7))+2.5*std(data(:,7)));
outlier2=find(data(:,7) < (mean(data(:,7))-2.5*std(data(:,7))));
deleteRT1=block(outlier1);
deleteRT2=block(outlier2);

block=data(:,8);
outlier1=find(data(:,8) > mean(data(:,8))+2.5*std(data(:,8)));
outlier2=find(data(:,8) < (mean(data(:,8))-2.5*std(data(:,8))));
deleteRT1=block(outlier1);
deleteRT2=block(outlier2);

data([27],:)=[];
statOuput3=teg_repeated_measures_ANOVA(data,[2,4],{'congruence','cue_type'});
% no outliers. 
% 
% observedRTDataNew(:,1) = observedData(:,1); %congruent valid
% observedRTDataNew(:,2) = observedData(:,3); %congruent invalid
% observedRTDataNew(:,3) = observedData(:,5); %congruent negative priming
% observedRTDataNew(:,4) = observedData(:,7); %congruent neutral
% observedRTDataNew(:,5) = observedData(:,2); %incongruent valid
% observedRTDataNew(:,6) = observedData(:,4); %incongruent invalid
% observedRTDataNew(:,7) = observedData(:,6); %incongruent negative priming
% observedRTDataNew(:,8) = observedData(:,8); %incongruent neutral

%valid v invalid 
tempData(:,1)= data(:,1);%cong valid
tempData(:,2)= data(:,2); %cong invalid
tempData(:,3)= data(:,5);%incongruent valid
tempData(:,4)= data(:,6);%incongruent invalid

statOuput2by2=teg_repeated_measures_ANOVA(tempData,[2,2],{'congruence','cue_type'});


[H P CI]= ttest(tempData(:,3), tempData(:,4));

%valid, invalid, neg priming
tempData2(:,1)=data(:,1);%cong valid
tempData2(:,2)=data(:,2) %cong invalid
tempData2(:,3)= data(:,3);%cong neg priming
tempData2(:,4)=data(:,5);%incong valid
tempData2(:,5)=data(:,6) %incong invalid
tempData2(:,6)= data(:,7);%incong neg priming
statOuput2by3=teg_repeated_measures_ANOVA(tempData2,[2,3],{'congruence','cue_type'});

%valid v negative priming
tempData3(:,1)=data(:,1);%cong valid
tempData3(:,2)=data(:,3) %cong neg priming
tempData3(:,3)=data(:,5);%incong valid
tempData3(:,4)=data(:,7) %incong neg priming
statOuput2by2validVnegprime=teg_repeated_measures_ANOVA(tempData3,[2,2],{'congruence','cue_type'});


%valid v neutral
tempData4(:,1)=data(:,1);%cong valid
tempData4(:,2)=data(:,4) %cong neut
tempData4(:,3)=data(:,5);%incong valid
tempData4(:,4)=data(:,8) %incong neut
statOuput2by2validVneut=teg_repeated_measures_ANOVA(tempData4,[2,2],{'congruence','cue_type'});

%valid invalid and neutral

tempData5(:,1)=data(:,1)% cong valid
tempData5(:,2)=data(:,2)% cong invalid 
tempData5(:,3)=data(:,4)% cong neutral 
tempData5(:,4)=data(:,5)% incong valid
tempData5(:,5)=data(:,6)% incong invalid
tempData5(:,6)=data(:,8)% incong neut

statOuput2by3validVinvalidVneut=teg_repeated_measures_ANOVA(tempData5,[2,3],{'congruence','cue_type'});


tempData6(:,1)=data(:,2)% cong invalid
tempData6(:,2)=data(:,4)% cong neut
tempData6(:,3)=data(:,6)% incong invalid
tempData6(:,4)=data(:,8)% cong invalid

statOuput2by2validVneut=teg_repeated_measures_ANOVA(tempData6,[2,2],{'congruence','cue_type'});

tempData7(:,1)=data(:,2)% cong invalid
tempData7(:,2)=data(:,3);%cong neg priming
tempData7(:,3)=data(:,6); %incong invalid
tempData7(:,4)=data(:,7);% incong neg priming

statOuput2by2InvalidVnegPrime=teg_repeated_measures_ANOVA(tempData7,[2,2],{'congruence','cue_type'});



%data
Post(:,1)= data(:,1); %congruent valid
Post(:,2)=data(:,2);  %congruent invalid
Post(:,3)=data(:,3);  %congruent negative priming
Post(:,4)=data(:,4);  %congruent neutral
Post(:,5)=data(:,5);  %incongruent valid
Post(:,6)=data(:,6); %incongruent invalid
Post(:,7)=data(:,7);  %incongruent negative priming
Post(:,8)=data(:,8);  %incongruent neutral


%%%%%%minicon results just showing flanker effect in graphs%%%%%%%
validFlanker=Post(:,5)-Post(:,1);
invalidFlanker=Post(:,6)-Post(:,2);
negPrimeFlanker=Post(:,7)-Post(:,3);

SDvalidFlanker=std(validFlanker); SEvalidFlanker= SDvalidFlanker/sqrt(33);
SDinvalidFlanker=std(invalidFlanker);SEinvalidFlanker=SDinvalidFlanker/sqrt(33);
SDnegPrimeFlanker=std(negPrimeFlanker);SEnegPrimeFlanker=SDnegPrimeFlanker/sqrt(33);

meanVflanker=mean(validFlanker);
meanINVflanker=mean(invalidFlanker);
meanNPflanker=mean(negPrimeFlanker);

[H P CI STAT]= ttest(validFlanker, invalidFlanker);
flankerValues= [validFlanker invalidFlanker negPrimeFlanker];
statOuputFlanker=teg_repeated_measures_ANOVA(flankerValues,[3],{'cue_type'});
% statOuput4=teg_repeated_measures_ANOVA(Post,[2,3],{'congruence','cue_type'});

% means across cue conditions

validRTTrials=[Post(:,1);Post(:,5)];
invalidRTTrials=[Post(:,2);Post(:,6)];
nPRTTrials=[Post(:,3);Post(:,7)];
neutRTTrials=[Post(:,4); Post(:,8)];

meanValidRT= mean(validRTTrials);
meanInvalidRT=mean(invalidRTTrials);
meanNPRT=mean(nPRTTrials);
meanNeutRT=mean(neutRTTrials);


%means
meanCongValidPost= mean(data(:,1)); %congruent valid
meanCongInvalidPost=mean(data(:,2));  %congruent invalid
meanCongNPPost=mean(data(:,3));  %congruent negative priming
meanCongNeutPost=mean(data(:,4));  %congruent neutral
meanIncongValidPost=mean(data(:,5));  %incongruent valid
meanIncongInvalidPost=mean(data(:,6)); %incongruent invalid
meanIncongNPPost=mean(data(:,7));  %incongruent negative priming
meanIncongNeutPost=mean(data(:,8));  %incongruent neutral







postFlankerValidMean=meanIncongValidPost-meanCongValidPost;
postFlankerInvalidMean=meanIncongInvalidPost-meanCongInvalidPost;
postFlankerNPMean=meanIncongNPPost-meanCongNPPost;
postFlankerNeutMean=meanIncongNeutPost-meanCongNeutPost;

neutFlanker=Post(:,8)-Post(:,4);
meanNeutFlanker=mean(neutFlanker);
sdNeutFlanker=std(neutFlanker(:,1));
sEneutFlanker=sdNeutFlanker/sqrt(33);

postFlankerValid= data(:,5)-data(:,1);
postFlankerInvalid= data(:,6)-data(:,2);
postFlankerNP=data(:,7)-data(:,3);
postFlankerNeut=data(:,8)-data(:,4);



rtSTD=std(data(:,:));
rtSE=rtSTD(1,:)./sqrt(33);


% plot the means for now after outlier removal
x=[1 2 3 4];
yCongruent=[499.5037 503.2029 508.9185 503.3761];
eCongruent=[7.3883 8.0104 8.8674 8.3028];
yIncongruent=[536.7278 548.5520 549.6043 541.9702];
eIncongruent=[6.5442 6.4928 7.8084 7.9469];
plot(x, yCongruent, 'g')
errorbar(yCongruent, eCongruent, 'g');
hold on;
plot(x, yIncongruent, 'c')
errorbar(yIncongruent, eIncongruent,'c');
hold off;
axis([0 5 400 700]);
legend('Congruent', 'incongruent');

% plot the means for now after outlier removal
% x=[1 2 3 4];
y=[ 500.5495 537.9141; 505.4051 551.0801; 509.8706 550.7931];
% yCongruent=[499.5037 503.2029 508.9185 503.3761];
% eCongruent=[7.3883 8.0104 8.8674 8.3028];
% yIncongruent=[536.7278 548.5520 549.6043 541.9702];
% eIncongruent=[6.5442 6.4928 7.8084 7.9469];
bar(y)
% errorbar(yCongruent, eCongruent, 'g');
% hold on;
% bar(x, yIncongruent, 'c')
% errorbar(yIncongruent, eIncongruent,'c');
% hold off;
axis([0 4 400 600]);
% legend('Congruent', 'incongruent');


%ttest valid
[H P CI]=ttest(data(:,5), data(:,1));


%ttest neutral
[H P CI stat]=ttest(data(:,8), data(:,4));


%ttest np
[H P CI]=ttest(data(:,7), data(:,3));


%ttest valid v invalid 
[H P CI stat]=ttest(postFlankerValid, postFlankerInvalid)
% h=0, p=.0648

%ttest valid v negative priming 
[H P CI]=ttest(postFlankerValid, postFlankerNP);


%ttest valid v neut 
[H P CI]=ttest(postFlankerValid, postFlankerNeut);

%ttest invalid v NP
[H P CI]=ttest(postFlankerInvalid, postFlankerNeut);


[H P CI]=ttest(postFlankerNP, postFlankerNeut);


[H P CI]=ttest(postFlankerInvalid, postFlankerNP);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %means
% meanCongValid= mean(observedRTDataNew(:,1)); %congruent valid
% meanCongInvalid=mean(observedRTDataNew(:,2));  %congruent invalid
% meanCongNP=mean(observedRTDataNew(:,3));  %congruent negative priming
% meanCongNeut=mean(observedRTDataNew(:,4));  %congruent neutral
% meanIncongValid=mean(observedRTDataNew(:,5));  %incongruent valid
% meanIncongInvalid=mean(observedRTDataNew(:,6)); %incongruent invalid
% meanIncongNP=mean(observedRTDataNew(:,7));  %incongruent negative priming
% meanIncongNeut=mean(observedRTDataNew(:,8));  %incongruent neutral
% 
% 
% % plot the means for now before outlier removal
% x=[1 2 3 4];
% yCongruent=[492.3075 494.3402 499.3290 501.0764];
% % eCongruent=[.028 .032 .025 .027];
% yIncongruent=[525.6841 532.9557 531.3924 527.6787];
% % eIncongruent=[.024 .037 .027 .030];
% plot(x, yCongruent, 'g')
% % errorbar(yCongruent, eCongruent, 'g');
% hold on;
% plot(x, yIncongruent, 'c')
% % errorbar(yIncongruent, eIncongruent,'c');
% hold off;
% axis([0 5 400 700]);
% legend('Congruent', 'incongruent');
% 
% 
% %flanker
% flankerValid=observedRTDataNew(:,5)-observedRTDataNew(:,1);
% flankerInvalid=observedRTDataNew(:,6)-observedRTDataNew(:,2);
% flankerNP=observedRTDataNew(:,7)-observedRTDataNew(:,3);
% flankerNeut=observedRTDataNew(:,8)-observedRTDataNew(:,4);
% 
% 
% %ttest neutral
% [H P CI]=ttest(observedRTDataNew(:,8), observedRTDataNew(:,4));
% %h=1, p=4.9e-05
% 
% %ttest valid
% [H P CI]=ttest(observedRTDataNew(:,5), observedRTDataNew(:,1));
% %h=1, p=1.18e-06
% 
% %ttest invalid
% [H P CI]=ttest(observedRTDataNew(:,6), observedRTDataNew(:,2));
% %h=1, p=1.56e-05
% 
% %ttest NP
% [H P CI]=ttest(observedRTDataNew(:,7), observedRTDataNew(:,3));
% %h=1, p=.033
% 
% %ttest valid v neutral
% [H P CI]=ttest(flankerValid, flankerNeut);
% % h=0,p=.2074
% 
% %ttest valid v NP
% [H P CI]=ttest(flankerValid, flankerNP);
% % h=0,p=.7138
% 
% %ttest valid v invalid
% [H P CI]=ttest(flankerValid, flankerInvalid);
% % h=0,p=.0985
% 
% %ttest neutral v NP
% [H P CI]=ttest(flankerNeut, flankerNP);
% % h=0,p=.2548
% 
% %ttest invalid v neutral
% [H P CI]=ttest(flankerInvalid, flankerNeut);
% % h=0,p=.6392

% at this point theres's a sign flanker effect for all the cue types but
% there's not cue by flanker effect.

% %trial 2
% 
% block=data(:,1);
% outlier1=find(data(:,1) > mean(data(:,1))+2.5*std(data(:,1)));
% outlier2=find(data(:,1) < (mean(data(:,1))-2.5*std(data(:,1))));
% deleteRT1=block(outlier1);
% deleteRT2=block(outlier2);
% 
% block=data(:,2);
% outlier1=find(data(:,2) > mean(data(:,2))+2.5*std(data(:,2)));
% outlier2=find(data(:,2) < (mean(data(:,2))-2.5*std(data(:,2))));
% deleteRT1=block(outlier1);
% deleteRT2=block(outlier2);
% 
% block=data(:,3);
% outlier1=find(data(:,3) > mean(data(:,3))+2.5*std(data(:,3)));
% outlier2=find(data(:,3) < (mean(data(:,3))-2.5*std(data(:,3))));
% deleteRT1=block(outlier1);
% deleteRT2=block(outlier2);
% 
% block=data(:,4);
% outlier1=find(data(:,4) > mean(data(:,4))+2.5*std(data(:,4)));
% outlier2=find(data(:,4) < (mean(data(:,4))-2.5*std(data(:,4))));
% deleteRT1=block(outlier1);
% deleteRT2=block(outlier2);
% 
% block=data(:,5);
% outlier1=find(data(:,5) > mean(data(:,5))+2.5*std(data(:,5)));
% outlier2=find(data(:,5) < (mean(data(:,5))-2.5*std(data(:,5))));
% deleteRT1=block(outlier1);
% deleteRT2=block(outlier2);
% 
% block=data(:,6);
% outlier1=find(data(:,6) > mean(data(:,6))+2.5*std(data(:,6)));
% outlier2=find(data(:,6) < (mean(data(:,6))-2.5*std(data(:,6))));
% deleteRT1=block(outlier1);
% deleteRT2=block(outlier2);
% 
% block=data(:,7);
% outlier1=find(data(:,7) > mean(data(:,7))+2.5*std(data(:,7)));
% outlier2=find(data(:,7) < (mean(data(:,7))-2.5*std(data(:,7))));
% deleteRT1=block(outlier1);
% deleteRT2=block(outlier2);
% 
% block=data(:,8);
% outlier1=find(data(:,8) > mean(data(:,8))+2.5*std(data(:,8)));
% outlier2=find(data(:,8) < (mean(data(:,8))-2.5*std(data(:,8))));
% deleteRT1=block(outlier1);
% deleteRT2=block(outlier2);
% % 
% % data([],:)=[];
% % statOuput3=teg_repeated_measures_ANOVA(data,[2,4],{'congruence','cue_type'}); % after cleaning 
% % 
% % %no outliers


