%
% Wrapper script to run the nonlinear Simulink model
% Aaron Holtzman <aaron@holtzman.ca>
%

% Find the trim values Uo 
[Xo Uo] = Geo_Find_Trim(@Geo_cost);
Uo(1) = 0; % Zero the aileron input

% Run the sim
u = [0 zeros(1,4)];
initial_pos = [[44.98 -76.96] * pi / 180 0]; % lat/long
[simout] = sim('GeoSurvII_NonLinear_Signal', 'SaveOutput','on','OutputSaveName','xout','SaveFormat','array');
t = simout.get('tout');
xout = simout.get('xout');
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

% Plot the outputs
figure(1)
subplot(3,1,1)
plot(t, u, t, v, t, w);
legend('u','v','w');
subplot(3,1,2)
plot(t, p, t, q, t, r);
legend('p','q','r');
subplot(3,1,3)
plot(t, phi, t, theta, t, psi);
legend('\Phi','\theta','\psi');
figure(2)
subplot(2,1,1);
plot(x, y);
title('Groundtrack');
xlabel('Latitude (degrees)');
ylabel('Longitude (degrees)');
subplot(2,1,2);
plot(t, z);
title('Altitude');
xlabel('Time (s)');
ylabel('Alititude (m)');
