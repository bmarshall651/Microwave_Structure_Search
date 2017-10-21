function [ matr ] = drawLens( inputMatrix, unitWidth, portLocations, portWidth )
%drawLens converts the binary matrix to a bitmap of black for metal, white
%for non-metal, and red for ports (with metal)
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 6, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param inputMatrix MxN binary matrix for metal and non metal
%@param unitWidth is the geometric length and width of each cell in
%@param portLocations is the location of all the ports listed as: [x1 y1; x2
%y2; x3 y3;]
%@param portWidth is the width of the ports in number of cells
%
%@return matr is the bitmap of the matrix

disp('Drawing the metal and air geom...')

matr=~repmat(inputMatrix,[1,1,3]);

temp1=1;
test(1,1,:)=[1 0 0];
while temp1 <= size(portLocations,1)
    matr(portLocations(temp1,1)-floor(portWidth/2):portLocations(temp1,1)+floor(portWidth/2),portLocations(temp1,2),:)=repmat(test,portWidth,1,1);
    temp1=temp1+1;
end

colorize=-0.5*(matr-ones(size(matr,1),size(matr,2),size(matr,3)));
matr=matr+colorize;

figure(1)
image([0 unitWidth*size(inputMatrix,2)], [0 unitWidth*size(inputMatrix,1) 
    ], matr)
pbaspect([size(inputMatrix,2) size(inputMatrix,1) 1])
title(['Top Layer Geometry: Gray=metal, White=air, Pink=port, unitCell=',num2str(unitWidth),'mm']);
%grid on;
%grid on;
xlabel('x-dimension (mm)');
ylabel('y-dimension (mm)');



    

end

