function [ myList, coarse] = getCoarseGridMinors( M, N, gridSize, XSym, YSym, ...
    randomize, genChange, autoCoarseList, x, totalCycles, prevCoarseness, ...
    homogenous)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if autoCoarseList == 0 && homogenous ==0
    coarse=gridSize(ceil(size(gridSize,2)*(x/totalCycles)));
    if mod(M,coarse)+mod(M,coarse)~=0
        myList=transpose(1:M*N);
        disp('!!!ERROR!!! -> The gridSize is not a multiple of the x-dim or the y-dim... we should probably fix this');
        %elseif gridSize==1
        %    myList=transpose(1:M*N);
    end
elseif autoCoarseList == 1 && genChange == 0 && prevCoarseness==0 ...
        && homogenous==0
    coarse=gcd(M,N);
    if coarse>=M || coarse>=N
        coarse=gcd(M/coarse,N/coarse);
    end
elseif autoCoarseList == 1 && genChange == 0 && prevCoarseness>1 ...
        && homogenous==0
    coarse=gcd(M/prevCoarseness, N/prevCoarseness);
elseif autoCoarseList == 1 && genChange == 1 && homogenous==0
    coarse=prevCoarseness;
else
    coarse=1;
end


if XSym ==1 && YSym==0
    xlim=N/2;
    ylim=M;
elseif XSym==0 && YSym==1
    xlim=N;
    ylim=M/2;
elseif XSym==1 && YSym==1
    xlim=N/2;
    ylim=M/2;
else
    xlim=N;
    ylim=M;
end

x=1;
y=1;
count=1;
while x < xlim && x+coarse-1<=xlim
    while y < ylim && y+coarse-1<=ylim
        temp=1;
        za=1;
        zb=1;
        % Adds all Minors used in square on each column
        while zb <= coarse
            while za <= coarse
                if zb==1 && za ==1
                    myList(count,temp)=x+(y-1)*N;
                else
                    myList(count,temp)=myList(count,1)+(za-1)+(zb-1)*N;
                end
                temp=temp+1;
                %Grab the minor
                curMinor=myList(count,1)+(za-1)+(zb-1)*N;
                %Find x and y values
                
                
                %yGuess=floor(curMinor/N)+1;
                yGuess=ceil(curMinor/N);
                xGuess=curMinor-((yGuess-1)*N);
                %Find symetry values
                
                if XSym ==1
                    xSym=N-xGuess+1;
                    myList(count,temp)=xSym+(yGuess-1)*N;
                    temp=temp+1;
                end
                if YSym ==1
                   
                    %Debug
                    ySym=M-yGuess+1;
                    myList(count,temp)=xGuess+(ySym-1)*N;
                    temp=temp+1;
                  
                  
                    
                end
                if XSym==1 && YSym ==1
                    myList(count,temp)=xSym+(ySym-1)*N;
                    temp=temp+1;
                end
                
                za=za+1;
            end
            za=1;
            zb=zb+1;
        end
        %End of all minors used in square
        y=y+coarse;
        count=count+1;
    end
    y=1;
    x=x+coarse;
end

if randomize ==1
    ok=1;
    while ok <=size(myList,1)
        randomizeIt=transpose(randperm(size(myList,1),size(myList,1)));
        myListTemp(ok,:)=myList(randomizeIt(ok),:);
        ok=ok+1;
    end
    
    myList=myListTemp;
    clear myListTemp
end

