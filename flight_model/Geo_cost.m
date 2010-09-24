function J=Geo_cost(XU);
X=XU(1:9);
U=XU(10:13);
%unit conversion
kt_to_ms = 0.514444;
%calculate derivative of states
xd=Geo_model(X,U);
% add extra constraints for straight and level flight
a=atan2(X(3),X(1));
theta=X(8);
Va=sqrt(X(1)^2+X(2)^2+X(3)^2);
V=60*kt_to_ms;
Q=[xd;Va-V;(theta-a)];
J=Q'*Q;
