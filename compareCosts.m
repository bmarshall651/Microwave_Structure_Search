function [ porMatrix, Sparams, cost, genChange ] = compareCosts( porMatrix, Sparams, ...
    cost, myNextGuess, tempSparams, tempCost,  curHistInd, randRate, ...
    genChange, totalMinors)
%compareCosts decides whether or not to use the new matrix evaluated or
%keep the previous matrix
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: Feburary 26, 2017
%The Propagation Group at Georgia Institute of Technology
%
%@param porMatrix
%@param Sparams
%@param cost
%@param myNextGuess
%@param tempSparams
%@param tempCost
%@param curHistInd
%@param randRate
%@param genChange
%@param totalMinors
%
%@return porMatrix is the calculated cost
%@return Sparams is the calculated cost
%@return cost is the calculated cost
%@return genChange is the calculated cost

if tempCost < cost(curHistInd-1) %|| rand()<randRate
    porMatrix(:,:,curHistInd)=myNextGuess;
    Sparams(:,:,:,curHistInd)=tempSparams;
    cost(curHistInd)=tempCost;
    genChange=1;
%Added to try to jumpstart local extrema
elseif 2*totalMinors<size(cost,2)
    if sum(abs(cost(size(cost,2))-cost(1,size(cost,2)-2*totalMinors: ...
            size(cost,2))))<0.001 && tempCost < max(cost)
        porMatrix(:,:,curHistInd)=myNextGuess;
        Sparams(:,:,:,curHistInd)=tempSparams;
        cost(curHistInd)=tempCost;
    else
        porMatrix(:,:,curHistInd)= porMatrix(:,:,curHistInd-1);
        Sparams(:,:,:,curHistInd)=Sparams(:,:,:,curHistInd-1);
        cost(curHistInd)=cost(curHistInd-1);
    end
else
    porMatrix(:,:,curHistInd)= porMatrix(:,:,curHistInd-1);
    Sparams(:,:,:,curHistInd)=Sparams(:,:,:,curHistInd-1);
    cost(curHistInd)=cost(curHistInd-1);
end

end

