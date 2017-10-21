function [ newPop] = survival(oldPop, killPercent, costs)
%SURVIVAL kills off a certain percenatage of weaklings in your population,
%so only the strong can reproduce.
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 6, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param oldPop is the original population. It is a MxNxnumOfCitizens binary
%matrix where 1 is metal and 0 is non-metal.
%@param killPercent is the percent of the population to be killed.
%@param costs is the cost of each citizen. Higher costs die off.
%
%@return newPop is of the same form as oldPop without the weak members

%Calculate number of survivors
totalSurvival=floor(size(oldPop,3)*(1-killPercent));

%Find lowest cost and index of lowest costs
x=1;

[lowest,lowIndex]=min(costs); %Minimum cost for magnitude only

%Repeat for all spots in new popuation
while(x<=totalSurvival)
    newPop(:,:,x)=oldPop(:,:,lowIndex); %Add lowest cost to new population
    oldPop(:,:,lowIndex)=zeros(size(oldPop,1),size(oldPop,2));
    costs(lowIndex)=NaN; %set cost of lowest to NaN to find next lowest
    
    [lowest,lowIndex]=min(costs);
    
    x=x+1;
end

end

