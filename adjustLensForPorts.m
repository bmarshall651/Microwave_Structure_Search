function [ matrix ] = adjustLensForPorts( matrix, portMinors, portMetalOrAir )
%adjustLensForPort ensures that there is metal at each port location with
%non-metal on either side to prevent errors in MOM simulation with
%electrical connections to other ports
%
%Author: Blake R. Marshall - bmarshall651@gmail.com
%Date: July 6, 2014
%The Propagation Group at Georgia Institute of Technology
%
%@param matrix is the original matrix
%@param portLocations is the location of all the ports listed as: [x1 y1; x2
%y2; x3 y3;]
%@param portMetalOrAir template of the port metal or air via a 1-D spatial
%array with 1 for metal and 0 for air
%
%
%@return matrix is the same matrix passed in with cleaned up ports


metalMinorsTemp=portMinors.*portMetalOrAir;
metalMinors=metalMinorsTemp(metalMinorsTemp~=0);
airMinorsTemp=portMinors.*~portMetalOrAir;
airMinors=airMinorsTemp(airMinorsTemp~=0);



p=1;
for p=1:size(metalMinors,2)
    matrix(metalMinors(p))=1;
end

p=1;
for p=1:size(airMinors,2)
    matrix(airMinors(p))=0;
end

% p=1;
% while(p<=size(portLocations,1))
%     matrix(portLocations(p,1),portLocations(p,2))=1;
%     
%     if portLocations(p,2)==1
%         matrix(portLocations(p,1)-1,portLocations(p,2))=0;
%         matrix(portLocations(p,1)+1,portLocations(p,2))=0;
%     elseif portLocations(p,1)==1
%         matrix(portLocations(p,1),portLocations(p,2)-1)=0;
%         matrix(portLocations(p,1),portLocations(p,2)+1)=0;
%     elseif portLocations(p,2)==size(matrix,2)
%         matrix(portLocations(p,1)-1,portLocations(p,2))=0;
%         matrix(portLocations(p,1)+1,portLocations(p,2))=0;
%     elseif portLocations(p,1)==size(matrix,1)
%         matrix(portLocations(p,1),portLocations(p,2)-1)=0;
%         matrix(portLocations(p,1),portLocations(p,2)+1)=0;
%     else
%         disp('Please only select port locations that are on an edge of the geometry');
%         break;
%         
%     end
%     
%     
%     
%     p=p+1;
%     
% end
% 
% end

