# cueing-EEG-study

In this study, we were exploring 1. whether cueing the location of a distractor impacts how we process it/experience distraction from it. 2. what the neural mechanisms are underlying behavior when cueing a target v a distractor.

I analyzed beh data first- beh data from this study showed promising benefit of cueing when baseline was compared to distractor cueing condition and to target cueing condition. (scripts here or to be uploaded)

For the EEG data- I first preprocessed the data using standard routine- epoching, baseline correcting, filtering, matching beh to EEG and then re-epoching and baseline correcting to get cue-related activity. (scripts here or to be uploaded)

Then I used an IEM routine to look at the representation of the location when it is being cued by a validly cued target cue or validly cued distractor cue.
(script here or to be uploaded)

Stimulus Presentation:
%used to run the actual experiment, using Psychtoolbox
baselineTaskTF.m
mainDistractorCueingTF.m
mainTargetCueing.m

Behavioral data:
%grabs raw data, cleans data and computes averages across conditions
%analysisCode5baseCue.m
%analysisCode5distCue.m
%analysisCode5targCue.m

%some statistical analyses, I used this more for behavioral cueing exp, may have done analysis for EEG beh data using SPSS
stat_analysisCode5_dist.m
stat_analysisCode5_targ.m
stat_analysisCode5_base.m

EEG data:
%computes averages, slope, basic stats and plots 
iem_trialAnalysis_theta_cued
