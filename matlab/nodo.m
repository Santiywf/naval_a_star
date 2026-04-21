classdef nodo < handle
    %%  nodo 
    %   Clase que define los nodos de la malla, y su coste.

    properties
        x                   % coordenada x
        y                   % coordenada y
        g = inf             % costo acumulado(dt desde el inicio)
        h = 0               % heuristica(t estimado hasta el destino final)
        f = inf             % costo total(g + h)
        parent = []         % referencia al nodo anterior(para reconstruir la ruta)
        visitado = false     % para la lista de visitados
    end

    methods
        %CONSTRUCTOR
        function obj = nodo(x, y)
            obj.x = x;
            obj.y = y;
        end

        function reset(obj)
            obj.g = inf;
            obj.h = 0;            
            obj.f = inf;        
            obj.parent = [];     
            obj.visitado = false;  
        end
    end
end