%% Fixed CFST Arch Structure
% Probabilistic analysis based on Normal PDF First Part
% Linear Analysis
clear; %clear all variables
close all; %close all figures
warning('off','all'); clc;
dbstop if error
%% Simulation's Loop
% Total length of the CFST arch (m)
L=15;
% The ratio of height and length of the arch for fixed CFST arch
fL=1/6;
theta=atan(2*fL)*2;
f=fL*L;
R=L/2/sin(theta);
S=2*R*theta; % Arch length (m)
L=2*R*sin(theta);
% Number of iterations
nsamples=100000; % For sub-condition 1
% nsamples=100; % For sub-condition 2
% nsamples=1000; % For sub-condition 3
% nsamples=10000; % For sub-condition 4
% nsamples=50000; % For sub-condition 5
% nsamples=100000; % For sub-condition 6
Es=zeros(nsamples,1);
fu=zeros(nsamples,1);
sh=zeros(nsamples,1);
N=zeros(nsamples,1);
M=zeros(nsamples,1);

for i=1:nsamples;
%Parameter assumed in the system
%Uncertainty in final shrinkage strain based on normal distribution
Sha=normrnd(340*10^(-6),17*10^(-6),1,1); % For condition 1
% Sha=normrnd(340*10^(-6),34*10^(-6),1,1); % For condition 2
% Sha=normrnd(340*10^(-6),51*10^(-6),1,1); % For condition 3
% Sha=normrnd(340*10^(-6),68*10^(-6),1,1); % For condition 4
%Uncertainty in Young's Moduli of steel tube based on normal distribution
Es(i)=normrnd(200*10^9,10*10^9,1,1); % For condition 1
% Es(i)=normrnd(200*10^9,20*10^9,1,1); % For condition 2
% Es(i)=normrnd(200*10^9,30*10^9,1,1); % For condition 3
% Es(i)=normrnd(200*10^9,40*10^9,1,1); % For condition 4
Essort=sort(Es);
Ec=30*10^9; % Young's Moduli of concrete (Pa)
Ro=0.25; % Outer radii of steel tube (m)
Ri=0.24; % Inner radii of steel tube (m)
As=pi*((Ro)^2-(Ri)^2); % Area of the steel tube (m^2)
Ac=pi*(Ri)^2; % Area of the concrete core (m^2)
% Second moment inertia of steel tube (m^4)
Is=pi*(2*Ro)^4/64*(1-(Ri/Ro)^4);
% Second moment inertia of concrete core (m^4)
Ic=pi*(2*Ri)^4/64;
% Time required for moist curing of the concrete core (days)
d=35;
% Creep in CFST Arches at 50 days
t0=15; % Initial loading time (days)
t=50; % Final loading time (days)
% Uncertainty in final creep coefficient based on normal distribution
fin7=normrnd(2.5,0.125,1,1); % For condition 1
% fin7=normrnd(2.5,0.25,1,1); % For condition 2
% fin7=normrnd(2.5,0.375,1,1); % For condition 3
% fin7=normrnd(2.5,0.5,1,1); % For condition 4
fu(i)=1.25*t0^(-0.118)*fin7;
fsort=sort(fu);
k1=0.78+0.4*exp(-1.33*fin7);
k2=0.16+0.8*exp(-1.33*fin7);
ka=k1*t0/(k2+t0);
fi=(t-t0)^0.6/(10+(t-t0)^0.6)*fu(i); % Creep coefficient
ki=1-(1-ka)*(t-t0)/(20+(t-t0)); % The ageing coefficient
% Age-adjusted effective modulus of concrete core
Eec=Ec./(1+ki.*fi);
EI=Es(i)*Is+Eec*Ic;
EA=Es(i)*As+Eec*Ac;
% Time-dependent radius of gyration of the effective cross-section
re=sqrt(EI/EA);
% sh=(t./(t+d)).*Sha; % Shrinkage strain of the concrete
sh(i)=(t./(t+d)).*Sha;
shsort=sort(sh);
% Long-term structural responses of fixed CFST arch structure
% Second-mode buckling load of a fixed CFST
Nf=(1.4303*pi)^2.*EI./(S/2)^2;
Q=0.2.*Nf; % Concentrated load condition
a=Ac.*Eec.*sh(i)./EA;
phi=(R^2+re.^2).*theta.*(cos(theta).*sin(theta)+theta)-2*R^2*sin(theta)^2;
E1=(cos(theta)-1).*((R^2+re.^2)*theta*(1+cos(theta))-2*R^2*sin(theta))./(2.*phi);
% Axial compressive force of fixed CFST arch structure
N(i)=Q*E1-2*re.^2.*a.*EA*sin(theta)*theta./phi;
Nsort=sort(N);
E2=(R.^2+re.^2).*(cos(theta)-1).*(sin(theta)-theta)/(2.*phi);
% Bending moment of fixed CFST arch structure
M(i)=(Q.*R.*E2)-(N(i).*R)-(2.*R.*re.^2.*(sin(theta)).^2.*Ac.*Eec.*sh(i))./(phi);
Msort=sort(M);
end
%% Structural Responses and Uncertain Parameter Distribution histogram
% Axial compressive force normal distribution histogram
figure
hist(Nsort,50);
title('Axial Compression');
axis tight
% Bending moment normal distribution histogram
figure
hist(Msort,50);
title('Bending Moment');
axis tight
% Shrinkage strain normal distribution histogram
figure
hist(shsort,50);
title('Shrinkage Strain');
axis tight
% Final creep coefficient normal distribution histogram
figure
hist(fsort,50);
title('Final Creep Coefficient');
axis tight
% Young's Moduli of steel normal distribution histogram
figure
hist(Essort,50);
title('Young Modulus of Steel');
axis tight
%% Structural Responses Statistical Analysis and the Normality Test
[meanN,stdN,mean95N,std95N]=normfit(N)
[meanM,stdM,mean95M,std95M]=normfit(M)
figure
normplot(Nsort)
title('Normal Probability plot for Axial Compression');
figure
normplot(Msort)
title('Normal Probability plot for Bending Moment');
