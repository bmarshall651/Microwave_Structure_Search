function [ ] = generateDirectory_cfgFile(outputProj_cfg, WorL)
%generateSubstrate_cfgFile creates cfg file for momentum simulation in
%Agilent ADS
%Author: Blake Marshall
%June 28, 2014

fOut = fopen(outputProj_cfg, 'wt');
if(WorL==1)%Windows - DOS
    slash='\';
elseif(WorL==0)%Mac/Linux - UNIX
    slash='/';
else
    disp('Choose either Windows or Linux');
    return;
end


fprintf(fOut, 'user     = . \n');
fprintf(fOut,'site     = {$HOME} \n');
fprintf(fOut,['supplied     = {$HPEESOF_DIR}',slash, ...
    'momentum', slash, 'lib \n']);

fclose(fOut);

disp('Directory .cfg File Complete')
end

