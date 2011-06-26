% Constants (and some not so constants)
rho = 1.225;                    %Air density (kg/m^3)
g = 9.81;                       %Gravitational acceleration (m/s^2)
kt_to_ms = 0.514444;            %Unit conversion (knots to meters/second)
lb_to_kg = 0.45359237;          %Unit conversion (pounds to kilograms)
ft_to_m = 0.3048;               %Unit conversion (feet to meters)
in_to_m = 0.0254;               %Unit conversion (inches to meters)
slug_to_kg = 14.593903;         %Unit conversion (slugs to kilograms)
e = 0.836;                      %Oswalt's efficiency factor



%
%Vehicle parameters (mostly from DR133-03, the remainder from Geo_model.m)
%

% High level parameters from DR133-03
M = 0.155; % approx 100 / 661 kts at sea level
CDu = 0;
CD0 = 0.0255;
Ctu = 0.0255;
CL0 = 0.465;
CLa = 5.898;
CLaw = 6.01;
CLat = 3.544;
Cmafus = 0.3021;
deda = 0.0554;
eta = 0.95;
Vh = 1.0048;
eta_v = 0.95;
Vv = 0.0431;

%Mass moments of inertia
Ixx = 25.2589*slug_to_kg*ft_to_m^2;
Iyy = 32.8379*slug_to_kg*ft_to_m^2;
Izz = 47.0740*slug_to_kg*ft_to_m^2;

%Dimensions
b = 205*in_to_m;                %Wing span
S = 36*ft_to_m^2;               %Wing planform area (m^2)
m = 186*lb_to_kg;               %Aircraft total mass (kg)
cbar = 27*in_to_m;              %Mean Aerodynamic Chord (m)
AR = b^2/S;
Xcg = 77.35 * in_to_m;
Xac = 57.4 * in_to_m;
Zapt = 0.1405;                  %z position of engine force in Fm (m)

% Stability coefficients 
CXu = -0.0765
CXu_ah = -(CDu + 2 * CD0) + Ctu
CXa = 0.1905
CXa_ah = CL0 - 2 * CL0 * CLa / (pi * e * AR)
CXde = 0;
CXdt = 1;
CZu = -0.9415
CZu_ah = -M^2 / (1 - M^2) * CL0 - 2 * CL0
CZa = -5.8725
CZa_ah = -(CLa + CD0)
CZde = -0.5811;
Cmu = 0;
Cma = 1.5473
Cma_ah = CLaw * (Xcg / cbar - Xac / cbar) + Cmafus - eta * Vh * CLat * (1 - deda)
Cmadot = -1.32; 
Cmq = -28.981;
Cmde = 0.0539;
CYb = -0.0425;
CYp = 0;
CYr = 0.03964;
Clb = 0;
Clp = -0.4915;
Clr = 0.3537;
Cnb = 0.2128;
Cnp = -0.1375;
Cnr = -0.1116;

% Linearization point u0, theta0
u0 = 60 * kt_to_ms;
theta0 = 0;
Q = 0.5 * rho * u0^2;         % Dynamic pressure


% Longitudinal state space model
% with state vector [u w q theta].'
force_norm = Q * S / (m * u0);
moment_norm = Q * S * cbar / (Iyy * u0);

Xu = CXu * force_norm;
Xw = CXa * force_norm;
Zu = CZu * force_norm;
Zw = CZa * force_norm;
Mu = Cmu * moment_norm;
Mw = Cma * moment_norm;
Mq = Cmq * cbar / 2 * moment_norm;

A_long = [Xu Xw 0 -g;
          Zu Zw u0 0;
          Mu Mw Mq 0;
          0 0   1  0;];
eig(A_long)

Xde = CXde * Q * S / m;
Xdt = CXdt * m * g; % thrust control is acceleration relative to g
Zde = CZde * Q * S / m;
Zdt = 0;
Mde = Cmde * Q * S * cbar / Iyy;
Mwdot = Cmadot * Q * S * cbar^2 / (2 * u0^2 * Iyy);
Mdt = Iyy * g * Zapt; % positive moment as thrust is below CG

%B_long = [Xde               Xdt; 
%          Zde               Zdt;
%	  Mde + Mwdot * Zde Mdt + Mwdot * Zdt;
%	  0                  0;];

% version without only elevator control
B_long = [Xde               ; 
          Zde               ;
	  Mde + Mwdot * Zde ;
	  0                 ;];

% Longitudinal controller design
ea = eig(A_long);
a = poly(ea)';
a = a(2:end);
eab = ea;
eab(2) = -0.7;
abar = poly(eab)';
abar = abar(2:end);
V = ctrb(A_long, B_long);
W = toeplitz([1; a(1:end-1)], [1 0 0 0])';
k = inv((V * W)') * (abar - a);
aug_eig = eig(A_long - B_long * k');

% Lateral state space model
% with state vector [beta p r phi].'
Yb = CYb * Q * S / m;
Yp = CYp * b * Q * S / (2 * m * u0);
Yr = CYr * b * Q * S / (2 * m * u0);
Lb = Clb * b * Q * S / Ixx;
Lp = Clp * b^2 * Q * S / (2 * Ixx * u0);
Lr = Clr * b^2 * Q * S / (2 * Ixx * u0);
Nb = Cnb * b * Q * S / Izz;
Np = Cnp * b^2 * Q * S / (2 * Izz * u0);
Nr = Cnr * b^2 * Q * S / (2 * Izz * u0);

A_lat = [Yb/u0 Yp/u0 -(1-Yr/u0) g/u0 * cos(theta0);
         Lb Lp     Lr             0;
         Nb Np     Nr             0;
         0  1      0              0;];

eig(A_lat)
