# Imaging_analysis_CNMF_2p
The imaging analysis relys on the CNMF packages:https://github.com/flatironinstitute/CaImAn-MATLAB and the NoRMCorre algorithm https://github.com/flatironinstitute/NoRMCorre.

The analysis pipeline is as following:
1. Export the imaging files .MDF into .tif files and use FIJI to down sampled the files (5 times average)
2. Use the batch_CNMF.m to correct the brain motion and to automatically segment the data; there are multiple sessions in the script, each seesion represents an animal.
3. Use the batch_CNMF_v2.m to align the imaging files with the behavioral licking data and taste delivery. The code contains lots of small sessions with each representing a individual animal and recording sessions. This script relies on imaging_analysis_GC_v6.m; The imaging_analysis_GC_v6 registers the imaging data with the behavioral data and it will return the following variables saved in dataForCNMF.mat.
   - trial: align smoothed fluorescent calcium traces with behavioral events
   - trial2: align smoothed deconvolved neural activity with beheavioral events
   - trial3: align smoothed deconvolved calcium trances with beahvaioral events
   - CC, jsf: information related to the location of each neurons
   
   **In addition, you can also run summary_forSingleSession.m inside the batch_CNMF_v2 to summarize the recording data; summary_forSingleSession.m uses 1s before the cue as baseline for testing cue, lick and taste response; uou can also run summary_forSingleSession_v2.m inside the batch_CNMF_v2 to summarize the recording data; summary_forSingleSession_v2.m uses 0.5s before the taste as baseline for testing taste response, 0.5 s before lick to test the lick response. Please sure that you manually remove non-neuron ROIs.**
   
~~4. Use Manual_ROI_correction.m to manually remove bad segments~~
   ~~- Only the scripts in the first session is used for manual correction~~
   ~~- Just type the ROI you think is not good and reject it~~
   ~~- It will save a file called reject.mat (it may contains repeated data, remember to use unique(reject) to use it)~~
   
~~5. Use the summaryImaging_v2.m to automatically summarize the response
   - It calls the summaryImaging_v8 function, which only deals with the taste response;
      ~~- It calls the imaging_analysis_GC_v8 to remove the smoothness
      ~~- It calls the TasteTestDev_v2.m to perform the stats for taste response: p<0.05, baseline is 1 s before tone delivery
      ~~- It also loads the manually deleted ROIs to remove them
      ~~- These analysis results should be saved as **all_decon_taste_v2.mat**
  ~~- In other case, the code can call the summaryImaging_v6.m function, which deals with the cue and taste response;
      - In addition to remove the smoothness and manually corrected ROIs
      - It calculate the lick initiation for each trials and use the licking initiation to define the taste period for cue and lick response; The function is lickInitiateTime.m
      - It removes trials with early licks; licks occur within 1 s after tone delivery were removed.
      - It realign the calcium traces to the lick initation
      - It calls the tasteResponse8.m to perform the stats for cue and lick response, 1 s before the tone is used as baseline; In addition, it also uses 0.5 s before taste delivery to calculate taste responses. 
      - The analysis results should be saved as **all_decon_newAlign_v2-2.mat**
      - **In other cases**, you can enable the code at line 33 to use tasteResponse10.m to perform the stats. It uses 0.5 s before licking as basline, you should saved the results as **all_decon_newAlign_v3-2.mat**
   - You could call summaryImaging_v9.m and LickingPlots.m to plot the licking parameters (latency and duration)
      
      
~~6. Use the summaryImaging_v7.m to summarize and plot the results
   - It needs the stats for taste response; which the baseline is 1 s before the tone and there are no trials being removed: **all_decon_taste_v2.mat**
   ~~- It needs the stats for cue and lick responses; which the baseline is 1 s before the tone and some trials with early licking were removed: **all_decon_newAlign_v2-2.mat**
   - It needs the stats for taste response; which the baseline is 0.5 s before the taste delivery. This is used to differentiate the lick and taste response:**all_decon_newAlign_v2-2.mat** or **all_decon_newAlign_v3-2.mat**
   ~~- It needs the stats for lick response; which the baseline is 0.5 s before licking. This is used to differentiate the cue and lick response: **all_decon_newAlign_v3-2.mat**~~

7. Register cells across different sessions
   - I tried to use the registration method from the CaImAn-MATLAB package, and it did not work very well; I also tried to use the CellReg from the zivlab, it worked much better. https://github.com/zivlab/CellReg; so the cell align analysis would dependent on this package.
   - CellAlign_test.m  is used as a test script for cell registration with CellReg and CNMF
   - Step 1: run CellAlign_v1. It can re-organize the data to retrieve the spatial footprints for each session; CellReg package needs the spatial footprints for each neurons which is NxMxK matrix, the variable called A_keep which is returned by batch_CNMF contains the information, but you need to reshape it. 
   - Step 2: run the CellReg.m from the CellReg package; you probably need to play with some parameters to get it work with your data
   
