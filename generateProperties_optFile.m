function [ output_args ] = generateProperties_optFile( dsDir, dsName, outputProj_opt, WorL)
%generateSubstrate_optFile creates opt file for momentum simulation in
%Agilent ADS
%Author: Blake Marshall
%June 28, 2014

fOut = fopen(outputProj_opt, 'wt');

if(WorL==1)%Windows - DOS
    slash='md';
elseif(WorL==0)%Mac/Linux - UNIX
    slash='mkdir';
else
    disp('Choose either Windows or Linux');
    return;
end


system([slash ,' ', dsDir]);
fprintf(fOut, ['DS_DIR ',dsDir,'; \n']);
fprintf(fOut,'NO_CELLS_PER_WAVELENGTH 20; \n');
fprintf(fOut,'EDGEMESH_BORDERWIDTH OFF; \n');
fprintf(fOut,'MESH_REDUCTION ON; \n');
fprintf(fOut,'OVERLAPEXTRACTION ON; \n');
fprintf(fOut,'MATRIXSOLVER 0; \n');
fprintf(fOut,'INCLUDEPORTSOLVER ON; \n');
fprintf(fOut,'MODELTYPESTRIP 3; \n');
fprintf(fOut,'MODELTYPEVIA 3; \n');
fprintf(fOut,'topoWireViasEnabled ON; \n');
fprintf(fOut,'topoWireViasKeepViaOutline OFF; \n');
fprintf(fOut,'topoWireViasKeepThroughPads OFF; \n');
fprintf(fOut,'topoWireViasKeepEndPads ON; \n');
fprintf(fOut,'topoWireViasPadringRadius 3 VIARADII; \n');
fprintf(fOut,'topoWireViasAntipadringRadius 5 VIARADII; \n');
fprintf(fOut,'topoWireViasThermalRadius 5 VIARADII; \n');
fprintf(fOut,'GPPMINFEATURESIZE -0.5; \n');
fprintf(fOut,'GPPMERGEALLSHAPES ON; \n');
fprintf(fOut,'GPPSIMPLIFYABSTOL 0.01 LAMBDA; \n');
fprintf(fOut,'GPPSIMPLIFYRELTOL 0.082; \n');
fprintf(fOut,'DRCLOGGING ON; \n');
fprintf(fOut,'DRCLAYER 255; \n');
fprintf(fOut,['DS_NAME ',dsName,'; \n']);
fprintf(fOut,'reusePreviousResults OFF; \n');
fprintf(fOut,'saveCurrentsInFile ON; \n');
fprintf(fOut,'SimulationMode 1;maxThreads 0; \n');
fprintf(fOut,'maxThreads 0; \n');

fclose(fOut);

disp('Simulation Settings .opt File Complete')
end

