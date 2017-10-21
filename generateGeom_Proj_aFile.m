function [ outputProj_aFile ] = generateGeom_Proj_aFile( matrix, unitWidth, outputProj_aFile)
%generateGeom_Proj_aFile creates proj_a file for Agilent ADS Momentum simulation
%Agilent ADS
%Author: Blake Marshall
%June 28, 2014
%matrix: binary matrix of where copper is (1) and where it is not (0)
%unitWidth: width of each square of copper or non-copper
%outputProj_aFile: output file 
fOut = fopen(outputProj_aFile, 'wt');

fprintf(fOut, 'UNITS MM,10000; \n');
fprintf(fOut, 'EDIT proj; \n');

[rows,cols]=size(matrix);
x=1;
y=1;
while(x<=rows)
    while(y<=cols)
        if(matrix(x,y)==1)
            fprintf(fOut, ['ADD P1 :W0.000000 ', num2str((y-1)*unitWidth) ...
            , ',' , num2str((rows-(x))*unitWidth) , ' ', num2str((y)*unitWidth) ...
            , ',' , num2str((rows-(x))*unitWidth) , ' ', num2str((y)*unitWidth) ...
            , ',' , num2str((rows-(x-1))*unitWidth) , ' ', num2str((y-1)*unitWidth) ...
            , ',' , num2str((rows-(x-1))*unitWidth) , ';' ,' \n']);
        end
        y=y+1;
    end
    y=1;
    x=x+1;
end

fprintf(fOut, 'SAVE; \n');

fclose(fOut);

disp('Geometry proj_a File Complete')
end

