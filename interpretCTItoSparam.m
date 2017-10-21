function [ S ] = interpretCTItoSparam( ctifile )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

fOut=-1;
openAttempts=0;

while(fOut==-1)
    fOut = fopen(ctifile, 'r');
    openAttempts=openAttempts+1;
    if(openAttempts>3)
        disp('FAILED TO OPEN CTI FILE - DOES IT EXIST? Trying again...');
        S=-1;
        return;
    end
end

x=1;
count=1;
numOfSparams=1;
while(1)
    tline=fgetl(fOut);
    if(findstr('NBR_OF_PORTS',tline)==10)
        numOfPorts=str2double(tline(23));
        numOfSparams=numOfPorts*numOfPorts;
        break;
    end
end

ind=1;
while(1)
    tline=fgetl(fOut);
    if(findstr('VAR_LIST_BEGIN',tline)==1)
        while(1)
            tline2=fgetl(fOut);
            
            if(findstr('VAR_LIST_END',tline2)==1)
                break;
            end
            freqS(1,1,ind)=str2double(tline2);
            ind=ind+1;
        end
        break;
    end
end

sSpot=1;
while(sSpot <= numOfSparams)
    tline=fgetl(fOut);
    if(findstr('BEGIN',tline)==1)
        ind=1;
        while (ind<=size(freqS,3))
            tline2=fgetl(fOut);
            SStr=strsplit(tline2,',');
            S(mod(sSpot-1,numOfPorts)+1,ceil(sSpot/numOfPorts),ind)=str2double(SStr(1))+sqrt(-1)*str2double(SStr(2));
            ind=ind+1;
        end
        sSpot=sSpot+1;
    end
end
save('temp.mat');
fclose(fOut);

disp('S-parameter Data Extraction Complete')
end

