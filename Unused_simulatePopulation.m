function [ Sparams ] = simulatePopulation( pop, portLocations, unitWidth, startFreq, stopFreq, stepFreq, folderName, WorL)
%simulatedPopulation runs Agilent ADS Momentum for all members of the
%population with given paramters
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 6, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param pop is the population to be run as MxNxnumOfPop matrix
%@param portLocations is the location of all the ports listed as: [x1 y1; x2
%y2; x3 y3;]
%@param unitWidth is the geometric length and width of each cell in pop
%@param folderName is the name of the folder where it should run
%
%@return Sparams is the resulting S paramters in RI format in the following
%order: 11, 12, 13, 14,... 1N, 21, 22, 23, 24, ... 2N, etc.
x=1;

%Run Agilent ADS Momentum for each member
while(x<=size(pop,3))
    buildLensFiles(pop(:,:,x),unitWidth,portLocations, startFreq, stopFreq, stepFreq, folderName, WorL); %builds netlist files for MOM
    runMOM(folderName); %calls MOM to run netlist files
    Sparams(:,:,:,x)=interpretCTItoSparam('proj.cti'); %interprets file to Matlab
    %if failure to open cti.... try one more time
    if(Sparams==-1)
        runMOM(folderName); %calls MOM to run netlist files
        Sparams(:,:,:,x)=interpretCTItoSparam('proj.cti'); %interprets file to Matlab
    end
    x=x+1;
end

end

