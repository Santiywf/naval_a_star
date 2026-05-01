classdef ship < handle
    %% ship
    %   objeto barco para usar en la malla

    properties
        id              % Nombre o ID del buque
        position        % Vector [x y]
        SOG             % Speed Over Ground (Velocidad en nudos)
        COG             % Course Over Ground (Rumbo en grados, 0-360)
    end

    methods
        function obj = Ship(id, pos, sog, cog)
            obj.id = id;
            obj.position = pos;
            obj.SOG = sog;
            obj.COG = cog;
        end
    end
end