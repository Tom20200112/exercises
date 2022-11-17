function [Brho,Bz] = Bhemholtz(I,a,r,z)
% Bhemholtz Computes the rho and z components of the magnetic field induced
% by a Hemholtz coil with radius "a" and current "I", at (r,z) in cylindrical coordinates.
% The Hemholtz coil consists of an upper current loop and a lower current
% loop, both horizontal, with centers at (0,0) and (0,2a) in cylindrical
% coordinates.

syms cosine;
syms rsym;
syms n;

Br_larger=I*a/(2*rsym)*symsum((-1)^n*(gamma(2*n+2)/(gamma(n+1)*2^n))/(2^n*gamma(n+1))*a^(2*n+1)/rsym^(2*n+2)...
    *legendreP(2*n+1,cosine),n,[0 10]);
Br_smaller=I*a/(2*rsym)*symsum((-1)^n*(gamma(2*n+2)/(gamma(n+1)*2^n))/(2^n*gamma(n+1))*rsym^(2*n+1)/a^(2*n+2)...
    *legendreP(2*n+1,cosine),n,[0 10]);

Btheta_larger=-I*a^2/4*symsum((-1)^n*(gamma(2*n+2)/(gamma(n+1)*2^n))/(2^n*gamma(n+2))*1/rsym^3*(a/rsym)^(2*n)...
    *(-sqrt(1-cosine^2)*diff(legendreP(2*n+1,cosine),cosine)),n,[0 10]);
Btheta_smaller=-I*a^2/4*symsum((-1)^n*(gamma(2*n+2)/(gamma(n+1)*2^n))/(2^n*gamma(n+2))*(-(2*n+2)/(2*n+1)*1/a^3*(rsym/a)^(2*n))...
    *(-sqrt(1-cosine^2)*diff(legendreP(2*n+1,cosine),cosine)),n,[0 10]);

costheta1 = z/sqrt(r^2+z^2);                 % theta represented in spherical coordinates with respect to the lower current loop 
costheta2 = (z-2*a)/sqrt((z-2*a)^2+r^2);     % theta represented in spherical coordinates with respect to the upper loop 

r1=sqrt(r^2+z^2);
r2=sqrt((z-2*a)^2+r^2);

% Calculates Br1 and Btheta1, radial and angular component of the magnetic field induced by the lower loop, 
% r measured with respect to the center of the lower loop.
if r1>=a
    Br1=subs(Br_larger,[rsym cosine],[r1 costheta1]);
    Btheta1=subs(Btheta_larger,[rsym cosine],[r1 costheta1]);
else 
    Br1=subs(Br_smaller,[rsym cosine],[r1 costheta1]);
    Btheta1=subs(Btheta_smaller,[rsym cosine],[r1 costheta1]);
end

% Calculates Br2 and Btheta2, radial and angular component of the magnetic field induced by the upper loop, 
% r measured with respect to the center of the upper loop.
if r2>=a
    Br2=subs(Br_larger,[rsym cosine],[r2 costheta2]);
    Btheta2=subs(Btheta_larger,[rsym cosine],[r2 costheta2]);
else
    Br2=subs(Br_smaller,[rsym cosine],[r2 costheta2]);
    Btheta2=subs(Btheta_smaller,[rsym cosine],[r2 costheta2]);
end

Brho=Br1*sqrt(1-costheta1^2)+Btheta1*costheta1+Br2*sqrt(1-costheta2^2)...
    +Btheta2*costheta2;
Bz=Br1*costheta1-Btheta1*sqrt(1-costheta1^2)+Br2*costheta2...
    -Btheta2*sqrt(1-costheta2^2);

end

