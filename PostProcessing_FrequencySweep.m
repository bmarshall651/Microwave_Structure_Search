clear all;
clc;
close all;


load THESIS_Best_90deg_Hybrid_04_02_2017.mat
%load THESIS_Hybrid_DoubleSym_Coarse_RnadAfterBadGen_2.mat %Sucks

%%
%%Solver Parameters
%Solver
startFreq=1; %Start frequency for simulation
stopFreq=10; %Stop frequency for simulation
stepFreq=0.1; %Step Frequency for simulation

% Sideal=repmat([0 1*exp(j*160*pi/180); ...
%     1*exp(j*160*pi/180) 0;],...
%     [1 1 floor((stopFreq-startFreq)/stepFreq)+1]);

% weighting=[0 1; ...
%     0 0;];

useMagCost=USEMAGINCOST;
usePhaseCost=USEPHASEINCOST;


freqRange=startFreq:stepFreq:stopFreq;


[aMinCost, aMinLoc]= min(cost);
    [ang0,mag0]=cart2pol(real(Sparams(:,:,2,aMinLoc)),imag(Sparams(:,:,2,aMinLoc)))
    angDeg_min=round(ang0*180/pi,2);
    magdB_min=round(20*log10(mag0),2);
    
%%Build Files
%Generate the substrate file .ltd
generateSubstrate_ltdFile(ER, TAND, FREQ, H, COND, ...
    [pwd, slash, 'proj.ltd']);

%Microstrip ONly
% myBestGuess=zeros(xdimNumofCells,ydimNumofCells);
% myBestGuess(ceil(xdimNumofCells/2)-1:ceil(xdimNumofCells/2)+1 ...
%     ,:)=ones(3,ydimNumofCells);

myBestGuess=porMatrix(:,:,aMinLoc);

figure(1)
subplot(311)
drawLens(myBestGuess,unitWidth,portLocations, ...
    portWidth); %Draws figure of what the lens looks like
buildLensFiles(myBestGuess,unitWidth,portLocations, startFreq, ...
    stopFreq, stepFreq, pwd, WorL); %builds netlist files for MOM
runMOM(pwd); %calls MOM to run netlist files
Sparams_freqSweep=interpretCTItoSparam('proj.cti'); %interprets cti to S-par

% figure(2)
% plot(indicies(:,1), cost, indicies(:,1), transpose(newGenerationIndex), 'k.') ...
%     %             indicies, magCost, 'r', ...
% %         indicies, phaseCost, 'g')
% title(['Generation ',num2str(x)]);
% %' Smag=', num2str(10*log10(abs(Sparams(1,:,2,curHistInd)))), ...
% %    ' Sphase=', num2str((180/pi)*(angle(Sparams(1,:,2,curHistInd))))]);
% %legend('cost','magCost','phaseCost');
% 
% xlabel('Simulations')
% ylabel('Cost');
% legend('Cost', 'New Generation','Location','Southwest');
% 
% 
% figure(3)
% plot(elementSizeHistory)
% title('element size history')
% xlabel('Simulations')
% ylabel('Element Flipped Size q-by-q');
% drawnow
% 
% 
% %         figure(4)
% %            title(['gen=',num2str(x), ' Smag=', num2str(10*log10(abs(Sparams(1,:,2,curHistInd)))), ...
% %             ' Sphase=', num2str((180/pi)*(angle(Sparams(1,:,2,curHistInd))))]);
% 
% %         figure(6)
% % M11=linspace(0,1,100);
% % P11=linspace(0,pi,100);
% % [M21,P21]=meshgrid(M11,P11);
% %         s=surf(M21,P21,costPlot)
% %         alpha(s,0.3)
% %         hold on;
% %         scatter3(abs(Sparams(1,2,2,:)), angle(Sparams(1,2,2,:)), cost(:), 'rx')
% %         hold off;
% %         xlabel('Magnitude S21');
% %         ylabel('Phase S21');
% %         title('Surface using Sdiff=S-Sideal sqrt(Sdiff*conj(Sdiff))');
% %         drawnow
% 
% %         bestMag=abs(Sparams(:,:,:,curHistInd));
% %         bestPhase=angle(Sparams(:,:,:,curHistInd));
% minorCount=minorCount+1;
% 
% disp(['Generation: ', num2str(x)])
% disp(['Simulation: ', num2str(curHistInd)])
% disp(['Best Cost: ', num2str(cost(curHistInd))])
% disp('Best S-parameter Magnitude: ')
% 20*log10(abs(Sparams(:,:,floor((stopFreq-startFreq)/stepFreq)+1,curHistInd)))
% disp('Best S-parameter Phase: ')
% (180/pi)*angle(Sparams(:,:,floor((stopFreq-startFreq)/stepFreq)+1,curHistInd))

%figure(4)
subplot(312)
 plot(freqRange,reshape(20*log10(abs(Sparams_freqSweep(1,1,:))),[1,length(freqRange)]), ...
freqRange,reshape(20*log10(abs(Sparams_freqSweep(1,2,:))),[1,length(freqRange)]), ...
freqRange,reshape(20*log10(abs(Sparams_freqSweep(1,3,:))),[1,length(freqRange)]), ...
freqRange,reshape(20*log10(abs(Sparams_freqSweep(1,4,:))),[1,length(freqRange)]))
clear title xlabel ylabel
title('Frequency Response of S-parameters')
legend('S11','S12','S13','S14')
xlabel('Frequency (GHz)')
ylabel('dB')

subplot(313)
 plot(freqRange,reshape(180/pi*angle(Sparams_freqSweep(1,1,:)),[1,length(freqRange)]), ...
freqRange,reshape(180/pi*angle(Sparams_freqSweep(1,2,:)),[1,length(freqRange)]), ...
freqRange,reshape(180/pi*angle(Sparams_freqSweep(1,3,:)),[1,length(freqRange)]), ...
freqRange,reshape(180/pi*angle(Sparams_freqSweep(1,4,:)),[1,length(freqRange)]))
clear title xlabel ylabel
title('Frequency Response of S-parameters')
legend('S11','S12','S13','S14')
xlabel('Frequency (GHz)')
ylabel('Angle (deg)')



% figure(3)
% plot(freqRange,squeeze(abs(bestSparams(1,1,:))),freqRange, squeeze(abs(Sparams(2,1,:))));
%buildLensFiles(lensMatrix1, unit, portLocations,5,7,0.1, pwd);
%generateFarFieldParams_vplFile(5.8, portLocations, 1, 50, [pwd, '\', 'proj.vpl']);

% figure(1)
% drawLens(lensMatrix1,unit, portLocations);
%runMOM(pwd);
%S=interpretSingleFreqCTI('proj.cti');
% generateFarFieldParams_vplFile(5.8, portLocations, 1, 50, [pwd, '\', 'proj.vpl']);
% runFarField(pwd);
% [ Efield_theta, Efield_phi, EthetaMax, EphiMax, THETA, PHI]=interpretFFFtoFarField('proj.fff','proj.ant');
% figure(2)
% plot3DPattern(sqrt(abs(Efield_phi).^2+abs(Efield_theta).^2),THETA,PHI)


%  figure(2)
%  plot(linspace(5,7,21),reshape(20*log10(abs(S(1,1,:))),1,21))
%  hold on;
%  plot(linspace(5,7,21),reshape(20*log10(abs(S(2,1,:))),1,21),'r-')
%  hold off;
%  legend('S11', 'S21');
%  xlabel('Frequency (GHz)');
%  ylabel('dB');
% title('S-parameters of Microstrip using Matlab-ADS Co-simulation');
% generateFarFieldParams_vplFile(5.8, portLocations, 2, 50, [pwd, '\', 'proj.vpl']);
% runFarField(pwd);
% [ Efield_theta2, Efield_phi2, EthetaMax2, EphiMax2, THETA2, PHI2]=interpretFFFtoFarField('proj.fff','proj.ant');
% figure(3)
% plot3DPattern(sqrt(abs(Efield_phi2).^2+abs(Efield_theta2).^2),THETA2,PHI2)