function [ randomMatrix ] = generateRandomMatrix(M,N, portMinors, portMetalOrAir, percMetal, symAboutY, symAboutX)
%generateRandomMatrix creates a random binary MxN matrix and ensures that
%there is  1 at each port location.
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 6, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param M is the number of rows
%@param N is the number of columns
%@param portLocations is the location of all the ports listed as: [x1 y1; x2
%y2; x3 y3;]
%
%@return randomMatrix is the resulting binary MxN matrix

%Creates random matrix of values then rounds them to 1 or 0

disp('Creating the metal and airs structure...');

if(symAboutY~=1 && symAboutX~=1)
    a=rand(M,N)<percMetal;
elseif (symAboutY~=1 && symAboutX==1)
    ta=rand(M/2,N)<percMetal;
    a(1:M/2,1:N)=ta;
    a(M/2+1:M,1:N)=flipud(ta);
elseif  (symAboutY==1 && symAboutX~=1)
    ta=rand(M,N/2)<percMetal;
    a(1:M,1:N/2)=ta;
    a(1:M,N/2+1:N)=fliplr(ta);
elseif (symAboutY==1 && symAboutX==1)
    ta=rand(M/2,N/2)<percMetal;
    a(1:M/2,1:N/2)=ta;
    a(M/2+1:M,1:N/2)=flipud(ta);
    a(1:M/2,N/2+1:N)=fliplr(ta);
    a(M/2+1:M,N/2+1:N)=rot90(ta,2);
else
    a=rand(M,N)<percMetal;
end

randomMatrix=adjustLensForPorts(a,portMinors,portMetalOrAir);

end

