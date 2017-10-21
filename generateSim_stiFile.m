function [ output_args ] = generateSim_stiFile( startFreqGiga, stopFreqGiga, stepSize, outputProj_sti )
%generateSubstrate_stiFile creates sti file for momentum simulation in
%Agilent ADS
%Author: Blake Marshall
%June 28, 2014

fOut = fopen(outputProj_sti, 'wt');

%fprintf(fOut, ['START          ',num2str(startFreqGiga),' STOP         ', ...
%    num2str(stopFreqGiga),' STEP         ',num2str(numOfSteps),', \n']);
%fprintf(fOut,'AFS S_50 MAXSAMPLES 50 SAMPLING ALL NORMAL \n');
if(startFreqGiga==stopFreqGiga)
    fprintf(fOut,'PT        5.8, \n');
    fprintf(fOut,';');
elseif startFreqGiga < stopFreqGiga
    fprintf(fOut,['START ', num2str(startFreqGiga),' STOP ', ...
        num2str(stopFreqGiga), ' STEP ', num2str(stepSize), '\n']);
    fprintf(fOut,';');
else startFreqGiga > stopFreqGiga
    disp('Start and Stop Freq Inverted');
end

fclose(fOut);

disp('Simulation Freq .sti File Complete')
end


