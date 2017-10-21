function [ ] = plot3DPattern( patt, THETA, PHI )
%plot3Dpattern plots a 3D gain pattern
%@param     patt = pattern to be plotted
%           THETA = theta matrix to be plotted on 
%           PHI = phi matrix to be plotted on

%Cartesian for 3D plotting
x=abs(patt).*sin(THETA).*cos(PHI);
y=abs(patt).*sin(THETA).*sin(PHI);
z=abs(patt).*cos(THETA);

%Figure 3D
pattdb=10*log10(abs(patt));
minPattdb=min(min(pattdb));
surf(x, y, z, pattdb-minPattdb, 'edgecolor' , 'none');
axis equal
xlabel('x');
ylabel('y');
zlabel('z');
title('3D Gain Pattern in Linear');

colorbar
colorvals = str2num(get(colorbar,'YTickLabel'));
colorvals = colorvals+minPattdb;
set(colorbar,'YTickLabel',num2str(colorvals));

end

