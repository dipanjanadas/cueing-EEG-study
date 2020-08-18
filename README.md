# cueing-EEG-study

In this study, we were exploring 1. whether cueing the location of a distractor impacts how we process it/experience distraction from it. 2. what the neural mechanisms are underlying behavior when cueing a target v a distractor.

I analyzed beh data first- beh data from this study showed promising benefit of cueing when baseline was compared to distractor cueing condition and to target cueing condition. (scripts here or to be uploaded)

For the EEG data- I first preprocessed the data using standard routine- epoching, baseline correcting, filtering, matching beh to EEG and then re-epoching and baseline correcting to get cue-related activity. (scripts here or to be uploaded)

Then I used an IEM routine to look at the representation of the location when it is being cued by a validly cued target cue or validly cued distractor cue.
(script here or to be uploaded)

Folders:

Stimulus Presentation:
1. used to run the actual experiment, using Psychtoolbox

Behavioral data:
1. grabs raw data, cleans data and computes averages across conditions
2. some statistical analyses, I used this more for behavioral cueing exp, may have done analysis for EEG beh data using SPSS

EEG preprocessing +IEM
1. load data
2. re-reference, re sample,filter, epoch +baseline correct, match EEG to beh, re-epoch around cue presentation
3. band pass filter : alpha/theta
4. Inverted encoding model

IEM stats and plots
1. computes averages, slope, basic stats and plots of IEM data

