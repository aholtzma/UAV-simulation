function [Xo Uo] = Geo_Find_Trim(Geo_cost)

kt_to_ms = 0.514444;
x1 = 60*kt_to_ms;                    %u
x2 = 0;                              %v
x3 = 0;                              %w
x4 = 0;                              %p
x5 = 0;                              %q
x6 = 0;                              %r
x7 = 0;                              %phi
x8 = 0;                              %theta
x9 = 0;                              %psi

u1 = 0;                              %d_A (aileron)
u2 = 0;                              %d_E (elevator)
u3 = 0;                              %d_R (rudder)
u4 = 0;                              %d_th (throttle)
guess=[x1,x2,x3,x4,x5,x6,x7,x8,x9,u1,u2,u3,u4];
trim_values=fminsearch(Geo_cost,guess, optimset('TolX',1e-10,'MaxFunEvals',10000,'MaxIter',10000));

%Xo=trim_values(1:9)
Xo = guess(1:9);
Uo=trim_values(10:13)
