function [sys,x0,str,ts,simStateCompliance] = ExtendedKalmanFilter(t,x,u,flag)
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
% heading of trailer
sizes.NumOutputs     = 3;
%% input:
% heading of tractor
% headinf of trailer: with noise
% x, position of tractor
% y, position of tractor
% steering angle of tractor
% headinf of trailer: true value
sizes.NumInputs      = 6;
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

  %% parameters
  wheelbase_tractor = 3.49;
  wheelbase_trailer = 7.528;
  % positive if hinge is on back of rear axe of tractor
  % negative if hinge is on front of rear axe of tractor
  % zero if hinge is as same as rear axe of tractor
  tractor_base2hinge = -0.6;

  %% static variables
  % state variable: heading of trailer
  persistent init;
  if isempty(init)
    init = -1;
  end
  
  persistent theta_trailer;
  if isempty(theta_trailer)
    theta_trailer = 0;
  end
 
  persistent P;
  if isempty(P)
    P = [1];
  end
  
  persistent x_last;
  if isempty(x_last)
    x_last = 0.0;
  end
  
  persistent y_last;
  if isempty(y_last)
    y_last = 0.0;
  end
  %% heperparameters
  % covariance matrix of process noise
  % state space is one dimension, so covariance matrix is one dimension
  q = 0.0;
  % covariance matrix of measurement noise
  % perception noise of trailer heading
  r = 0.08 * 0.08;
  
  %% control variable
  % u(1): heading of tractor
  % u(2): headinf of trailer: with noise
  % u(3): x, position of tractor
  % u(4): y, position of tractor
  % u(5): steering angle of tractor
  % u(6): headinf of trailer: true value

  theta_tractor = u(1);
  theta_trailer_m = u(1) + u(2);
  x = u(3);
  y = u(4);
  steer_angle = u(5);
  
  if init < 0
    theta_trailer = theta_trailer_m;
    init = 1;
  end
  
  %% forward distance of tractor
  ds = sqrt((x - x_last) * (x - x_last) + (y - y_last) * (y - y_last));
  if ds > 100.0 / 3.6 * 0.2
      ds = 0;
  end
  ds = DsMeanFilter(ds, 120);
%   steer_angle = SteerMeanFilter(steer_angle, 40);
  % updata coordinate of tractor
  x_last = x;
  y_last = y;
  
  %% prediction
  lambda = theta_tractor - theta_trailer;
  f = 1 / wheelbase_trailer * (sin(lambda) - tractor_base2hinge / wheelbase_tractor * cos(lambda) * tan(steer_angle));
  theta_trailer = theta_trailer + f * ds;
  % Jacobi matrix
  F = [1 - ds / wheelbase_trailer * (cos(lambda) + tractor_base2hinge / wheelbase_tractor * sin(lambda) * tan(steer_angle))];
  % control matrix
  B = [ds / wheelbase_trailer * (cos(lambda) + tractor_base2hinge / wheelbase_tractor * sin(lambda) * tan(steer_angle)), ...
      -tractor_base2hinge * ds / wheelbase_tractor / wheelbase_trailer * cos(lambda) * (1 + tan(steer_angle) * tan(steer_angle))];
  %% predticion variable covariance
  Q = [q];
  P = F * P * F' + Q;
  %% updata state
  H = [1.0];
  R = [r];
  K = P * H'* inv(H * P * H' + R);
  theta_trailer = theta_trailer + K(1, 1) * (theta_trailer_m - theta_trailer);
  I = eye(1);
  P = (I - K * H) * P;
sys = [u(6), u(2), theta_trailer - theta_tractor];

function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;


function sys=mdlTerminate(t,x,u)

sys = [];
