clear all;
clc;

%load THESIS_Microstrip_1Cost_Sym_Rand.mat;
%load THESIS_Microstrip.mat;
%load THESIS_Hybrid_DoubleSym_Coarse_RnadAfterBadGen_2.mat
%load THESISNO_Hybrid_DoubleSym_RandAfterBadGen.mat
load 'Data Sets/THESIS_Best_90deg_Hybrid_04_02_2017.mat';

disp('PARAMETERS')
disp(['xdimNumofCells: ', num2str(xdimNumofCells)])
disp(['ydimNumofCells: ', num2str(ydimNumofCells)])
disp(['unitCell: ', num2str(unitWidth), ' mm'])
disp(['xAxisSym: ', num2str(xAxisSym)])
disp(['yAxisSym: ', num2str(yAxisSym)])
disp(['Frequencies: ', num2str(freqRange)])


disp('CONSTANTS')
disp(['Rel Perm: ', num2str(ER)])
disp(['Subst. Height.: ', num2str(H), ' m'])
disp(['Tan delta: ', num2str(TAND)])

disp('OPTIMIZATION')
disp(['coarseList: ', num2str(coarseList)])
disp(['generations: ', num2str(totalCycles)])
disp(['start cost freq: ', num2str(startFreq), ' GHz'])
disp(['stop cost freq: ', num2str(stopFreq), ' GHz'])
disp(['etch only: ' , num2str(etchingOnly)])
disp(['cost weighting matrix: '])
weighting
disp(['ideal S-matrix: '])
[a,b]=min(cost);
myNextGuess=porMatrix(:,:,b);





figure(1)
drawLens(myNextGuess,unitWidth, portLocations, portWidth);

figure(2)
plot(indicies(:,1), cost, indicies(:,1), transpose(newGenerationIndex), 'k.') ...
    %             indicies, magCost, 'r', ...
%         indicies, phaseCost, 'g')
title(['Cost Value Versus Simulations Run - Generation ',num2str(x)]);
%' Smag=', num2str(10*log10(abs(Sparams(1,:,2,curHistInd)))), ...
%    ' Sphase=', num2str((180/pi)*(angle(Sparams(1,:,2,curHistInd))))]);
%legend('cost','magCost','phaseCost');

xlabel('Simulations')
ylabel('Cost');
legend('Cost', 'New Generation');


figure(3)
newGenIndexElements=(transpose(newGenerationIndex) > ...
    zeros(size(newGenerationIndex,2),size(newGenerationIndex,1))).* ...
    transpose(elementSizeHistory);
plot(indicies(:,1), elementSizeHistory, indicies(:,1),newGenIndexElements, 'k.')
title('Coarse Element Size Versus Simulation')
xlabel('Simulations')
ylabel('q (Elements Flipped Size q-by-q Unit Cells)');
legend('q', 'New Generation');
drawnow

disp(['Generation: ', num2str(x)])
disp(['Simulation: ', num2str(curHistInd-1)])
disp(['Best Cost: ', num2str(cost(curHistInd-1))])
disp('Best S-parameter Magnitude: ')
20*log10(abs(Sparams(:,:,floor((stopFreq-startFreq)/stepFreq)+1,curHistInd-1)))
disp('Best S-parameter Phase: ')
(180/pi)*angle(Sparams(:,:,floor((stopFreq-startFreq)/stepFreq)+1,curHistInd-1))




min(cost)




figure(4)


j=sqrt(-1);

M21=linspace(0,1,100);
P21=linspace(0,2*pi,100);

[M21,P21]=meshgrid(M21,P21);

for ind=1:size(M21,1)*size(M21,2)
    S(:,:,ind)=[sqrt(1-M21(ind)^2) M21(ind).*exp(j*P21(ind)); M21(ind).*exp(j*P21(ind)) sqrt(1-M21(ind)^2);];
    Sn=S(:,:,ind);
    
    %     %     Sh=ctranspose(S(:,:,ind));
    %     %    Scost=(Sn*Sh-eye(2));
    
    Scost=[1 1; 1 1;].*(Sn-[0 exp(j*160*pi/180); exp(j*160*pi/180) 0;]);
    magnitized=sqrt(Scost.*conj(Scost));
    costplot(ind)=sum(sum(magnitized));
end

costPlot=reshape(costplot,size(M21,1),size(M21,2));

s=surf(M21,P21,costPlot)
alpha(s,0.3)
hold on;
p7=scatter3(abs(Sparams(1,2,2,:)), angle(Sparams(1,2,2,:)), cost(:), 'rx')
hold off;
xlabel('|S21|');
ylabel('Ang(S21) rad');
title('Cost Surface versus S21 Magnitude and Phase');
zlabel('Cost');
legend([p7],{'Actual Microtrip Optimzation'},'Location','Northwest');

