function [ output_args ] = simulateForFarField( matrix, unitWidth, portLocations, FFfreq, portToExcite, portImpedances)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
buildLensFiles(matrix,unitWidth,portLocations, pwd); %builds netlist files for MOM
generateFarFieldParams_vplFile(FFfreq, portLocations, portToExcite, portImpedances, [folderName, '\proj.vpl']);
runMOM(folderName);

end

