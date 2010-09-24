function XDOT = Geo_model(X,U)

%GEO_MODEL Full 6 DOF model for GeoSurv II aircraft
%
% [XDOT] = GEO_MODEL(X,U) returns the state derivatives, XDOT, given the
% current state and inputs, X and U. The constants are the nominal
% constants.
%
% State vector X and input vector U is defined as
%
% X = [u;v;w;p;q;r;phi;theta;psi] = [x1;x2;x3;x4;x5;x6;x7;x8;x9]
% U = [d_A;d_E;d_R;d_th] = [u1;u2;u3;u4]
%
%
%Created by Christopher Lum
%lum@u.washington.edu
%Modified for GeoSurv II aircraft by Guillaume Blouin


%-----------------------CONSTANTS-------------------------------
%Unit conversions
lb_to_kg = 0.45359237; %Unit conversion (pounds to kilograms)
in_to_m = 0.0254; %Unit conversion (inches to meters)
ft_to_m = 0.3048; %Unit conversion (feet to meters)
kt_to_ms = 0.514444; %Unit conversion (knots to meters/second)
slug_to_kg = 14.593903; %Unit conversion (slugs to kilograms)

%Mass moments of inertia
Ixx = 25.2589*slug_to_kg*ft_to_m^2;
Iyy = 32.8379*slug_to_kg*ft_to_m^2;
Izz = 47.0740*slug_to_kg*ft_to_m^2;
Ixz = 0*slug_to_kg*ft_to_m^2;

%Nominal vehicle constants (problem 1)
m = 186*lb_to_kg;       %Aircraft total mass (kg)
cbar = 27*in_to_m;      %Mean Aerodynamic Chord (m)
lt = 108.55*in_to_m;    %Distance by AC of tail and body (m)
S = 36*ft_to_m^2;       %Wing planform area (m^2)
St = 9.5*ft_to_m^2;     %Tail planform area (m^2)
i = -2*pi/180;          %Tail incidence angle (rad)
AR = 7.11;              %Aspect ratio
e = 0.836;              %Oswalt's efficiency factor

Xcg = 0.25*cbar;        %x position of CoG in Fm (m)
Ycg = 0;                %y position of CoG in Fm (m)
Zcg = 0.037*cbar;       %z position of CoG in Fm (m)

%Engine inputs
Xapt = 0;               %x position of engine force in Fm (m)
Yapt = 0;               %y position of engine force in Fm (m)
Zapt = 0.1405;          %z position of engine force in Fm (m)
                        
%Other constants        
rho = 1.225;            %Air density (kg/m^3)
g = 9.81;               %Gravitational acceleration (m/s^2)
depsda = 0.33;          %Change in downwash w.r.t. alpha (rad/rad)
alpha_L0 = -4*pi/180;   %Zero lift angle of attack (rad)

%Stability Derivatives (output from Justin Koning's Linear Model)
CXu = -0.096;
CXa = 0.15632;
CXadot = 0;
CXq = 0;
CXde = 0;

CZu = -0.85219;
CZa = -5.9298;
CZadot = -1.1763;
CZq = -5.6462;
CZde = -0.50358;

Cmu = 0;
Cma = -0.6094;
Cmadot = -4.496;
Cmq = -14.9865;
Cmde = -1.9304;

CYb = -0.5291;
CYbdot = 0;
CYp = 0.022775;
CYr = 0.4475;
CYda = 0;
CYdr = 0.13127;

Clb = -0.029855;
Clp = -0.49849;
Clr = 0.12639;
Clda = 0.2091;
Cldr = 0.0046136;

Cnb = 0.20858;
Cnbdot = 0;
Cnp = -0.057436;
Cnr = -0.21178;
Cnda = -0.006211;
Cndr = -0.0531;

%Convert CZ to CL
CLu = -CZu;
CLa = -CZa;
CLadot = -CZadot;
CLq = -CZq;
CLde = -CZde;
CLa_t = 3.544;

%Other Stability Derivatives (from AERO database)
CDo = 0.0222;
CMo = -0.1003;


%--------------------------STATE VECTOR----------------------------------
%Extract state vector
x1 = X(1); %u
x2 = X(2); %v
x3 = X(3); %w
x4 = X(4); %p
x5 = X(5); %q
x6 = X(6); %r
x7 = X(7); %phi
x8 = X(8); %theta
x9 = X(9); %psi

u1 = U(1); %d_A (aileron)
u2 = U(2); %d_E (elevator)
u3 = U(3); %d_R (rudder)
u4 = U(4); %d_th (throttle)


%---------------INTERMEDIATE VARIABLES------------------------
%Calculate airspeed
Va = sqrt(x1^2 + x2^2 + x3^2);

%Calculate alpha and beta
alpha = atan(x3/x1);
beta = asin(x2/Va);

%Calculate dynamic pressure
Q = 0.5*rho*Va^2;

%Also define the vectors wbe_b and V_b
wbe_b = [x4;x5;x6];
V_b = [x1;x2;x3];


%---------------AERODYNAMIC FORCE COEFFICIENTS----------------
%Calculate the CL_wb
if Va<(35.6*kt_to_ms)
end

if alpha<= 17*pi*180
	CL_wb=CLa*(alpha-alpha_L0);
elseif alpha>17*pi*180
	CL_wb=-5*10^-5*alpha^4+0.0034*alpha^3-0.092*alpha^2+1.1374*alpha-4.2971;
end

%Calculate CL_t
epsilon = depsda*(alpha - alpha_L0);
alpha_t = alpha - epsilon + i + CLq*x5*lt/Va;
CL_t = CLa_t*alpha_t + CLde*u2;

%Total lift force
CL = CL_wb + CL_t*(St/S);

%Total drag force (neglecting tail)
CD = CDo + CL^2/(pi*AR*e);

%Calculate sideforce
CY = CYb*beta + CYdr*u3 + CYr*x6;


%--------------DIMENSIONAL AERODYNAMIC FORCES---------------------
%Calculate the actual dimensional forces. These are in F_s (stability axis)
FA_s = [-CD*Q*S;
        CY*Q*S;
        -CL*Q*S];

%Rotate these forces to F_b (body axis)
C_bs = [cos(alpha) 0 -sin(alpha); 
        0 1 0; 
        sin(alpha) 0 cos(alpha)];

FA_b = C_bs*FA_s;


%-------------AERODYNAMIC MOMENT COEFFICIENTS---------------
%Calculate the moments in Fb. Define eta, dCMdx and dCMdu
eta11 = Clb*beta;
eta21 = CMo - (CLa_t*(St*lt)/(S*cbar))*(alpha - epsilon);
eta31 = Cnb*beta;

eta = [eta11;
       eta21;
       eta31];

dCMdx = (cbar/Va)*[Clp 0 Clr;
                   0 (Cmq*(St*lt^2)/(S*cbar^2)) 0;
                   Cnp 0 Cnr];

dCMdu = [Clda 0 Cldr;
0 (-CLa_t*(St*lt)/(S*cbar)) 0;
0 0 Cndr];

%Now calculate CM = [Cl;Cm;Cn] about Aerodynamic center in Fb
CMac_b = eta + dCMdx*wbe_b + dCMdu*[u1;u2;u3];

%Transfer now to CoG.
CX = -CD*cos(alpha) + CL*sin(alpha);
CZ = -CL*cos(alpha) - CD*sin(alpha);

A = (1/cbar)*[0 CZ -CY; 
              -CZ 0 CX;
               CY -CX 0];

zeta = [(Xcg-0.12*cbar); 
        -Ycg;
        Zcg];

CMcg_b = CMac_b + A*zeta;


%---------------DIMENSIONAL AERODYNAMIC MOMENTS---------------------
%Calculate the dimensional moments in Fb about cg
MAcg_b = CMcg_b*(Q*S*cbar);


%-----------------ENGINE FORCE & MOMENT----------------------------
%Now effect of engine. First, calculate the thrust of engine
F = u4*m*g;

%Assuming that engine thrust is aligned with Fb, we have
FE_b = [F;0;0];

%Now engine moment due to offset of engine thrust from CoG.
mew = [Xcg - Xapt;
Yapt - Ycg;
Zcg - Zapt];


MEcg_b = cross(mew,FE_b);


%--------------------GRAVITY EFFECTS--------------------------------
%Calculate gravitational forces in the body frame. This causes no moment
%about CoG.
g_b = [-g*sin(x8);
        g*cos(x8)*sin(x7);
        g*cos(x8)*cos(x7)];

Fg_b = m*g_b;


%-------------------STATE DERIVATIVES------------------------------
%Inertia matrix
Ib = m*[Ixx 0 Ixz;
        0 Iyy 0;
        Ixz 0 Izz];

%Inverse of inertia matrix
invIb = inv(Ib);

%Form F_b (all the forces in Fb) and calculate udot, vdot, wdot
F_b = Fg_b + FE_b + FA_b;
x1to3dot = (1/m)*F_b - cross(wbe_b,V_b);

%Form Mcg_b (all moments about CoG in Fb) and calculate pdot, qdot, rdot.
Mcg_b = MAcg_b + MEcg_b;
x4to6dot = invIb*(Mcg_b - cross(wbe_b,Ib*wbe_b));

%Calculate phidot,thetadot, and psidot
H_phi = [1 sin(x7)*tan(x8) cos(x7)*tan(x8);
         0 cos(x7) -sin(x7);
         0 sin(x7)/cos(x8) cos(x7)/cos(x8)];

x7to9dot = H_phi*wbe_b;

%Place in first order form
XDOT = [x1to3dot(1); %udot
x1to3dot(2);         %vdot
x1to3dot(3);         %wdot
x4to6dot(1);         %pdot
x4to6dot(2);         %qdot
x4to6dot(3);         %rdot
x7to9dot(1);         %phidot
x7to9dot(2);         %thetadot
x7to9dot(3)];        %psidot
