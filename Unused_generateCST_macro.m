function [ ] = generateCST_macro(matrix, locs, unitWidth, output_macroFile )
%generatePorts_pinFile creates the .pin file for Momentum simulation
%Agilent ADS
%Author: Blake Marshall
%June 28, 2014
%locs is Nx2 array of location of the ports in METERS
fOut = fopen(output_macroFile, 'wt');

fprintf(fOut, ''' TestMacro \n');
fprintf(fOut, '\n');
fprintf(fOut, 'Sub Main () \n');
fprintf(fOut, ''' Template For Antenna In Free Space\n');
fprintf(fOut, ''' ==================================\n');
fprintf(fOut, '\n');
fprintf(fOut, ''' (CSTxMWSxONLY)\n');
fprintf(fOut, '\n');
fprintf(fOut, ''' draw the bounding box\n');
fprintf(fOut, 'Plot.DrawBox True\n');
fprintf(fOut, '\n');
fprintf(fOut, ''' set units to mm, ghz\n');
fprintf(fOut, 'With Units\n');
fprintf(fOut, '     .Geometry "mm"\n');
fprintf(fOut, '     .Frequency "ghz"\n');
fprintf(fOut, '     .Time "ns"\n');
fprintf(fOut, 'End With\n');
fprintf(fOut, '\n');
fprintf(fOut, ''' set background material to vacuum\n');
fprintf(fOut, '\n');
fprintf(fOut, 'With Background\n');
fprintf(fOut, '     .Type "Normal"\n');
fprintf(fOut, '     .Epsilon "1.0"\n');
fprintf(fOut, '     .Mue "1.0"\n');
fprintf(fOut, '     .XminSpace "0.0"\n');
fprintf(fOut, '     .XmaxSpace "0.0"\n');
fprintf(fOut, '     .YminSpace "0.0"\n');
fprintf(fOut, '     .YmaxSpace "0.0"\n');
fprintf(fOut, '     .ZminSpace "0.0"\n');
fprintf(fOut, '     .ZmaxSpace "0.0"\n');
fprintf(fOut, 'End With\n');
fprintf(fOut, '\n');
fprintf(fOut, ''' set boundary conditions to open\n');
fprintf(fOut, '\n');
fprintf(fOut, 'With Boundary\n');
fprintf(fOut, '     .Xmin "expanded open"\n');
fprintf(fOut, '     .Xmax "expanded open"\n');
fprintf(fOut, '     .Ymin "expanded open"\n');
fprintf(fOut, '     .Ymax "expanded open"\n');
fprintf(fOut, '     .Zmin "expanded open"\n');
fprintf(fOut, '     .Zmax "expanded open"\n');
fprintf(fOut, '     .Xsymmetry "none"\n');
fprintf(fOut, '     .Ysymmetry "none"\n');
fprintf(fOut, '     .Zsymmetry "none"\n');
fprintf(fOut, 'End With\n');
fprintf(fOut, '\n');
fprintf(fOut, ''' optimize mesh settings for planar structures\n');
fprintf(fOut, '\n');
fprintf(fOut, 'With Mesh\n');
fprintf(fOut, '     .MergeThinPECLayerFixpoints "True"\n');
fprintf(fOut, '     .RatioLimit "20"\n');
fprintf(fOut, '     .AutomeshRefineAtPecLines "True", "6"\n');
fprintf(fOut, '     .FPBAAvoidNonRegUnite "True"\n');
fprintf(fOut, '     .ConsiderSpaceForLowerMeshLimit "False"\n');
fprintf(fOut, '     .MinimumStepNumber "5"\n');
fprintf(fOut, 'End With\n');
fprintf(fOut, '\n');
fprintf(fOut, ''' change mesh adaption scheme to energy\n');
fprintf(fOut, ''' 		(planar structures tend to store high energy\n');
fprintf(fOut, '''     	 locally at edges rather than globally in volume)\n');
fprintf(fOut, '\n');
fprintf(fOut, 'MeshAdaption3D.SetAdaptionStrategy "Energy"\n');
fprintf(fOut, '\n');
fprintf(fOut, ''' switch on FD-TET setting for accurate farfields\n');
fprintf(fOut, '\n');
fprintf(fOut, 'FDSolver.ExtrudeOpenBC "True"\n');
fprintf(fOut, '\n');
fprintf(fOut, 'Component.New "component1"\n');
fprintf(fOut, '\n');
for i=1:size(matrix,1)
    for j=1:size(matrix,2)
        
        if(matrix(i,j)==1)
            fprintf(fOut, 'With Brick\n');
            fprintf(fOut, '     .Reset\n');
            fprintf(fOut, ['     .Name "name ',num2str(size(matrix,2)*(i-1)+j),'"\n']);
            fprintf(fOut, '     .Component "component1"\n');
            fprintf(fOut, '     .Material "PEC"\n');
            fprintf(fOut, ['     .Xrange "',num2str((i-1)*unitWidth),'", "' ...
                ,num2str(i*unitWidth),'"\n']);
            fprintf(fOut, '     .Yrange "subsThick", "subsThick+cuThick"\n');
            fprintf(fOut, ['     .Zrange "',num2str((j-1)*unitWidth),'", "' ...
                ,num2str(j*unitWidth),'"\n']);
            fprintf(fOut, '     .Create\n');
            fprintf(fOut, 'End With\n');
        end
    end
end

fprintf(fOut, 'End Sub \n');
fclose(fOut);

end


