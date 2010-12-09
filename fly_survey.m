function fly_survey()
%
% Wrapper script to run the nonlinear Simulink model
% Aaron Holtzman <aaron@holtzman.ca>
%

addpath flight_model

% Find the trim values Uo 
[Xo Uo] = Geo_Find_Trim(@Geo_cost);
Uo(1) = 0; % Zero the aileron input

% Run the sim
ut = [0 zeros(1,4)];
initial_pos = [[44.98 -76.96] * pi / 180 0]; % lat/long
assignin('base', 'Uo', Uo);
assignin('base', 'Xo', Xo);
assignin('base', 'initial_pos', initial_pos);
mdl = 'gsII_uas';
set_param(mdl,'SaveOutput','on','OutputSaveName','xout','SaveFormat','array');
sim(mdl, 60, [], ut);
%t = simout.get('tout');
%xout = simout.get('xout');
X = xout(:,1:9);
pos = xout(:,10:12);

% unpack the sim output
u = X(:,1);
v = X(:,2);
w = X(:,3);
p = X(:,4);
q = X(:,5);
r = X(:,6);
phi   = X(:,7);
theta = X(:,8);
psi   = X(:,9);
x = pos(:,1) * 180 / pi; % latitude in degrees
y = pos(:,2) * 180 / pi; % longitude in degrees
z = pos(:,3);            % altitude in metres

hold on;
plot(x, y,'r');
