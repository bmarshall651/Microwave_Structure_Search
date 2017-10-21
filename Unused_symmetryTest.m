clear all;
clc;

M=8;
N=8;

A=zeros(M,N);

x=3;
y=2;

ind=x+(y-1)*N


yGuess=ceil(ind/N);
xGuess=ind-((yGuess-1)*N);


% ySym=N-y+1;
% xSym=M-x+1;
% 
% indYsym=x+(ySym-1)*N
% indXsym=xSym+(y-1)*N
% indOddsym=xSym+(ySym-1)*N
% 
% A(ind)=1;
% A(indYsym)=1;
% A(indXsym)=1;
% A(indOddsym)=1;
% 


