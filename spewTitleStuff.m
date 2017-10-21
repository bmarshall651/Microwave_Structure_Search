function [] = spewTitleStuff(sys, totalCycles, Sideal, weighting )
%spewTitlestuff summarizes basic information to the Command Window
%
% spewTitleStuff(sys, totalCycles, Sideal, weighting )
%
% This function just outputs the settings for the optimization.
%
% Inputs:
% sys = DOS or UNIX system
% totalCycles = total number of generations the optimizer will run
% Sideal = ideal scattering matrix to find
% weighting = how the cost function is weighted
%
% Examples:
% spewTitleStuff(0,20,[0 1; 1 0;], [1 1; 1 1;])
% UNIX system with 20 generations to find a microstrip using all S-params
% in the cost function

disp('=================================================');
disp('  Geometric Lens Optimizer for Microwaves (GLOM)  ');
disp('          Written by: Blake Marshall             ');
disp('       The Propagation Group at Georgia Tech     ');
disp('                  2016                           ');
disp('=================================================');
disp(' ');
disp(' ');
disp(['Search Mode: Non-Homogenous Sequential']);
disp(['Computer System: ', sys])
disp(' ');
disp(['Total Number of Full Cycles = ', num2str(totalCycles)]);
disp(' ');
disp('The goal S-parameter Matrix in Linear Complex:');
disp(Sideal(:,:,1));
disp(' ');
disp('Weighting Matrix for the Cost Analysis:');
disp(weighting(:,:,1));
disp(' ');
disp(' ');
disp('===============================================');
disp('===============================================');

end

