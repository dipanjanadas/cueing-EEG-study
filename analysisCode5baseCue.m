function analysisCode5baseCue(sublist) % Lena, you can type in analysisCode4([# #]) in the command window 
                                    % to run the data of the two 's%02d'jects
                                    % through the code. You can also do
                                    % them one by one. Stuff should appear
                                    % in the current folder section. 
data=struct(...
    'subject',{},...
    'meanCongValidRT',{},...
    'meanIncongValidRT',{},...
     'congValidPC',{},...
    'incongValidPC',{});


for sub=1:length(sublist)
    load(sprintf('sj%02d_baseCueTF.mat',sublist(:,sub)))
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
    
   
    %% total trialcount for valid, invalid, np and neutral trials, congruent and incongruent 
    % this part counts the number of trials presented for each of the valid,
    % invalid, np and neutral trials. I know what those numbers are, but I
    % counted them here again just to double check that everyone did the
    % same/correct number of trials for each of the different trial types.
    nCongCountValid=0;
    nIncongCountValid=0;


    
    for i=1:length(trialLog.trialInfo)
        
        if trialLog.trialInfo(i).brokenTrial==0
            if trialLog.trialInfo(i).congruent==10 && trialLog.trialInfo(i).trialType==200
                nCongCountValid=nCongCountValid+1;
                nCongValid(nCongCountValid,1)=trialLog.trialInfo(i).congruent;
                
            elseif trialLog.trialInfo(i).congruent==20 && trialLog.trialInfo(i).trialType==200
                nIncongCountValid=nIncongCountValid+1;
                nIncongValid(nIncongCountValid,1)=trialLog.trialInfo(i).congruent;

            end
        end
    end
    
    %total valid, invalid, np and neutral trials presented stored in arrays
    totCongValid=nCongValid(:,1);
    totIncongValid=nIncongValid(:,1);
    %% DATA CLEANUP:
    
    %% VALID TRIALS
    
    %%%% congruent 
    
    %creating variables to store the valid congruent trials
    congValidRT=congVecValid(:,1); %getting the rt from the loop above.
    rawCongValidMeanRT=mean(congValidRT);%mean of just the raw data- used to clean the data.
    rawCongValidSTD_RT=std(congValidRT);
    congValidAcc=congVecValid(:,2);
    
    %removing RT trials less than 200 ms and greater than 1000ms and their corresponding Acc
    %trials. 
    deleteCongValidRT2=find(congVecValid(:,1)<200 | congVecValid(:,1)>1000);
    congValidRT(deleteCongValidRT2)=[];
    congValidAcc(deleteCongValidRT2)=[];
     meanCongValidRT=mean(congValidRT);
     
     

    %%%% incongruent trials:
    incongValidRT=incongVecValid(:,1); %raw data
    rawIncongValidMeanRT=mean(incongValidRT);%raw mea
    rawIncongValidSTD_RT=std(incongValidRT);%raw std
    incongValidAcc=incongVecValid(:,2);
  
    deleteIncongValidRT2=find(incongVecValid(:,1)<200|incongVecValid(:,1)>1000);
    incongValidRT(deleteIncongValidRT2)=[];
    incongValidAcc(deleteIncongValidRT2)=[];
    meanIncongValidRT=mean(incongValidRT);
   
    %calculating percent correct all trials
    congValidPC=(sum(congValidAcc)/length(totCongValid));
    incongValidPC=(sum(incongValidAcc)/length(totIncongValid));

    %saving the data
    
    baselineData(sub,1)=meanCongValidRT;
    baselineData(sub,2)=meanIncongValidRT;
    baselineData(sub,3)=congValidPC;
    baselineData(sub,4)=incongValidPC;

    
    save('databaselineJune26', 'baselineData');
    
    
    data(sub).subject=sub;
    data(sub).meanCongValidRT=meanCongValidRT;
    data(sub).meanIncongValidRT=meanIncongValidRT;

    data(sub).congValidPC=congValidPC;
    data(sub).incongValidPC=incongValidPC;

    
    
    save(sprintf('%s02d_baseCueTFDataJune26', 'sub'),'data');
    
    
    nCongValid(:,1)=0;
    nIncongValid(:,1)=0;
    
end

end
