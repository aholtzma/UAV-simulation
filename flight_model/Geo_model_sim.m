%
% Wrapper script to run the nonlinear Simulink model
% Aaron Holtzman <aaron@holtzman.ca>
%

% Find the trim values Uo and run the sim 
Geo_Find_Trim
[t] = sim('GeoSurvII_NonLinear_Signal.mdl', 60);

% unpack the sim output
u = modelout.signals.values(:,1);
v = modelout.signals.values(:,2);
w = modelout.signals.values(:,3);
p = modelout.signals.values(:,4);
q = modelout.signals.values(:,5);
r = modelout.signals.values(:,6);
phi = modelout.signals.values(:,7);
theta = modelout.signals.values(:,8);
psi = modelout.signals.values(:,9);
x = posout.signals.values(:,1) * 180 / pi; % latitude in degrees
y = posout.signals.values(:,2) * 180 / pi; % longitude in degrees
z = posout.signals.values(:,3);            % altitude in metres

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
