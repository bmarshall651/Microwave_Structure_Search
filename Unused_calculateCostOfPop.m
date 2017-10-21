function [ cost ] = calculateCostOfPop( SparamsOfPop, idealS, freq, weighting, useMagInCost, usePhaseInCost,  startCostFreq, stopCostFreq)
%calculateCostOfPop calculates the cost of every member of a population -
%see calculateSparamCost
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 6, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param SparamsOfPop are the S-params of each member
%@param idealS is the ideal S-parameters to be obtained
%@param weighting is how heavily weighted each real and imaginary S
%parameter is weighted: [1 1; 1 1; 1 1; 1 1;] would be equal weighting on
%all S-parameters of a 2 port network
%
%@return costs is a vector of all the costs of the population
x=1;
while(x<=size(SparamsOfPop,4))
    [cost(x)]=calculateSparamCost(SparamsOfPop(:,:,:,x),idealS, freq,weighting,useMagInCost, usePhaseInCost, startCostFreq, stopCostFreq);
    x=x+1;
end



end

