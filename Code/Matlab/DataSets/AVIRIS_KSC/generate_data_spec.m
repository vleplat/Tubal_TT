clear all;clc;
%load HYDICE sensor spec
cd('../SENSORS/AVIRIS/')
load Aviris_spec.mat
cd('../../AVIRIS_KSC/')
%Define the spectral bands removed during pre-processing
%see website
specBand_removed=[1:4 102:110 136:153 198:210];
dataset_specBandID=spec_bandID;
dataset_specBandID(specBand_removed')=[];
dataset_specBandWL=spec_bandWL;
dataset_specBandWL(specBand_removed')=[];
clear T
clear spec_bandID
clear spec_bandWL
save KSC_spec.mat