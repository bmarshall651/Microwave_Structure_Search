function [ output_args ] = generatePorts_prtFile( locs ,outputProj_prtFile)
%generatePorts_prtFile creates the .prt file for Momentum simulation
%Agilent ADS
%Author: Blake Marshall
%June 28, 2014
%locs is Nx2 array of location of the ports in METERS
fOut = fopen(outputProj_prtFile, 'wt');

fprintf(fOut, '<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fOut, '<port_setup version="1.1">\n');
fprintf(fOut, '  <calibration_group_list>\n');
fprintf(fOut, '    <calibration_group id="1">\n');
fprintf(fOut, '      <type>TML</type>\n');
fprintf(fOut, '      <auto_split>true</auto_split>\n');
fprintf(fOut, '    </calibration_group>\n');
fprintf(fOut, '  </calibration_group_list>\n');
fprintf(fOut, '  <port_list>\n');

[rows,cols]=size(locs);
x=1;

while(x<=rows)
   fprintf(fOut, ['    <port id="',num2str(x),'">\n']);
   fprintf(fOut, ['      <name>P',num2str(x),'</name>\n']);
   fprintf(fOut, ['      <plus_pin>P',num2str(x),'</plus_pin>\n']);
   fprintf(fOut, '      <impedance>\n');
   fprintf(fOut, '        <real>50</real>\n');
   fprintf(fOut, '        <imag>0</imag>\n');
   fprintf(fOut, '      </impedance>\n');
   fprintf(fOut, ['      <calibration_group_ref ref="1" />\n']);
   fprintf(fOut, '    </port>\n');
    x=x+1;
end

 fprintf(fOut, '  </port_list>\n');
 fprintf(fOut, '</port_setup>\n');


fclose(fOut);

disp('Port .prt File Complete')
end

