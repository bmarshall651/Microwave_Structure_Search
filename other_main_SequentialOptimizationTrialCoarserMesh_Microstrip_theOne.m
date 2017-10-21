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

xdimNumofCells=50;
ydimNumofCells=150;
unitWidth=0.113; %in mm 
%Hint: Make your unit width a 50Ohm trace width/n where n is an odd integer

yAxisSym=YAXISSYM;
xAxisSym=~XAXISSYM;

percMetal=1;

%%
%Ports Parameters
% portLocations=[ceil(xdimNumofCells/4) 1; ...s
%     ceil(3*xdimNumofCells/4) 1; ...
%     ceil(xdimNumofCells/4) ydimNumofCells; ...
%     ceil(3*xdimNumofCells/4) ydimNumofCells;]; %in matrix indicies
portLocations=[ceil(xdimNumofCells/2) 1; ...
    ceil(xdimNumofCells/2) ydimNumofCells;];
portWidth=3; %Make it odd
portEmptyBorderCells=20; %Make it even
%portWidth=1; %Make it odd
%portEmptyBorderCells=2; %Make it even

%%
%%Solver Parameters
%Solver
startFreq=5.6;
stopFreq=6.0;
stepFreq=0.2;

optimizer='sequential';
homogenous=0;
%coarseList=1;
coarseList=[10 10 10 5 5 5 2 2 2 1];
%coarseList=2;
autoCoarseList=0; %coarseList starts at shorter side/8 then gets smaller
% it gets smaller if there are no changes from previous generation
randomizeMinors=1; %randomizes the minors in the list
mutRate=0;
etchingOnly=0;

%% Cost Parameters
%Cost
totalCycles=10;

startCostFreq=5.8;
stopCostFreq=5.8;

Sideal=repmat([0 1*exp(j*160*pi/180); ...
    1*exp(j*160*pi/180) 0;],...
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
myBestGuess=generateRandomMatrix(xdimNumofCells,ydimNumofCells, ...
    portMinors, portMetalOrAir, portWidth, percMetal, ...
    yAxisSym,xAxisSym); %100 metal
%Microstrip ONly
% myBestGuess=zeros(xdimNumofCells,ydimNumofCells);
% myBestGuess(ceil(xdimNumofCells/2)-1:ceil(xdimNumofCells/2)+1 ...
%     ,:)=ones(3,ydimNumofCells);

drawLens(myBestGuess,unitWidth,portLocations, ...
    portWidth); %Draws figure of what the lens looks like
buildLensFiles(myBestGuess,unitWidth,portLocations, startFreq, ...
    stopFreq, stepFreq, pwd, WorL); %builds netlist files for MOM
runMOM(pwd); %calls MOM to run netlist files
Sparams(:,:,:,1)=interpretCTItoSparam('proj.cti'); %interprets cti to S-par

%Record Initial Data
porMatrix(:,:,1)=myBestGuess;
cost(1)=calculateSparamCost(Sparams, Sideal, freqRange, weighting, ...
    useMagCost, usePhaseCost, startCostFreq, stopCostFreq)

%%Begin the interations
x=1;
curHistInd=1;
indicies(curHistInd)=1;
coarseness=0;
genChange=1;
tic;

while(x<=totalCycles)
  
    %Finds all minors for symmetry and coarser gene groups
    [myMinorList, coarseness] = getCoarseGridMinors(ydimNumofCells,xdimNumofCells, ...
        coarseList, xAxisSym, yAxisSym, randomizeMinors, genChange, ...
        autoCoarseList, x,totalCycles, coarseness, homogenous);
    
    %Starts the pass through
    minorCount=1;
    genChange=0;
    while(minorCount<=size(myMinorList,1))
        tStart=tic;
        curHistInd=curHistInd+1;
        if sum(ismember(myMinorList(minorCount,:), portMinors))==0 %Check that a port is not included in minors
            myNextGuess=porMatrix(:,:,curHistInd-1);
            % if sum(sum(myNextGuess(myMinorList(minorCount,:))))>=1 %Check if atleast one cell is metal
            myNextGuess(myMinorList(minorCount,:))=~myNextGuess(myMinorList(minorCount,:)); %Flip metal to non-metal
            drawLens(myNextGuess,unitWidth, portLocations, portWidth);
            buildLensFiles(myNextGuess,unitWidth,portLocations, startFreq, ...
                stopFreq, stepFreq, pwd, WorL); %builds netlist files for MOM
            runMOM(pwd); %calls MOM to run netlist files
            tempSparams=interpretCTItoSparam('proj.cti'); %interprets file to Matlab
            while tempSparams == -1
                runMOM(pwd);
                tempSparams=interpretCTItoSparam('proj.cti'); %interprets file to Matlab
                disp(['!!!!!!!!!!!!!Stuck on Minor:', num2str(minorCount), '!!!!!!!!!!'])
            end
            [tempCost]=calculateSparamCost(tempSparams, Sideal, freqRange, weighting, ...
                useMagCost, usePhaseCost, startCostFreq, stopCostFreq);
        else
            tempCost=100000;
            myNextGuess=porMatrix(:,:,curHistInd-1);
            tempSparams=Sparams(:,:,:,curHistInd-1);
        end
        
        [porMatrix, Sparams, cost, genChange] = compareCosts(porMatrix, Sparams, ...
            cost, myNextGuess, tempSparams, tempCost,  curHistInd, mutRate, genChange);
        
        elementSizeHistory(curHistInd)=coarseList(floor(size(coarseList,2)*(x/totalCycles))+1);
        timeHistory(curHistInd)=toc(tStart);
        indicies(curHistInd,1)=curHistInd; %curHistInd
        indicies(curHistInd,2)=x; %generation
        if curHistInd > 1
            newGenerationIndex(curHistInd)=(x-indicies(curHistInd-1,2));
            newGenerationIndex(curHistInd)=newGenerationIndex(curHistInd).*cost(curHistInd);
        end
        
        if mod(curHistInd,10)==1
            save temp.mat;
        end
        
        figure(2)
        plot(indicies(:,1), cost, indicies(:,1), transpose(newGenerationIndex), 'k.') ...
%             indicies, magCost, 'r', ...
%         indicies, phaseCost, 'g')
        title(['Generation ',num2str(x)]);
        %' Smag=', num2str(10*log10(abs(Sparams(1,:,2,curHistInd)))), ...
        %    ' Sphase=', num2str((180/pi)*(angle(Sparams(1,:,2,curHistInd))))]);
        %legend('cost','magCost','phaseCost');
     
        xlabel('Simulations')
        ylabel('Cost');
        legend('Cost', 'New Generation');
    
        
        figure(3)
        plot(elementSizeHistory)
        title('element size history')
        xlabel('Generation')
        ylabel('Element Flipped Size q-by-q');
        drawnow
        
%         figure(4)
%            title(['gen=',num2str(x), ' Smag=', num2str(10*log10(abs(Sparams(1,:,2,curHistInd)))), ...
%             ' Sphase=', num2str((180/pi)*(angle(Sparams(1,:,2,curHistInd))))]);
   
%         figure(6)
% M11=linspace(0,1,100);
% P11=linspace(0,pi,100);
% [M21,P21]=meshgrid(M11,P11);
%         s=surf(M21,P21,costPlot)
%         alpha(s,0.3)
%         hold on;
%         scatter3(abs(Sparams(1,2,2,:)), angle(Sparams(1,2,2,:)), cost(:), 'rx')
%         hold off;
%         xlabel('Magnitude S21');
%         ylabel('Phase S21');
%         title('Surface using Sdiff=S-Sideal sqrt(Sdiff*conj(Sdiff))');
%         drawnow
      
%         bestMag=abs(Sparams(:,:,:,curHistInd));
%         bestPhase=angle(Sparams(:,:,:,curHistInd));
        minorCount=minorCount+1;
        
        disp(['Generation: ', num2str(x)])
        disp(['Simulation: ', num2str(curHistInd)])
        disp(['Best Cost: ', num2str(cost(curHistInd))])
        disp('Best S-parameter Magnitude: ')
        10*log10(abs(Sparams(:,:,floor((stopFreq-startFreq)/stepFreq)+1,curHistInd)))
        disp('Best S-parameter Phase: ')
        (180/pi)*angle(Sparams(:,:,floor((stopFreq-startFreq)/stepFreq)+1,curHistInd))
    end
    
   
    
    x=x+1;
end



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