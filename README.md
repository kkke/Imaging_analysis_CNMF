# Imaging_analysis_CNMF
The imaging analysis relys on the CNMF packages:https://github.com/flatironinstitute/CaImAn-MATLAB and the NoRMCorre algorithm https://github.com/flatironinstitute/NoRMCorre.

The analysis pipeline is as following:
1. Export the imaging files .MDF into .tif files and use FIJI to down sampled the files (5 times average)
2. Use the batch_CNMF.m to correct the brain motion and to automatically segment the data
3. Use the batch_CNMF_v2.m to align the imaging files with the behavioral licking data and taste delivery.
4. Use Manual_ROI_correction.m to manually remove bad segments
5. Use the summaryImaging_v2.m (in DataAnalysis folder) to automatically summarize the response

