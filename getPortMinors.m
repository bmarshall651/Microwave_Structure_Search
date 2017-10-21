function [portMinors, metalOrAirPort]= getPortMinors(portLocations, ...
    portWidth, xdimNumofCells, emptyBoundaries)

disp('Finding port minors for given ports...')
%emptyBoundaries=4;
metalOrAirPort=[];
for portN=1:size(portLocations,1);
    for portM=1:portWidth+emptyBoundaries;
        if mod(portWidth,2) == 0
            disp('Use odd number of cells for port width');
            portWidth=portWidth+1;
        else
            %(portWidth+emptyBoundaries)*(portN-1)+(portM-1)+1
            portMinors((portWidth+emptyBoundaries)*(portN-1)+(portM-1)+1)...
                = portLocations(portN,1)+...
                (portLocations(portN,2)-1)*xdimNumofCells +...
                portM-ceil((portWidth+emptyBoundaries)/2);
            
        end
        
    end
    metalOrAirPort=horzcat([metalOrAirPort, ...
        zeros(1,(emptyBoundaries)/2), ones(1, portWidth), ...
        zeros(1,emptyBoundaries/2)]);
    %     portMinorsRetro(3*(portN-1)+1:3*(portN))=[portLocations(portN,1)+...
    %(portLocations(portN,2)-1)*xdimNumofCells-1; ...
    %         portLocations(portN,1)+(portLocations(portN,2)-1)*xdimNumofCells; ...
    %         portLocations(portN,1)+(portLocations(portN,2)-1)*xdimNumofCells+1;];
end

end


