function [ ] = buildLensFiles( matrix, unitWidth, ports, startFreq, stopFreq, stepFreq, folderName, WorL)
%buildLensFiles creates required files for the simulation in Agilent ADS
% such as proj_a, .prt, .pin, .opt, .sti, and .cfg
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 30, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param matrix is the binary matrix of the physical structure 1s are metal
%@param unitWidth is the physical width of each cell in the matrix in mm
%@param ports list of cell locations with ports [p1_row p1_col; p2_row
%p2_col;] would have 2 ports
%@param startFreq simulation start frequency
%@param stopFreq simulation stop frequency
%@param stepFreq simulation frequency steps
%@param folderName is the place where the files are stored
%@param WorL is DOS or UNIX... DOS is 1 and UNIX is 0
% 
%

disp('Building all files required for simulation...')
if(WorL==1)%Windows - DOS
    slash='\';
elseif(WorL==0)%Mac/Linux - UNIX
    slash='/';
else
    disp('Choose either Windows or Linux');
    return;
end

generateGeom_Proj_aFile(matrix, unitWidth, [folderName, slash, 'proj_a']);
generatePorts_prtFile(ports,[folderName, slash, 'proj.prt']);
generatePorts_pinFile(matrix,ports,unitWidth,[folderName, slash, 'proj.pin']);
generateProperties_optFile('dsFolder','dsName', [folderName, slash, 'proj.opt'],WorL);
generateSim_stiFile(startFreq,stopFreq,stepFreq, [folderName, slash, 'proj.sti']);
generateDirectory_cfgFile([folderName, slash, 'proj.cfg'],WorL);

disp('All files complete... Ready for Simulation!')
end

