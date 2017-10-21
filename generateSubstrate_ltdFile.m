function [ fOut ] = generateSubstrate_ltdFile( er, tand, fmeasure, h, cond, outputProj_ltd)
%generateSubstrate_ltdFile creates ltd file for momentum simulation in
%Agilent ADS
%Author: Blake Marshall
%June 28, 2014
%er: relative permittviity of substrate
%tand: tangent delta of substrate
%fmeasure: frequency of er and tand
%h: height of substrate
%cond: conductivity of copper
%outputProj_ltd: file to write ltd to

disp('Building substrate and simulation parameters....');

fOut = fopen(outputProj_ltd, 'wt');

fprintf(fOut, 'TECHFORMAT=V2 \n');
fprintf(fOut, '\n');

fprintf(fOut, 'UNITS \n');
fprintf(fOut, '  DISTANCE=METRE \n');
fprintf(fOut, '  CONDUCTIVITY=SIEMENS/M \n');
fprintf(fOut, '  RESISTIVITY=OHM.CM \n');
fprintf(fOut, '  RESISTANCE=OHM/SQ \n');
fprintf(fOut, '  PERMITTIVITY=RELATIVETOVACUUM \n');
fprintf(fOut, '  PERMEABILITY=RELATIVETOVACUUM \n');
fprintf(fOut, '  FREQUENCY=HZ \n');
fprintf(fOut, 'END_UNITS \n');
fprintf(fOut, '\n');

fprintf(fOut, 'BEGIN_MATERIAL \n');
fprintf(fOut, ['  MATERIAL Cu CONDUCTIVITY=',num2str(cond),'  IMAG_CONDUCTIVITY=0 \n']);
fprintf(fOut, ['  MATERIAL FR4 PERMITTIVITY=', num2str(er), ' LOSSTANGENT=',num2str(tand), ...
    ' PERMEABILITY=1 DJORDJEVIC LOWFREQ=1000 VALUEFREQ=',num2str(fmeasure), ' HIGHFREQ=1e+12 \n']);
fprintf(fOut, 'END_MATERIAL \n');
fprintf(fOut, '\n');

fprintf(fOut, 'BEGIN_OPERATION \n');
fprintf(fOut, '  OPERATION OperationSHEET SHEET \n');
fprintf(fOut, '  OPERATION OperationThickness_cond INTRUDE=3.347e-05 UP \n');
fprintf(fOut, '  OPERATION OperationDRILL DRILL \n');
fprintf(fOut, 'END_OPERATION \n');
fprintf(fOut, '\n');


fprintf(fOut, 'BEGIN_MASK \n');
fprintf(fOut, '  MASK 1 Name=cond PRECEDENCE=1 COLOR="ee6a50" MATERIAL=Cu OPERATION=OperationThickness_cond  MASK_PROPERTIES = { "MomModelType=operation2sheet" } \n');
fprintf(fOut, 'END_MASK \n');
fprintf(fOut, '\n');

fprintf(fOut, 'BEGIN_STACK \n');
fprintf(fOut, '  TOP OPEN MATERIAL=AIR \n');
fprintf(fOut, '  INTERFACE Name=__Interface2      MASK={cond} \n');
fprintf(fOut, ['  LAYER     Name=__SubstrateLayer1 HEIGHT=', num2str(h), ' MATERIAL=FR4 \n']);
fprintf(fOut, '  BOTTOM COVERED THICKNESS=1.735e-05 MATERIAL=Cu \n');
fprintf(fOut, 'END_STACK \n');


fclose(fOut);
end
