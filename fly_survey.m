function fly_survey()
%
% Wrapper script to run the nonlinear Simulink model
% Aaron Holtzman <aaron@holtzman.ca>
%

addpath flight_model

% Initial conditions
kt_to_ms = 0.514444;
Xo = zeros(9,1);
Xo(1) = 60*kt_to_ms;                    %u
Xo(2) = 0;                              %v
Xo(3) = 0;                              %w
Xo(4) = 0;                              %p
Xo(5) = 0;                              %q
Xo(6) = 0;                              %r
Xo(7) = 0;                              %phi
Xo(8) = 0;                              %theta
Xo(9) = 0;                              %psi


% Run the sim
initial_pos = [[44.9550 -76.9603] * pi / 180 1000]; % lat/long
assignin('base', 'Xo', Xo);
assignin('base', 'initial_pos', initial_pos);
mdl = 'gsII_uas';
set_param(mdl,'SaveOutput','on','OutputSaveName','xout','SaveFormat','array');
sim(mdl, 50, []);
t = tout;
X = xout(:,1:9);
pos = xout(:,10:12);
U = xout(:,13:16);

% unpack the sim output
u = X(:,1);
v = X(:,2);
w = X(:,3);
p = X(:,4);
q = X(:,5);
r = X(:,6);
phi   = X(:,7);
theta = X(:,8);
%psi   = -X(:,9) + pi;
psi = atan2(sin(X(:,9) + pi/2),-cos(X(:,9) + pi/2));

x = pos(:,2) * 180 / pi; % latitude in degrees
y = pos(:,1) * 180 / pi; % longitude in degrees
z = pos(:,3);            % altitude in metres
y(1:10)

alpha = atan2(w, u);
airspeed = sqrt(u.^2 + v.^2 + w.^2);
beta = asin(v ./ airspeed);

hold on;
plot(x, y,'r');
hold off

% Plot the outputs
figure(2) 
subplot(3,1,1) 
plot(t, u, t, v, t, w); 
legend('u','v','w'); 
subplot(3,1,2) 
plot(t, p, t, q, t, r); 
legend('p','q','r'); 
subplot(3,1,3) 
%plot(t, phi, t, theta); 
%legend('\Phi','\theta'); 
plot(t, psi);
figure(3)    
subplot(2,1,1); 
plot(x, y, 'k'); 
title('Groundtrack'); 
xlabel('Latitude (degrees)'); 
ylabel('Longitude (degrees)'); 
axis equal
hold on
line_x = [-76.9603  -76.9758];
line_y = [ 44.9550   44.9997];
line(line_x, line_y);
hold off

subplot(2,1,2); 
plot(t, z); 
title('Altitude'); 
xlabel('Time (s)');
ylabel('Alititude (m)');

figure(4)
subplot(3,1,1)
title('Controls');
plot(t, U(:,1) * 180 / pi, t, U(:,2) * 180 / pi, t, U(:,3) * 180 / pi, t, U(:,4))
legend('Aileron','Elevator','Rudder', 'Throttle'); 
ylabel('Angle (degrees)');
subplot(3,1,2)
plot(t, airspeed .* 0.5144);
ylabel('Airspeed (kts)');
subplot(3,1,3)
plot(t, alpha * 180 / pi, t, beta * 180 / pi);
ylabel('Angle (degrees)');
legend('Alpha', 'Beta');

