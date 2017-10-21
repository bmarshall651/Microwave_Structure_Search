function [G, Efield_theta, Efield_phi, EthetaMax, EphiMax, THETA, PHI] = interpretFFFtoFarField( fffFile,antFile, exciteVoltage, portImpedance)
%interpretFFFtoFarField( fffFile,antFile)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

% antFile='proj.ant';
% fffFile='proj.fff';
fOut = fopen(antFile, 'r');


while(1)
    tline=fgetl(fOut);
    if(findstr('E_theta_max',tline)==1)
        tline=fgetl(fOut);
        hmm=tline(13:end);
        two=strsplit(hmm,' ');
        EthetaMax=str2double(two(1))+sqrt(-1)*str2double(two(2));
        
        tline=fgetl(fOut);
        hmm=tline(11:end);
        two=strsplit(hmm,' ');
        EphiMax=str2double(two(1))+sqrt(-1)*str2double(two(2));
        break;
    end
end

Escaling=sqrt(abs(EthetaMax)^2+abs(EphiMax)^2);

fclose(fOut);

fOut=fopen(fffFile, 'r');

phi=linspace(0,2*pi,360);
theta=linspace(0,pi/2,90);
dtheta=pi/180;
dphi=pi/180;
dA=dtheta*dphi;
[THETA, PHI] = meshgrid(theta, phi);

t=1;
p=1;

while(1)
    looky=fgetl(fOut);
    if(findstr('#----------------',looky)==1)
        break;
    end
end

while(p<=360)
    looky=fgetl(fOut);
    if(findstr('#Begin cut',looky)==1)
        while(t<=90)
            line=fgetl(fOut);
            splits=strsplit(line, ' ');
            Efield_theta(p,t)=abs(EthetaMax).*(str2double(splits(3))+sqrt(-1)*str2double(splits(4)));
            Efield_phi(p,t)=abs(EphiMax).*(str2double(splits(5))+sqrt(-1)*str2double(splits(6)));
            t=t+1;
        end
        p=p+1;
        t=1;
    else
        print('ERROR UNEXPECTED FORMATTING');
    end
    
    looky=fgetl(fOut);
    while(findstr(' ',looky)~=1)
        looky=fgetl(fOut);
    end
    
end

% Efield_theta(:,91:180)=zeros(360,90);
% Efield_phi(:,91:180)=zeros(360,90);

c=3E8;
uo=4*pi*10^-7;
eo=1/((c^2)*uo);
Zo=sqrt(uo/eo);

U=(1/(2*Zo))*(abs(Efield_theta).^2+abs(Efield_theta).^2);
Umax=max(max(U));
Pinj=(exciteVoltage^2)/portImpedance/8
G=4*pi*U/Pinj;
Gmax=Umax*4*pi/Pinj
Gdb=20*log10(Gmax)
Prad=trapz(trapz(U))*dA

fclose(fOut);

save('FFdemo.mat');



