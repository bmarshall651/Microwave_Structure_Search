function [ matrix ] = buildPopulation( initialPopulationSize, M, N, portMinors, portWidth, percMetal, yaxisSym, xaxisSym)
%buildPopulation creates a population of binary matrices of given size and
%dimensions and port locations
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 6, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param initalPopulationSize is the number of members
%@param M is the number of rows
%@param N is the number of colums
%@param portLocations is the location of all the ports listed as: [x1 y1; x2
%y2; x3 y3;]
%
%@return matrix is MxNxinitalPopSize of the binary matrices
x=1;

while(x<=initialPopulationSize)
    matrix(:,:,x)=generateRandomMatrix(M,N, portMinors, portWidth, percMetal,yaxisSym,xaxisSym);
    x=x+1;
end

end

