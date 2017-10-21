clear all;
clc;
close all;

%%
%%Constants
ER=3.66; %relative permittviity
TAND=0;%0.0127; %tangent delta losses
FREQ=5.8E9; %frequency of er and tand measurements
H=0.00017018; %6.7 mil %height of substrate in meters
%H=0.0015748; %62 mil
COND=5.7E7; %conductivity of metal in S/m

YAXISSYM=1;
XAXISSYM=1;
USEMAGINCOST=1;
USEPHASEINCOST=1;
DOS=1;
j=sqrt(-1);

%%
%%Parameters
WorL=DOS;

%%
%Geometry Paramters

xdimNumofCells=10;
ydimNumofCells=100;
unitWidth=0.37; %in mm 
%Hint: Make your unit width a 50Ohm trace width/n where n is an odd integer

yAxisSym=YAXISSYM;
xAxisSym=XAXISSYM;

percMetal=1;

%%
%Ports Parameters
% portLocations=[ceil(xdimNumofCells/4) 1; ...
%     ceil(3*xdimNumofCells/4) 1; ...
%     ceil(xdimNumofCells/4) ydimNumofCells; ...
%     ceil(3*xdimNumofCells/4) ydimNumofCells;]; %in matrix indicies
portLocations=[ceil(xdimNumofCells/2) 1; ...
    ceil(xdimNumofCells/2) ydimNumofCells;];
portWidth=1; %Make it odd
portEmptyBorderCells=4; %Make it even

%%
%%Solver Parameters
%Solver
startFreq=1;
stopFreq=10;
stepFreq=0.2;

optimizer='sequential';
homogenous=0;
coarseList=[2 2 2 1 1];
autoCoarseList=1; %coarseList starts at shorter side/8 then gets smaller
% it gets smaller if there are no changes from previous generation
randomizeMinors=0; %randomizes the minors in the list

mutRate=0;

%% Cost Parameters
%Cost
totalCycles=10;

startCostFreq=5.8;
stopCostFreq=5.8;

Sideal=repmat([0 1*exp(-j*pi/2); ...
    1*exp(-j*pi/2) 0;],...
    [1 1 floor((stopFreq-startFreq)/stepFreq)+1]);
weighting=[0 1; ...
    0 0;];

useMagCost=USEMAGINCOST;
usePhaseCost=USEPHASEINCOST;

% Sideal=repmat([0 0 -j/sqrt(2) -1/sqrt(2); ...
%     0 0 -1/sqrt(2) -j/sqrt(2); ...
%     -j/sqrt(2) -1/sqrt(2) 0 0; ...
%     -1/sqrt(2) -j/sqrt(2) 0 0;],...
%     [1 1 floor((stopFreq-startFreq)/stepFreq)+1]);
% weighting=[1 1 1 1; ...
%     1 1 1 1; ...
%     1 1 1 1; ...
%     1 1 1 1;];

%%
%%Set up final paramters
%Set up a few other paramters
freqRange=startFreq:stepFreq:stopFreq;

%Sets up slash for DOS or UNIX
if(WorL==1)
    slash='\';
    sys='DOS';
else
    slash='/';
    sys='UNIX';
end


%% Begin Optimizer

spewTitleStuff(sys, totalCycles, Sideal, weighting );

%Generate the substrate file .ltd
generateSubstrate_ltdFile(ER, TAND, FREQ, H, COND, ...
    [pwd, slash, 'proj.ltd']);

[portMinors, portMetalOrAir]=getPortMinors(portLocations, portWidth, ...
    xdimNumofCells, portEmptyBorderCells);
% myBestGuess=generateRandomMatrix(xdimNumofCells,ydimNumofCells, ...
%     portMinors, portMetalOrAir, portWidth, percMetal, ...
%     yAxisSym,xAxisSym); %100 metal
myBestGuess=zeros(xdimNumofCells,ydimNumofCells);
myBestGuess(floor(xdimNumofCells/2),1:ydimNumofCells)=...
    ones(1,ydimNumofCells);

drawLens(myBestGuess,unitWidth,portLocations, ...
    portWidth); %Draws figure of what the lens looks like
buildLensFiles(myBestGuess,unitWidth,portLocations, startFreq, ...
    stopFreq, stepFreq, pwd, WorL); %builds netlist files for MOM
runMOM(pwd); %calls MOM to run netlist files
Sparams(:,:,:,1)=interpretCTItoSparam('proj.cti'); %interprets cti to S-par

%Record Initial Data
porMatrix(:,:,1)=myBestGuess;
cost(1)=calculateSparamCost(Sparams, Sideal, freqRange, weighting, ...
    useMagCost, usePhaseCost, startCostFreq, stopCostFreq);

indOf58GHz=25; %hardcoded bc im lazy
curHistInd=1;
bestMag=abs(Sparams(:,:,indOf58GHz,curHistInd));
bestPhase=angle(Sparams(:,:,indOf58GHz,curHistInd));

disp(['Generation: ', num2str(0)])
disp(['Simulation: ', num2str(curHistInd)])
disp(['Best Cost: ', num2str(cost(curHistInd))])
disp('Best S-parameter Magnitude: ')
20*log10(abs(Sparams(:,:,indOf58GHz,curHistInd)))
disp('Best S-parameter Phase: ')
(180/pi)*angle(Sparams(:,:,indOf58GHz,curHistInd))


figure(2)
plot(freqRange,reshape(20.*log10(abs(Sparams(1,2,:))),size(Sparams,3),1,1), ...
    freqRange,reshape(20.*log10(abs(Sparams(1,1,:))),size(Sparams,3),1,1),'r--', ...
    'LineWidth', 2)
xlabel('Frequency (GHz)')
ylabel('dB')
legend('|S21|', '|S11|')
title('Control Simulation of Microstrip Magnitudes')

figure(3)
plot(freqRange,reshape((180/pi)*angle(Sparams(1,2,:)),size(Sparams,3),1,1), ...
    freqRange,reshape((180/pi)*angle(Sparams(1,1,:)),size(Sparams,3),1,1),'r--', ...
    'LineWidth', 2)
xlabel('Frequency (GHz)')
ylabel('Phase (deg)')
legend('ang(S21)', 'ang(S11)')
title('Control Simulation of Microstrip Phases')

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