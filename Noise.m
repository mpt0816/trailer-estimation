function [sys,x0,str,ts,simStateCompliance] = Noise(t,x,u,flag)
switch flag
  case 0
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;

  case 1
    sys=mdlDerivatives(t,x,u);

  case 2
    sys=mdlUpdate(t,x,u);

  case 3
    sys=mdlOutputs(t,x,u);

  case 4
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  case 9
    sys=mdlTerminate(t,x,u);

  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes

sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
%% output: 
sizes.NumOutputs     = 6;
%% input:
% heading of tractor
% headinf of trailer
% x, position of tractor
% y, position of tractor
% steering angle of tractor
sizes.NumInputs      = 10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1; 

sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

simStateCompliance = 'UnknownSimState';


function sys=mdlDerivatives(t,x,u)

sys = [];

function sys=mdlUpdate(t,x,u)

sys = [];

function sys=mdlOutputs(t,x,u)
tractor_heading = u(1) + u(6);
trailer_heading = u(2) + u(7);
tractor_x = u(3) + u(8);
tractor_y = u(4) + u(9);
tractor_steer = u(5) + u(10);
sys = [tractor_heading, trailer_heading, tractor_x, tractor_y, tractor_steer, u(2)];

function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;


function sys=mdlTerminate(t,x,u)

sys = [];
