function analysisCode5targCue(sublist) % Lena, you can type in analysisCode4([# #]) in the command window 
                                    % to run the data of the two 's%02d'jects
                                    % through the code. You can also do
                                    % them one by one. Stuff should appear
                                    % in the current folder section. 
data=struct(...
    'subject',{},...
    'meanCongValidRT',{},...
    'meanIncongValidRT',{},...
    'meanCongInvalidRT',{},...
    'meanIncongInvalidRT',{},...
    'meanCongNPRT',{},...
    'meanIncongNPRT',{},...
    'congValidPC',{},...
    'incongValidPC',{},...
    'congInvalidPC',{},...
    'incongInvalidPC',{},...
    'congNPPC',{},...
    'incongNPPC',{});
%     'congNeutPC',{},...
%     'incongNeutPC',{});

for sub=1:length(sublist)
    load(sprintf('sj%02d_targCueTF.mat',sublist(:,sub)))
    %valid trials
    congCountValid = 0;
    incongCountValid = 0;
    for i=1:length(trialLog.trialInfo)
        
        if trialLog.trialInfo(i).brokenTrial==0
            if trialLog.trialInfo(i).accuracy==1
                
                if trialLog.trialInfo(i).congruent==10 && trialLog.trialInfo(i).trialType==200
                    
                    congCountValid=congCountValid+1;
                    
                    congVecValid(congCountValid,1) = trialLog.trialInfo(i).rt;
                    congVecValid(congCountValid,2) = trialLog.trialInfo(i).accuracy;
                    
                elseif trialLog.trialInfo(i).congruent==20 && trialLog.trialInfo(i).trialType==200
                    
                    incongCountValid = incongCountValid+1;
                    
                    incongVecValid(incongCountValid,1) = trialLog.trialInfo(i).rt;
                    incongVecValid(incongCountValid,2) = trialLog.trialInfo(i).accuracy;
                end
            end
        end
    end
    
    
    
    
    %% invalid trials
    congCountInvalid = 0;
    incongCountInvalid = 0;
    for i=1:length(trialLog.trialInfo)
        
        if trialLog.trialInfo(i).brokenTrial==0
            if trialLog.trialInfo(i).accuracy==1
                
                if trialLog.trialInfo(i).congruent==10 && trialLog.trialInfo(i).trialType==201
                    
                    congCountInvalid=congCountInvalid+1;
                    
                    congVecInvalid(congCountInvalid,1) = trialLog.trialInfo(i).rt;
                    congVecInvalid(congCountInvalid,2) = trialLog.trialInfo(i).accuracy;
                    
                elseif trialLog.trialInfo(i).congruent==20 && trialLog.trialInfo(i).trialType==201
                    
                    incongCountInvalid = incongCountInvalid+1;
                    
                    incongVecInvalid(incongCountInvalid,1) = trialLog.trialInfo(i).rt;
                    incongVecInvalid(incongCountInvalid,2) = trialLog.trialInfo(i).accuracy;
                end
            end
        end
    end
    
    
    
    %% negative priming trials
    congCountNP = 0;
    incongCountNP = 0;
    for i=1:length(trialLog.trialInfo)
        
        if trialLog.trialInfo(i).brokenTrial==0
            if trialLog.trialInfo(i).accuracy==1
                
                if trialLog.trialInfo(i).congruent==10 && trialLog.trialInfo(i).trialType==202
                    
                    congCountNP=congCountNP+1;
                    
                    congVecNP(congCountNP,1) = trialLog.trialInfo(i).rt;
                    congVecNP(congCountNP,2) = trialLog.trialInfo(i).accuracy;
                    
                elseif trialLog.trialInfo(i).congruent==20 && trialLog.trialInfo(i).trialType==202
                    
                    incongCountNP = incongCountNP+1;
                    
                    incongVecNP(incongCountNP,1) = trialLog.trialInfo(i).rt;
                    incongVecNP(incongCountNP,2) = trialLog.trialInfo(i).accuracy;
                end
            end
        end
    end
    
    
    
    
  
    
    %% total trialcount for valid, invalid, np and neutral trials, congruent and incongruent 
    % this part counts the number of trials presented for each of the valid,
    % invalid, np and neutral trials. I know what those numbers are, but I
    % counted them here again just to double check that everyone did the
    % same/correct number of trials for each of the different trial types.
    nCongCountValid=0;
    nIncongCountValid=0;
    nCongCountInvalid=0;
    nIncongCountInvalid=0;
    nCongCountNP=0;
    nIncongCountNP=0;
%     nCongCountNeut=0;
%     nIncongCountNeut=0;
    
    
    for i=1:length(trialLog.trialInfo)
        
        if trialLog.trialInfo(i).brokenTrial==0
            if trialLog.trialInfo(i).congruent==10 && trialLog.trialInfo(i).trialType==200
                nCongCountValid=nCongCountValid+1;
                nCongValid(nCongCountValid,1)=trialLog.trialInfo(i).congruent;
                
            elseif trialLog.trialInfo(i).congruent==20 && trialLog.trialInfo(i).trialType==200
                nIncongCountValid=nIncongCountValid+1;
                nIncongValid(nIncongCountValid,1)=trialLog.trialInfo(i).congruent;
                
                
            elseif trialLog.trialInfo(i).congruent==10 && trialLog.trialInfo(i).trialType==201
                nCongCountInvalid=nCongCountInvalid+1;
                nCongInvalid(nCongCountInvalid,1)=trialLog.trialInfo(i).congruent;
                
                
            elseif trialLog.trialInfo(i).congruent==20 && trialLog.trialInfo(i).trialType==201
                nIncongCountInvalid=nIncongCountInvalid+1;
                nIncongInvalid(nIncongCountInvalid,1)=trialLog.trialInfo(i).congruent;
                
            elseif trialLog.trialInfo(i).congruent==10 && trialLog.trialInfo(i).trialType==202
                nCongCountNP=nCongCountNP+1;
                nCongNP(nCongCountNP,1)=trialLog.trialInfo(i).congruent;
                
                
            elseif trialLog.trialInfo(i).congruent==20 && trialLog.trialInfo(i).trialType==202
                nIncongCountNP=nIncongCountNP+1;
                nIncongNP(nIncongCountNP,1)=trialLog.trialInfo(i).congruent;
                
%             elseif trialLog.trialInfo(i).congruent==1 && trialLog.trialInfo(i).trialType==103
%                 nCongCountNeut=nCongCountNeut+1;
%                 nCongNeut(nCongCountNeut,1)=trialLog.trialInfo(i).congruent;
%                 
%                 
%             elseif trialLog.trialInfo(i).congruent==2 && trialLog.trialInfo(i).trialType==103
%                 nIncongCountNeut=nIncongCountNeut+1;
%                 nIncongNeut(nIncongCountNeut,1)=trialLog.trialInfo(i).congruent;
                
            end
        end
    end
    
    %total valid, invalid, np and neutral trials presented stored in arrays
    totCongValid=nCongValid(:,1);
    totIncongValid=nIncongValid(:,1);
    totCongInvalid=nCongInvalid(:,1);
    totIncongInvalid=nIncongInvalid(:,1);
    totCongNP=nCongNP(:,1);
    totIncongNP=nIncongNP(:,1);
%     totCongNeut=nCongNeut(:,1);
%     totIncongNeut=nIncongNeut(:,1);
    
    
    
    
    
    
    %% DATA CLEANUP:
    
    %% VALID TRIALS
    
    %%%% congruent 
    
    %creating variables to store the valid congruent trials
    congValidRT=congVecValid(:,1); %getting the rt from the loop above.
    rawCongValidMeanRT=mean(congValidRT);%mean of just the raw data- used to clean the data.
    rawCongValidSTD_RT=std(congValidRT);
    congValidAcc=congVecValid(:,2);
    
    %removing RT trials less than 200 ms and their corresponding Acc
    %trials. 
    deleteCongValidRT2=find(congVecValid(:,1)<200 | congVecValid(:,1)>1000);
    congValidRT(deleteCongValidRT2)=[];
    congValidAcc(deleteCongValidRT2)=[];
     %meanCongValidRT=mean(congValidRT);
     
    %removing RT trial greater 1000 ms and their corresponding Acc trials
%      deleteCongValidRT3=[find(congVecValid(:,1)>1000)];
%     congValidRT(deleteCongValidRT3)=[];
%     congValidAcc(deleteCongValidRT3)=[];
     meanCongValidRT=mean(congValidRT);
     

    %%%% incongruent trials:
    incongValidRT=incongVecValid(:,1); %raw data
    rawIncongValidMeanRT=mean(incongValidRT);%raw mea
    rawIncongValidSTD_RT=std(incongValidRT);%raw std
    incongValidAcc=incongVecValid(:,2);
  
    deleteIncongValidRT2=find(incongVecValid(:,1)<200 | incongVecValid(:,1)>1000);
    incongValidRT(deleteIncongValidRT2)=[];
    incongValidAcc(deleteIncongValidRT2)=[];
    %meanIncongValidRT=mean(incongValidRT);
%     
%     deleteIncongValidRT3=[find(incongVecValid(:,1)>1000)];
%     incongValidRT(deleteIncongValidRT3)=[];
%     incongValidAcc(deleteIncongValidRT3)=[];
    meanIncongValidRT=mean(incongValidRT);
    
         
    
    %% invalid trials
    
    %%%%congruent trials
    congInvalidRT=congVecInvalid(:,1); %raw data
    rawCongInvalidMeanRT=mean(congInvalidRT);
    rawCongInvalidSTD_RT= std(congInvalidRT);
    congInvalidAcc=congVecInvalid(:,2);
    
    
    deleteCongInvalidRT3= find(congVecInvalid(:,1)<200 | congVecInvalid(:,1)>1000);
    congInvalidRT(deleteCongInvalidRT3)=[];  
    congInvalidAcc(deleteCongInvalidRT3)=[];
    %meanCongInvalidRT=mean(congInvalidRT);
  
%     deleteCongInvalidRT4= [find(congVecInvalid(:,1)>1000)];
%     congInvalidRT(deleteCongInvalidRT4)=[];  
%     congInvalidAcc(deleteCongInvalidRT4)=[];
    meanCongInvalidRT=mean(congInvalidRT);
    
    %incongruent trials
    incongInvalidRT=incongVecInvalid(:,1);
    rawIncongInvalidMeanRT=mean(incongInvalidRT);
    rawIncongInvalidSTD_RT=std(incongInvalidRT);
    incongInvalidAcc=incongVecInvalid(:,2);
    
    deleteIncongInvalidRT3=find(incongVecInvalid(:,1)<200 | incongVecInvalid(:,1)>1000);
    incongInvalidRT(deleteIncongInvalidRT3)=[]; 
    incongInvalidAcc(deleteIncongInvalidRT3)=[]; 
    %meanIncongInvalidRT=mean(incongInvalidRT);
    
%     deleteIncongInvalidRT4=[find(incongVecInvalid(:,1)>1000)];
%     incongInvalidRT(deleteIncongInvalidRT4)=[]; 
%     incongInvalidAcc(deleteIncongInvalidRT4)=[]; 
    meanIncongInvalidRT=mean(incongInvalidRT);
    
    
    %% np trials
    
    %congruent trials
    congNPRT=congVecNP(:,1);
    congNPAcc=congVecNP(:,2);
    rawCongNPmeanRT=mean(congNPRT);
    rawCongNPstdRT=std(congNPRT);
    
    deleteCongNPRT3=  find(congVecNP(:,1)<200 |congVecNP(:,1)>1000);
    congNPRT(deleteCongNPRT3)=[];
    congNPAcc(deleteCongNPRT3)=[];
    %meanCongNPRT=mean(congNPRT);
   
%      deleteCongNPRT4=  [find(congVecNP(:,1)>1000)];
%     congNPRT(deleteCongNPRT4)=[];
%     congNPAcc(deleteCongNPRT4)=[];
    meanCongNPRT=mean(congNPRT);
    
    %incongruent trials
    incongNPRT=incongVecNP(:,1);
    rawIncongNPmeanRT=mean(incongNPRT);
    rawIncongNPstdRT=std(incongNPRT);
    incongNPAcc=incongVecNP(:,2);
  
    deleteIncongNPRT3=find(incongVecNP(:,1)< 200 | incongVecNP(:,1)> 1000); 
    incongNPRT(deleteIncongNPRT3)=[];
    incongNPAcc(deleteIncongNPRT3)=[];
    %meanIncongNPRT=mean(incongNPRT);
    
%    deleteIncongNPRT4=[find(incongVecNP(:,1)> 1000)]; 
%     incongNPRT(deleteIncongNPRT4)=[];
%     incongNPAcc(deleteIncongNPRT4)=[];
    meanIncongNPRT=mean(incongNPRT);

    
    %% neutral trials
%     
%     %congruent trials
%     congNeutRT=congVecNeut(:,1);
%     congNeutAcc=congVecNeut(:,2);
%     rawCongNeutMeanRT=mean(congNeutRT);
%     rawCongNeutSTD_rt=std(congNeutRT);
%     
%     deleteCongNeutRT3=[find(congVecNeut(:,1) <200)];
%     congNeutRT(deleteCongNeutRT3)=[];
%     congNeutAcc(deleteCongNeutRT3)=[];
%     meanCongNeutRT=mean(congNeutRT);
%     
%     %incongruent trials
%     incongNeutRT=incongVecNeut(:,1);
%     incongNeutAcc=incongVecNeut(:,2)
%     rawIncongNeutMeanRT=mean(incongNeutRT);
%     rawIncongNeutSTD_rt=std(incongNeutRT);
%      
%     deleteIncongNeutRT3=[find(incongVecNeut(:,1)<200)];
%     incongNeutRT(deleteIncongNeutRT3)=[];
%     incongNeutAcc(deleteIncongNeutRT3)=[];
%     meanIncongNeutRT=mean(incongNeutRT);
%     
%     
    %calculating percent correct all trials
    congValidPC=(sum(congValidAcc)/length(totCongValid));
    incongValidPC=(sum(incongValidAcc)/length(totIncongValid));
    congInvalidPC=(sum(congInvalidAcc)/length(totCongInvalid));
    incongInvalidPC=(sum(incongInvalidAcc)/length(totIncongInvalid));
    congNPPC=sum((congNPAcc)/length(totCongNP));
    incongNPPC=sum((incongNPAcc)/length(totIncongNP));
%     congNeutPC=sum((congNeutAcc)/length(totCongNeut));
%     incongNeutPC=sum((incongNeutAcc)/length(totIncongNeut));
    
    
    
    %saving the data
    
    targetCueData(sub,1)=meanCongValidRT;
    targetCueData(sub,2)=meanIncongValidRT;
    targetCueData(sub,3)=meanCongInvalidRT;
    targetCueData(sub,4)=meanIncongInvalidRT;
    targetCueData(sub,5)=meanCongNPRT;
    targetCueData(sub,6)=meanIncongNPRT;
%     targetCueData(sub,7)=meanCongNeutRT;
%     targetCueData(sub,8)=meanIncongNeutRT;
    targetCueData(sub,7)=congValidPC;
    targetCueData(sub,8)=incongValidPC;
    targetCueData(sub,9)=congInvalidPC;
    targetCueData(sub,10)=incongInvalidPC;
    targetCueData(sub,11)=congNPPC;
    targetCueData(sub,12)=incongNPPC;
%     targetCueData(sub,15)=congNeutPC;
%     targetCueData(sub,16)=incongNeutPC;
    
    save('datatargCueJune26', 'targetCueData');
    
    
    data(sub).subject=sub;
    data(sub).meanCongValidRT=meanCongValidRT;
    data(sub).meanIncongValidRT=meanIncongValidRT;
    data(sub).meanCongInvalidRT=meanCongInvalidRT;
    data(sub).meanIncongInvalidRT=meanIncongInvalidRT;
    data(sub).meanCongNPRT=meanCongNPRT;
    data(sub).meanIncongNPRT=meanIncongNPRT;
%     data(sub).meanCongNeutRT=meanCongNeutRT;
%     data(sub).meanIncongNeutRT=meanIncongNeutRT;
    data(sub).congValidPC=congValidPC;
    data(sub).incongValidPC=incongValidPC;
    data(sub).congInvalidPC=congInvalidPC;
    data(sub).incongInvalidPC=incongInvalidPC;
    data(sub).congNPPC=congNPPC;
    data(sub).incongNPPC=incongNPPC;
%     data(sub).congNeutPC=congNeutPC;
%     data(sub).incongNeutPC=incongNeutPC;
    
    
    save(sprintf('%s02d_targCueTFDataJune26', 'sub'),'data');
    
    
    nCongValid(:,1)=0;
    nIncongValid(:,1)=0;
    nCongInvalid(:,1)=0;
    nIncongInvalid(:,1)=0;
    nCongNP(:,1)=0;
    nIncongNP(:,1)=0;
%     nCongNeut(:,1)=0;
%     nIncongNeut(:,1)=0;
    congVecValid(:,1)=0;
    congVecValid(:,2)=0;
    incongVecValid(:,1)=0;
    incongVecValid(:,2)=0;
    congVecInvalid(:,1)=0;
    congVecInvalid(:,2)=0;
    incongVecInvalid(:,1)=0;
    incongVecInvalid(:,2)=0;
    congVecNP(:,1)=0;
    congVecNP(:,2)=0;
    incongVecNP(:,1)=0;
    incongVecNP(:,2)=0;
%     congVecNeut(:,1)=0;
%     congVecNeut(:,2)=0;
%     incongVecNeut(:,1)=0;
%     incongVecNeut(:,2)=0;
    meanCongValidRT=[];
    meanIncongValidRT=[];
    meanCongInvalidRT=[];
    meanIncongInvalidRT=[];
    meanCongNPRT=[];
    meanIncongNPRT=[];
%     meanCongNeutRT=[];
%     meanIncongNeutRT=[];
    congValidPC=[];
    incongValidPC=[];
    congInvalidPC=[];
    incongInvalidPC=[];
    congNPPC=[];
    incongNPPC=[];
%     congNeutPC=[];
%     incongNeutPC=[];
    
    
    
    
    
end

end
