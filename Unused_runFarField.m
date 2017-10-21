function [ ] = runFarField(folderPath)
%runMOM calls on Agilent ADS Momentum S-parameters from netlists in the
%folderPath directory
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 6, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param folderPath directory to run in -- seems to only work in current
%directory (pwd)


system(['cd ' folderPath]);
% system(['MomEngine -T --objMode=MW proj proj']);
% system(['MomEngine -DB --objMode=MW proj proj']);
% system(['MomEngine -M --objMode=MW proj proj']);
%system(['MomEngine -O -3D --objMode=MW proj proj:']);
system(['MomEngine -FF proj proj']);
end

