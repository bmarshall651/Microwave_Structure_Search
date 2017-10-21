function [ newPopulation, prevCosts ] = buildNewGeneration( pop, Sparams, Sideal, freq, costWeighting, killPercent, mutationPercent, portLocations, yaxisSym, xaxisSym, useMagInCost, usePhaseInCost, startCostFreq, stopCostFreq)
%buildNewGeneration creates a new generation including old surviving
%parents and new children
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 6, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param pop is the previous population used MxNxpopSize matrix
%@param Sparams is the S-paramters of each member
%@param Sideal is the ideal S-parameters for a member
%@param costWeighting is the weighting on each S-paramter in the form of
%mag and phase of each starting with S11, S12,... S21, S22... [mag phase;
%magphase;]
%@param killPercent is the percent of the population to be killed.
%@param mutationPercent is the percent of matrices cells that may randomly
%being negated
%@param portLocations is the location of all the ports listed as: [x1 y1; x2
%y2; x3 y3;]
%
%@return newPopulation is MxNxPopSize of the binary matrices of old parents
%and children
[prevCosts]=calculateCostOfPop(Sparams,Sideal,freq,costWeighting, useMagInCost, usePhaseInCost, startCostFreq, stopCostFreq); %calculate the cost of each member
survivingPop=survival(pop,killPercent,prevCosts); %kill the weak ones
newPopulation=survivingPop; %move the old to the newPopulation

%strong mate with eachother and add to new population untill full
while(size(newPopulation,3)<size(pop,3))
    newPopulation(:,:,size(newPopulation,3)+1)=reproduce(survivingPop, mutationPercent, portLocations, yaxisSym, xaxisSym);
end

end

