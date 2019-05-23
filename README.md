# Imaging_analysis_CNMF
The imaging analysis relys on the CNMF packages:https://github.com/flatironinstitute/CaImAn-MATLAB and the NoRMCorre algorithm https://github.com/flatironinstitute/NoRMCorre.

The analysis pipeline is as following:
1. Export the imaging files .MDF into .tif files and use FIJI to down sampled the files (5 times average)
2. Use the batch_CNMF.m to correct the brain motion and to automatically segment the data
3. Use the batch_CNMF_v2.m to align the imaging files with the behavioral licking data and taste delivery. The code contains lots of small sessions with each representing a individual animal and recording sessions. This script relies on imaging_analysis_GC_v6.m; The imaging_analysis_GC_v6 registers the imaging data with the behavioral data and it will return the following variables.
  3.1. trial: align smoothed fluorescent calcium traces with behavioral events
  3.2. trial2: align non-smoothed deconvolved neural activity with beheavioral events
  3.3. trial3: align non-smoothed deconvolved calcium trances with beahvaioral events
  3.4. CC, jsf: information related to the location of each neurons
4. Use Manual_ROI_correction.m to manually remove bad segments
5. Use the summaryImaging_v2.m (in DataAnalysis folder) to automatically summarize the response

