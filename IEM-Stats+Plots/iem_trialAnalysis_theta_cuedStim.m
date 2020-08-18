clear all
%% written by Dipanjana Das
% this script analyzes IEM data for theta band cued stimulus (validly cued
% trials for each condition). I use this basic script by adapting it for
% different analyses.



%% distractor cue data
% load iem data from each sj, and put them into different bins
% grandAllC2_dist=sjx time points x channels
%grandAllC2_dist_cue/postcue/stim= sjxchannels (easy to plot)
 
sublist=[1 2 3 4 5 6 7 8 9 10 11 12 14 15 17 18 20 22 23 24 27 32 34];  

for iSub=1:length(sublist)
    sjNum=sublist(iSub);
    load(sprintf('sj%02d_distCueTF.set_iem.mat', sjNum));
    
    avgAllC2_dist=squeeze(mean(allC2, 1));
    
    
    grandAllC2_dist(iSub, :, :)=avgAllC2_dist;
    
    grandAllC2_dist_cue(iSub,:) = squeeze(abs(mean(mean(allC2(:,52:180,:),2))).^2);
    grandAllC2_dist_postcue(iSub,:) = squeeze(abs(mean(mean(allC2(:,181:244,:),2))).^2);
    grandAllC2_dist_stim(iSub,:) = squeeze(abs(mean(mean(allC2(:,245:321,:),2))).^2);
    
end 

%leaving this here for easy plotting TFs and surf plots

% meanC2_dist=mean(grandAllC2_dist);
% meanC2_dist=squeeze(mean(grandAllC2_dist));
meanC2_dist=squeeze(mean(squeeze(mean(grandAllC2_dist))));
meanC2pwr_dist=abs(meanC2_dist).^2;
plot(meanC2pwr_dist)

meanC2=squeeze(mean(grandAllC2_dist));
meanC2=abs(meanC2).^2;
surf(meanC2)

plot(mean(grandAllC2_dist_cue)')
hold on;
plot(mean(grandAllC2_dist_postcue)')
hold on;
plot(mean(grandAllC2_dist_stim)')

%% target cue data
% load iem data from each sj, and put them into different bins
% grandAllC2_targ=sjx time points x channels
%grandAllC2_targ_cue/postcue/stim= sjxchannels (easy to plot)


sublist=[1 2 3 4 5 6 7 8 9 10 11 12 14 15 17 18 20 22 23 24 27 32 34];  %11 and 27 need to add 
for iSub=1:length(sublist)
    sjNum=sublist(iSub);
    load(sprintf('sj%02d_targCueTF.set_iem.mat', sjNum));
   
    avgAllC2_targ=squeeze(mean(allC2, 1));
   
    grandAllC2_targ(iSub, :, :)=avgAllC2_targ;
    
    grandAllC2_targ_cue(iSub,:) = squeeze(abs(mean(mean(allC2(:,52:180,:),2))).^2);
    grandAllC2_targ_postcue(iSub,:) = squeeze(abs(mean(mean(allC2(:,181:244,:),2))).^2);
    grandAllC2_targ_stim(iSub,:) = squeeze(abs(mean(mean(allC2(:,245:321,:),2))).^2);


end 
%  leaving this here for easy plotting
% meanC2_targ=mean(grandAllC2_targ);
% meanC2_targ=squeeze(mean(grandAllC2_targ));
meanC2_targ=squeeze(mean(squeeze(mean(grandAllC2_targ))));
meanC2pwr_targ=abs(meanC2_targ).^2;
plot(meanC2pwr_targ)
hold on;
plot(meanC2pwr_dist)
hold off;

%suf plot 
meanC2=mean(grandAllC2_targ);
meanC2=squeeze(mean(grandAllC2_targ));
meanC2=abs(meanC2).^2;
surf(meanC2)

plot(mean(grandAllC2_targ_cue)')
hold on;
plot(mean(grandAllC2_targ_postcue)')
hold on;
plot(mean(grandAllC2_targ_stim)')



%% base cue data
% load iem data from each sj, and put them into different bins
% grandAllC2_base=sjx time points x channels
%grandAllC2_base_cue/postcue/stim= sjxchannels (easy to plot)

sublist=[1 2 3 4 5 6 7 8 9 10 11 12 14 15 17 18 20 22 23 24 27 32 34];  
for iSub=1:length(sublist)
    sjNum=sublist(iSub);
    load(sprintf('sj%02d_baseCueTF.set_iem.mat', sjNum));
   
       avgAllC2_base=squeeze(mean(allC2, 1));

    grandAllC2_base(iSub, :, :)=avgAllC2_base;
    
    grandAllC2_base_cue(iSub,:) = squeeze(abs(mean(mean(allC2(:,52:180,:),2))).^2);
    grandAllC2_base_postcue(iSub,:) = squeeze(abs(mean(mean(allC2(:,181:244,:),2))).^2);
    grandAllC2_base_stim(iSub,:) = squeeze(abs(mean(mean(allC2(:,245:321,:),2))).^2);
    
end 

% easy plotting
meanC2_base=squeeze(mean(squeeze(mean(grandAllC2_base))));
meanC2pwr_base=abs(meanC2_base).^2;
plot(meanC2pwr_base)


meanC1_base=squeeze(mean(squeeze(mean(grandAllC1_base))));
meanC1pwr_base=abs(meanC1_base).^2;
plot(meanC1pwr_base)

%base_cue=squeeze(abs(mean(grandAllC2_base(:,52:180,:),2)).^2); %for 1 sj, this is same as grandAllC2_base_cue
base_cue=abs(squeeze(mean(grandAllC2_base(:,52:180,:),2))).^2; %same for 2 sj
base_postCue=abs(squeeze(mean(grandAllC2_base(:,181:244,:),2))).^2;
base_stim=abs(squeeze(mean(grandAllC2_base(:,245:307,:),2))).^2;

plot(meanC2cue);
hold on;
plot(meanC2postcue);
hold on;
plot(meanC2stim);
hold off;

plot(base_cue)

plot(mean(grandAllC2_base_cue)', 'color', 'r')
hold on;
plot(mean(grandAllC2_base_postcue)', 'color', 'b')
hold on;
plot(mean(grandAllC2_base_stim)', 'color', 'g')
hold off;

surf(abs(squeeze(mean(grandAllC2_base))).^2)


%% plot together 

plot(mean(grandAllC2_dist_cue)', 'color', 'k', 'DisplayName' , 'dist cue')
% legenddist cue period')
hold on;
plot(mean(grandAllC2_dist_postcue)','color', 'y', 'DisplayName' , 'dist post cue')
% legend('dist post cue period')
hold on;
plot(mean(grandAllC2_dist_stim)', 'color', 'm', 'DisplayName' , 'dist stim')
% legend('dist stim period')
hold on;
plot(mean(grandAllC2_targ_cue)', 'color', 'c', 'DisplayName' , 'targ cue')
% legend ('targ cue period')
hold on;
plot(mean(grandAllC2_targ_postcue)', 'color','[0 0.4470 0.7410]', 'DisplayName' , 'targ post cue')
% legend('targ post cue period')
hold on;
plot(mean(grandAllC2_targ_stim)', 'color', '[.85 .325 .098', 'DisplayName' , 'targ stim')
% legend('targ stim period')
hold on;
plot(mean(grandAllC2_base_cue)', 'color', 'r', 'DisplayName' , 'base cue')
% legend('base cue period')
hold on;
plot(mean(grandAllC2_base_postcue)', 'color', 'b', 'DisplayName' , 'base post cue')
% legend ('base post cue period')
hold on;
plot(mean(grandAllC2_base_stim)', 'color', 'g','DisplayName' , 'base stim' )
% legend ('base stim period')
hold off;
legend;


%% calculate slope of IEM using polyfit 

%distractor
for sub= 1:size(grandAllC2_dist,1)
    for time = 1: size(grandAllC2_dist,2)
    dat=abs(squeeze(grandAllC2_dist(sub, time,:))).^2;
    x_new= [1:4];
    d=[dat(1),mean([dat(2), dat(6)]), mean([dat(3), dat(5)]),dat(4)];
    fit=polyfit(x_new,d,1);
    all_times_slope_dist(sub,time)=fit(1);
   
    end  
end 

%target
for sub_t= 1:size(grandAllC2_targ,1)
    for time_t = 1: size(grandAllC2_targ,2)
    dat_t=abs(squeeze(grandAllC2_targ(sub_t, time_t,:))).^2;
    x_new= [1:4];
    d_t=[dat_t(1),mean([dat_t(2), dat_t(6)]), mean([dat_t(3), dat_t(5)]),dat_t(4)];
    fit_t=polyfit(x_new,d_t,1);
    all_times_slope_targ(sub_t,time_t)=fit_t(1);
   
    end  
end 

%baseline
for sub_b= 1:size(grandAllC2_base,1)
    for time_b = 1: size(grandAllC2_base,2)
    dat_b=abs(squeeze(grandAllC2_base(sub_b, time_b,:))).^2;
    x_new= [1:4];
    d_b=[dat_b(1),mean([dat_b(2), dat_b(6)]), mean([dat_b(3), dat_b(5)]),dat_b(4)];
    fit_b=polyfit(x_new,d_b,1);
    all_times_slope_base(sub_b,time_b)=fit_b(1);
   
    end  
end 

%% one sample t-test of slope across time
h_d=ttest(all_times_slope_dist);
h_b=ttest(all_times_slope_base);
h_t=ttest(all_times_slope_targ);

%% %% plotting one-sample t-test of slope using shadedErrorBar function

% get x axis using EEG.times
x=EEG.times;
sample=sqrt(23);
%dist
sd_baseSlope=std(all_times_slope_base,0,1);
se_baseSlope=(sd_baseSlope)./sample;
%targ
sd_targSlope=std(all_times_slope_targ,0,1);
se_targSlope=(sd_targSlope)./sample;
%base
sd_distSlope=std(all_times_slope_dist,0,1);
se_distSlope=(sd_distSlope)./sample;

H(1)=shadedErrorBar(x,mean(all_times_slope_dist),se_distSlope,{'color','r'},1); 
hold on;
H(2)=shadedErrorBar(x,mean(all_times_slope_targ),se_targSlope,{'color','g'},1) %,'DisplayName' , 'targ cue')
hold on;
H(3)=shadedErrorBar(x,mean(all_times_slope_base),se_baseSlope,{'color','b'},1) %,'DisplayName' , 'base cue') 
axis([-200 1200 -.06 .18 ])

%plotting significance bar for each condition from ttest above
var_d=[EEG.times; h_d];
for b=1:size(var_d,2)
    if var_d(2,b)>0
        c(b)=var_d(1,b);
line([c(b),c(b)+1],[-.03,-.04],...
                'LineWidth',2,...
                'LineStyle','--',...
                'Color','r')
    end 
end
%.14,.15
var_t=[EEG.times; h_t];
for b=1:size(var_t,2)
    if var_t(2,b)>0
        q(b)=var_t(1,b);
line([q(b),q(b)+1],[-.04,-.05],...
                'LineWidth',2,...
                'LineStyle','--',...
                'Color','g')
    end 
end
%.15,.16
var_b=[EEG.times; h_b];
for b=1:size(var_b,2)
    if var_b(2,b)>0
        z(b)=var_b(1,b);
line([z(b),z(b)+1],[-.05,-.06],...
                'LineWidth',2,...
                'LineStyle','--',...
                'Color','b')
    end 
end
%.16,.17

% hold off;
title('slope across time points x cue condition');
xlabel('time') ;
ylabel('slope') 
% legend('dist cue', 'targ cue','base cue');
% legend ('Location', 'NorthWest');
legend([H(1).mainLine, H(2).mainLine, H(3).mainLine],...
    'dist cue','targ cue', 'base cue',...
    'Location', 'NorthWest');


%% plot pairwise comparisons for targ v dist
sample=sqrt(23);
sd_targSlope=std(all_times_slope_targ,0,1);
% sd_targSlope(2,:)=-1.*sd_targSlope;
se_targSlope=(sd_targSlope)./sample;

sd_distSlope=std(all_times_slope_dist,0,1);
% sd_distSlope(2,:)=-1.*sd_distSlope;
se_distSlope=(sd_distSlope)./sample;

%taking out sj7 from targ slope (need to fix sj 7 data)
all_times_slope_targ_2= all_times_slope_targ;
all_times_slope_targ_2(7,:)=[]; 

 
%pairwise comparisons
hyp= ttest(all_times_slope_dist, all_times_slope_targ_2);


H1(1)=shadedErrorBar(x,mean(all_times_slope_dist),se_distSlope,{'color','r'},1); 
hold on;
H1(2)=shadedErrorBar(x,mean(all_times_slope_targ),se_targSlope,{'color','g'},1) %,'DisplayName' , 'targ cue')
hold on;
axis([-200 1200 -.06 .18 ])


var_targDist=[EEG.times; hyp];
for b1=1:size(var_targDist,2)
    if var_targDist(2,b1)>0
        q1(b1)=var_targDist(1,b1);
line([q1(b1),q1(b1)+1],[-.03,-.04],...
                'LineWidth',2,...
                'LineStyle','--',...
                'Color','c')
    end 
end
title('Pairwise comparisons x Targ v Dist x cue slope across time');
xlabel('time') ;
ylabel('slope') 
% legend('dist cue', 'targ cue','base cue');
% legend ('Location', 'west');
legend([H1(1).mainLine, H1(2).mainLine],...
    'dist cue','targ cue',...
    'Location', 'NorthWest');

%% eeg to beh correlation
%correlating each time point to meanRT valid 
%get beh data from data(targ/dist/base)June26

meanValidDist=[mean(distractorCueData(:,1:2),2) mean(distractorCueData(:,7:8),2)];
meanValidtarg=[mean(targetCueData(:,1:2),2) mean(targetCueData(:,7:8),2)];
meanValidbase=[mean(baselineData(:,1:2),2) mean(baselineData(:,3:4),2)];
%taking out sj7 from all conds
meanValidDist(7,:)=[];
meanValidtarg(7,:)=[];
meanValidbase(7,:)=[];
%taking out sj7 from base slope
all_times_slope_base_2= all_times_slope_base;
all_times_slope_base_2(7,:)=[]; 


[corrTargRval, pcorrtarg]=corr(all_times_slope_targ_2,meanValidtarg(:,1));
[corrDistRval, pcorrdist]=corr(all_times_slope_dist,meanValidDist(:,1));
[corrBaseRval, pcorrbase]=corr(all_times_slope_base_2,meanValidbase(:,1));

pcorrtarg=pcorrtarg';
pcorrdist=pcorrdist';
pcorrbase=pcorrbase';

rvalues=[corrTargRval';corrDistRval';corrBaseRval'];
    

H(1)=shadedErrorBar(x,rvalues(2,:),se_distSlope,{'color','r'},1); 
hold on;
H(2)=shadedErrorBar(x,rvalues(1,:),se_targSlope,{'color','g'},1) %,'DisplayName' , 'targ cue')
hold on;
H(3)=shadedErrorBar(x,rvalues(3,:),se_baseSlope,{'color','b'},1) %,'DisplayName' , 'base cue') 
axis([-200 1200 -1 1])

for corrID=1:length(pcorrdist)
    if pcorrdist(1,corrID)<.05
        pcorrdist(2,corrID)=1;
    else pcorrdist(2,corrID)=0;
    end
end

var_d_r=[EEG.times;pcorrdist];
for b_r=1:size(var_d_r,2)
    if var_d_r(3,b_r)>0
        c_r(b_r)=var_d_r(1,b_r);
line([c_r(b_r),c_r(b_r)+1],[.6,.65],...
                'LineWidth',2,...
                'LineStyle','--',...
                'Color','r')
    end 
end

for corrID2=1:length(pcorrtarg)
    if pcorrtarg(1,corrID2)<.05
        pcorrtarg(2,corrID2)=1;
    else pcorrtarg(2,corrID2)=0;
    end
end

targ_corr=[EEG.times;pcorrtarg];


% var_t_r=[EEG.times; pcorr];
for bb=1:size(targ_corr,2)
    if targ_corr(3,bb)>0
        targ_r(bb)=targ_corr(1,bb);
line([targ_r(bb),targ_r(bb)+1],[.7,.75],...
                'LineWidth',2,...
                'LineStyle','--',...
                'Color','g')
    end 
end


for corrID3=1:length(pcorrbase)
    if pcorrbase(1,corrID3)<.05
        pcorrbase(2,corrID3)=1;
    else pcorrbase(2,corrID2)=0;
    end
end

base_r=[EEG.times; pcorrbase];
for id4=1:size(base_r,2)
    if base_r(3,id4)>0
        base2plot(id4)=base_r(1,id4);
line([base2plot(id4),base2plot(id4)+1],[.8,.85],...
                'LineWidth',2,...
                'LineStyle','--',...
                'Color','b')
    end 
end


% hold off;
title('correlate slope of each time point (IEM) to mean valid RT (beh)');
xlabel('time') ;
ylabel('r values') 
% legend('dist cue', 'targ cue','base cue');
% legend ('Location', 'west');
legend([H(1).mainLine, H(2).mainLine, H(3).mainLine],...
    'dist cue','targ cue', 'base cue',...
    'Location', 'Southwest');



