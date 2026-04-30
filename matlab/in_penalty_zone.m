function pos = in_penalty_zone(nodo, targetShip)
%% in_penalty_zone
%   calcula si el nodo objetivo esta en la zona de penalizacion del barco
%   objetivo
%   nodo -> nodo objetivo a evaluar
%   targetShip -> barco objetivo a evitar

    pos = false;

    R_penalizacion = targetShip.SOG*12/60;

    dx = nodo.x - targetShip.position(1);
    dy = nodo.y - targetShip.position(2);

    distancia = sqrt(dx^2 + dy^2);

    if distancia > R_penalizacion
        return
    end

    area_pen_min = -112.5;
    area_pen_max = 5;

    a = atan2(dy, dx);

    a = rad2deg(a);

    a = mod(a, 360);

    diff = mod(a - targetShip.COG + 180, 360) - 180;

    if diff >= area_pen_min && diff <= area_pen_max
        pos = true;
        return
    end

end