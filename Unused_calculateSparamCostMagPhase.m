function [ magCost, phaseCost ] = calculateSparamCostMagPhase(Sactual, Sideal, weighting)
%calculateSparamCost calculates the weighted error of distance between each
%S-parameter
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 6, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param Sactual is the actual S-parameters in Real, Imaginary
%@param Sideal is the ideal S-parameters to be obtained in Mag, Phase
%format
%@param weighting is how heavily weighted each mag and phase S
%parameter is weighted: [1 1; 1 1; 1 1; 1 1;] would be equal weighting on
%all S-parameters of a 2 port network
%
%@return costValue is the calculated cost

diff=weighting.*(Sactual-Sideal); %finds the difference between S-parameters
sqerror=real(diff).^2+imag(diff).^2; %Finds square error for each S-param
magCost=sqrt(sum(sum(sum(sqerror)))); %Weights them and sums them up
phaseCost=sum(sum(sum(abs(acos(imag(diff)/real(diff))))));



end

