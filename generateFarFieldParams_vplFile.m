function [ outputVplFile ] = generateFarFieldParams_vplFile( frequency, portLocations, portExcitationNumber, PortImpedances, outputVplFile)
%generateFarFieldParams_vpl file for Agilent ADS Momentum simulation
%Agilent ADS
%Author: Blake Marshall
%June 28, 2014
%frequency: frequency for far field post-processing... must be within and
%calculated in s-parameter simulation
%portLocations: locations of all the ports
%portExcitationNumber: which port is being excited by 1V phase=0
%PortImpedances: complex value for the impedances of all the ports
%outputVplFile: output file for Agilent ADS to simulate FarField
fOut = fopen(outputVplFile, 'wt');

fprintf(fOut, 'CLIP -50; \n');
fprintf(fOut, '\n');
fprintf(fOut, 'COPOLARANGLE 0 DEG; \n');
fprintf(fOut, '\n');
fprintf(fOut, 'VISUALIZATIONTYPE 1; \n');
fprintf(fOut, '\n');
fprintf(fOut, 'PARAMETER FREQUENCY, \n');
fprintf(fOut, 'UNITS GHz, \n');
fprintf(fOut, ['PT ',num2str(frequency),'; \n']);
fprintf(fOut, '\n');
fprintf(fOut, 'PARAMETER PHI, \n');
fprintf(fOut, 'UNITS DEG, \n');
fprintf(fOut, 'PT 0; \n');
fprintf(fOut, '\n');
fprintf(fOut, 'VAR THETA, \n');
fprintf(fOut, 'UNITS DEG, \n');
fprintf(fOut, 'START -180 STOP 180; \n');
fprintf(fOut, '\n');

numOfPorts=size(portLocations,1);
x=1;

while(x<=numOfPorts)
    fprintf(fOut, ['PORT ', num2str(x),', \n']);
    fprintf(fOut, 'UNITS VOLT, \n');
    fprintf(fOut, 'UNITS DEG, \n');
    if(portExcitationNumber==x)
        fprintf(fOut, 'AMPLITUDE 1 PHASE 0, \n');
    else
        fprintf(fOut, 'AMPLITUDE 0 PHASE 0, \n');
    end
    fprintf(fOut, 'UNITS OHM, \n');
    fprintf(fOut, 'UNITS RAD, \n');
    fprintf(fOut, ['AMPLITUDE ',num2str(sqrt(real(PortImpedances)^2 ...
        +imag(PortImpedances)^2)),' PHASE ',num2str(atan(imag(PortImpedances)...
        /real(PortImpedances))),'; \n']);
    fprintf(fOut, '\n');
    x=x+1;
end



fclose(fOut);
end

