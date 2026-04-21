classdef ship < handle
    %% ship
    %   objeto barco para usar en la malla

    properties
        id              % Nombre o ID del buque
        position        % Vector [x, y]
        SOG             % Speed Over Ground (Velocidad en nudos o m/s)
        COG             % Course Over Ground (Rumbo en grados, 0-360)
        length          % Eslora (útil para definir el dominio del buque)
        isOwnShip = false
    end

    methods
        function obj = Ship(id, pos, sog, cog, len, isOS)
            obj.id = id;
            obj.position = pos;
            obj.SOG = sog;
            obj.COG = cog;
            obj.length = len;
            obj.isOwnShip = isOS;
        end
        
        % Función para proyectar posición futura (Cálculo de TCPA)
        function posFutura = getFuturePosition(obj, dt)
            % dt es el tiempo en segundos
            vx = obj.SOG * sind(obj.COG);
            vy = obj.SOG * cosd(obj.COG);
            posFutura = obj.position + [vx, vy] * dt;
        end
    end
end