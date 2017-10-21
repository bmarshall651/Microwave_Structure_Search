function [ cost ] = calculateSparamCost(Sactual, Sideal, freq, weighting, useMagInCost, usePhaseInCost, startCostFreq, stopCostFreq)
%calculateSparamCost calculates the weighted error of distance between each
%S-parameter
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 6, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param Sactual is the actual S-parameters
%@param Sideal is the ideal S-parameters to be obtained
%@param weighting is how heavily weighted each real and imaginary S
%parameter is weighted: [1 1; 1 1; 1 1; 1 1;] would be equal weighting on
%all S-parameters of a 2 port network
%
%@return costValue is the calculated cost

disp('Calculating the cost of the S-params')

[messa, a]=min(abs(freq-startCostFreq));
[messb, b]=min(abs(freq-stopCostFreq));
W=repmat(weighting,[1,1,b-a+1]);

%magDiff=abs(W.*abs(Sactual(:,:,a:b))-abs(Sideal(:,:,a:b))); %finds the difference between S-parameters
%phaseDiff=abs(W.*angle(Sactual(:,:,a:b))-angle(Sideal(:,:,a:b)));

% magDiff=abs(W.*abs(Sactual(:,:,a:b))-abs(Sideal(:,:,a:b))); %finds the difference between S-parameters
% phaseDiff=abs(W.*angle(Sactual(:,:,a:b))-angle(Sideal(:,:,a:b)));

% phaseDiff1=abs(angle(Sactual(1,3,a:b))-angle(Sactual(1,4,a:b))- ...
%     (angle(Sideal(1,3,a:b))-angle(Sideal(1,4,a:b))));
% phaseDiff2=abs(angle(Sactual(2,3,a:b))-angle(Sactual(2,4,a:b))- ...
%     (angle(Sideal(2,3,a:b))-angle(Sideal(2,4,a:b))));
% phaseDiff3=abs(angle(Sactual(1,3,a:b))-angle(Sactual(2,3,a:b))- ...
%     (angle(Sideal(1,3,a:b))-angle(Sideal(2,3,a:b))));
% phaseDiff4=abs(angle(Sactual(1,4,a:b))-angle(Sactual(2,4,a:b))- ...
%     (angle(Sideal(1,4,a:b))-angle(Sideal(2,4,a:b))));
% phaseDiff=phaseDiff1+phaseDiff2+phaseDiff3+phaseDiff4;

% if(useMagInCost==1 && usePhaseInCost==0)
%     avgNormCostValue=100*sum(sum(sum(magDiff)))/(b-a+1) ...
%         /(size(Sideal,2)^2);
%      avgNormMagCostValue=0;
%     avgNormPhaseCostValue=0;
% elseif(useMagInCost==0&&usePhaseInCost==1)
%     avgNormCostValue=100*sum(sum(sum(phaseDiff)))/(b-a+1) ...
%         /(size(Sideal,2)^2);
%     avgNormMagCostValue=0;
%     avgNormPhaseCostValue=0;
%elseif(useMagInCost==1&&usePhaseInCost==1)
    Scost=W.*(Sactual(:,:,a:b)-Sideal(:,:,a:b));
   magnitized=sqrt(Scost.*conj(Scost));
  cost=sum(sum(sum(magnitized(:,:,:))))/(b-a+1);
    
%     avgNormMagCostValue=1.2*sum(sum(sum(magDiff)))/(b-a+1) ...
%         /(size(Sideal,2)^2);
%    avgNormPhaseCostValue=1*sum(sum(sum(phaseDiff)))/(b-a+1) ...
%        /(size(Sideal,2)^2);
% %    avgNormPhaseCostValue=100*sum(phaseDiff)/(b-a+1) ...
% %         /pi;
%     avgNormCostValue=(avgNormMagCostValue+avgNormPhaseCostValue)/2;
% else
%     disp('Error - Must use either magnitude or phase for cost function');
%      avgNormMagCostValue=0;
%     avgNormPhaseCostValue=0;
% end

end

