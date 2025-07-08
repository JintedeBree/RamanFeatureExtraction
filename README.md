# RamanFeatureExtraction
A MATLAB based Raman Feature extraction app which can extract morphological and chemical characteristics from microcalcifications present in a Raman microspectroscopic raster scan of 40x40 (56x56 um). This script is written by Jinte de Bree as part of a bachelor thesis 'Hyperspectral Raman imaging of breast tissue microcalcifications: differentiating benign and malignant pathologies', University of Twente, the Netherlands.

FeatureExtractionPipeline.mlap is the main app, which calls the functions present in folder 'FunctionsRFE'. An explanation of how the app should be used to extract characteristics from the Raman microscopic raster scan:

tracking/celltracking.m is the function containing the CellTracking algorithm.

tracking/findmatch.m is utilized within this function to match cells from different frames.

Correspondation to jinte@familiedebree.nl
