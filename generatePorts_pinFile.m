function [ output_args ] = generatePorts_pinFile(matrix, locs, unitWidth, outputProj_pinFile )
%generatePorts_pinFile creates the .pin file for Momentum simulation
%Agilent ADS
%Author: Blake Marshall
%June 28, 2014
%locs is Nx2 array of location of the ports in METERS
fOut = fopen(outputProj_pinFile, 'wt');

fprintf(fOut, '<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fOut, '<pin_list version="1.0">\n');
fprintf(fOut, '  <!-- note: all coordinates are in meter -->\n');

[rows,cols]=size(locs);
x=1;

while(x<=rows)
   fprintf(fOut, '  <pin>\n');
   fprintf(fOut, ['    <name>P',num2str(x),'</name>\n']);
   fprintf(fOut, ['    <net>P',num2str(x),'</net>\n']);
   fprintf(fOut, '    <layout>\n');
   fprintf(fOut, '      <shape>\n');
   fprintf(fOut, '        <layer>1</layer>\n');
   fprintf(fOut, '        <purpose>-1</purpose>\n');
   fprintf(fOut, '        <point>\n');
   %Checks for which edge then fills in file with coordinate of port

   if locs(x,2)==1
          fprintf(fOut, ['          <x>',num2str(0),'</x>\n']);
          fprintf(fOut, ['          <y>',num2str((size(matrix,1)-locs(x,1)+0.5)*unitWidth/1000),'</y>\n']);
   elseif locs(x,1)==1
          fprintf(fOut, ['          <x>',num2str((locs(x,2)-0.5)*unitWidth/1000),'</x>\n']);
          fprintf(fOut, ['          <y>',num2str((size(matrix,1))*unitWidth/1000),'</y>\n']);
    elseif locs(x,2)==size(matrix,2)
          fprintf(fOut, ['          <x>',num2str((locs(x,2))*unitWidth/1000),'</x>\n']);
          fprintf(fOut, ['          <y>',num2str((size(matrix,1)-locs(x,1)+0.5)*unitWidth/1000),'</y>\n']);
   elseif locs(x,1)==size(matrix,1)
          fprintf(fOut, ['          <x>',num2str((locs(x,2)-0.5)*unitWidth/1000),'</x>\n']);
          fprintf(fOut, ['          <y>',num2str(0),'</y>\n']);
   else
       disp('Please only select port locations that are on an edge of the geometry');
       break;
       
   end
   fprintf(fOut, '        </point>\n');
   fprintf(fOut, '      </shape>\n');
   fprintf(fOut, '    </layout>\n');
   fprintf(fOut, '  </pin>\n');
    x=x+1;
end

 fprintf(fOut, '</pin_list>\n');



fclose(fOut);

disp('Pin .pin File Complete')
end


