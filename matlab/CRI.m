function cri = CRI(ship0,obstaculo, L0)
%% Funcion de calculo del CRI(Collision Risk Index) 
%   se calcula el indice de riesgo de colision entre el barco propio y el
%   barco objetivo
%   S0, V0, phi0 -> posicion, velocidad y rumbo del barco de origen
%   obstaculo -> objeto ship que representa el barco con el que se ha de
%   caluclar el CRI
%   L0 -> eslora barco de origen

%% CALCULO VARIABLES PARA CRI

S0 = ship0.position;
V0 = ship0.SOG;
phi0 = ship0.COG;

ST = obstaculo.position;
VT = obstaculo.SOG;
phiT = obstaculo.COG;

% aT -> Azimuth
dx = ST(1) - S0(1);
dy = ST(2) - S0(2);
aT = atan2(dx ,dy);

% DR -> Relative Distance
DR = sqrt((ST(1) - S0(1))^2 + (ST(2) + S0(2))^2);

% Velocidades descompuestas en ejes
% VT
VTx = VT*sin(phiT);
VTy = VT*cos(phiT);
% V0
V0x = V0*sin(phi0);
V0y = V0*cos(phi0);
% VR
VRx = VTx - V0x;
VRy = VTy - V0y;

% VR -> Relative Velocity
VR = sqrt(VRx^2 + VRy^2);

% phiR -> Rumbo relativo
if VRx >= 0 && VRy >= 0
    phiR = atan(VRx/VRy);
    phiR = rad2deg(phiR);
elseif VRx >= 0 && VRy <= 0
    phiR = atan(VRy/VRx);
    phiR = rad2deg(phiR) + 90;
elseif VRx <= 0 && VRy <= 0
    phiR = atan(VRx/VRy);
    phiR = rad2deg(phiR) + 180;
elseif VRx <= 0 && VRy >= 0
    phiR = atan(VRy/VRx);
    phiR = rad2deg(phiR) + 270;
else 
    error('Hay algun error en las velocidades, porque no se cumple ninguna condicion para obtener el rumbo')
end

% thetaT -> Marcacion relativa
thetaT = aT - phiT;

% DCPA -> Distance at closest point of approach
DCPA = DR * sin(thetaR - aT - pi);

% TCPA -> Time at closest point of approach
TCPA = DR * (cos(thetaR - aT - pi))/VR;


% D1 -> Distance of last action
D1 = (8 - 12)*L0;

% D2 -> Distance of action
D2 = 1.7*cos((thetaT - 19)*pi/180) + sqrt(4.4 + 2.89*(cos((thetaT - 19)*pi/180))^2);

% C -> Collision angle (0 <= C <= 180)
C = acos((V0x*VTx + V0y*VTy)/sqrt((Vox^2 + V0y^2)*(VTx^2 + VTy^2)));
C = C*180/pi; % Se pasa a grados porque es como se evalua en la literatura

% d1 -> Smallest encounter distance
if thetaT  >= 0 && thetaT < 112.5*pi/180
    d1 = 1.1-0.2*thetaT/180;
elseif thetaT >= 112.5 && thetaT < 180
    d1 = 1.0 - 0.4*thetaT/180;
elseif thetaT >= 180 && thetaT < 247.5
    d1 = 1.0 - 0.4*(360 - thetaT)/180;
elseif thetaT >= 247.5 && thetaT <= 360
    d1 = 1.1 - 0.2*(360 - thetaT)/180;
else
    error('No se puede calcular d1, revise las condiciones');
end

% d2 -> Absolute safest encounter distance
d2 = 2*d1;

% t1 -> Ship collision time
if abs(DCPA) <= D1 
    t1 = (sqrt(D1^2 -DCPA^2))/Vr;
elseif abs(DCPA) > D1
    t1 = (D1 -abs(DCPA))/Vr;
else
    error('error calculando t1, revise DCPA');
end

% t2 -> Avoidance time
t2 = (sqrt(12^2 - DCPA^2))/Vr;

%% CALCULO uDCPA
if abs(DCPA) <= d1
    uDCPA = 1;
elseif abs(DCPA) >= d1 && abs(DCPA) <= d2 
    uDCPA = 0.5-0.5*sin(pi/(d2 - d1)*(abs(DCPA)-(d2 + d1)/2));
elseif abs(DCPA) > d2
    uDCPA = 0;
else
    error('No se ha podido calcular correctamente uDCPA, revise los valores para cumplir las condiciones')
end

%% CALCULO uTCPA
if t1>=abs(TCPA)
    uTCPA = 1;
elseif t1< abs(TCPA) && abs(TCPA) <= t2
    uTCPA = ((t2 - abs(TCPA)/(t2 - t1)))^2;
elseif abs(TCPA) >= t2
    uTCPA = 0;
else
    error('No se ha podido calcular correctamente uTCPA, revise los valores para cumplir las condiciones')
end

%% CALCULO uDR
if DR >= 0 && DR < D1
    uDR = 1;
elseif DR >= D1 && DR <= D2
    uDR = ((D2 - DR)/(D2 - D1))^2;
elseif DR > D2 
    uDR = 0;
else
    error('No se ha podido calcular correctamente uDR, revise los valores para cumplir las condiciones');
end

%% CALCULO u0T y uE
u0T = 0.5*(cos(thetaT - (19*pi/180)) + sqrt(440/289 + (cos(thetaT - 19*pi/180))^2)) - 5/17;

uE = 1/(1+(2/E*sqrt(E*E+1+2*E*sin(C))));

%% CALCULO FINAL CRI
U = [uDCPA uTCPA uDR u0T uE];
W = [0.4,0.367,0.133,0.067,0.033];
cri = W * U;

end
