function [path] = A_starCRI(ship0, nodo_final, grid_nodos, obstaculos, L)
%% A_starCRI
%   calcula el camino mas optimo para poder evitar uno o varios barcos
%   usando A* y aplicando reglas de navegacion y un indice de colision
%   ship0 -> objeto barco que ha de moverse
%   nodo_final -> punto final al que ha de llegar el barco origen
%   grid_nodos -> mapa de nodos por el que podra moverse el barco
%   obstaculos -> lista de barcos a evitar dentro del grid
%   L -> eslora del barco de origen
    
    lista = []; % Vector de nodos

    % Nodo inicial
    nodo0 = nodo();
    nodo0.x = ship0.position(1);
    nodo0.x = ship0.position(2);
    nodo0.g = 0;
    nodo0.h = calculo_heuristica(nodo0, nodo_final);
    nodo0.f = nodo0.g + nodo0.h;

    lista = [lista, nodo0];

    while not(isempty(lista))
        
        % tomar el nodo de menor costo
        [~, min_indice] = min([lista.f]);
        nodo_actual = lista(min_indice);
        
        %comprobacion de si se ha llegado al destino
        if nodo_actual.x == nodo_final.x && nodo_actual.y == nodo_final.y
            disp('RUTA ENCONTRADA');
            path = trackback(nodo_actual);
            return;
        end

        %en caso de no haber llegado se marca como visitado
        lista(min_indice) = [];
        nodo_actual.visitado = true;

        % obtener nodos adyacentes
        angulo = 112;
        vecinos = obtener_vecinos(nodo_actual, grid_nodos, angulo);

        for i = 1:length(vecinos)
            vecino = vecinos(i);

            if vecino.visitado
                continue;
            end
            
            % =======================================================
            % INYECCIÓN DEL PAPER: FILTROS DE SEGURIDAD (CRI y COLREG)
            % =======================================================
            %1. Verificar Zona de Penalización (COLREGs)
            for j = 1:lenght(obstaculos)
                if in_penalty_zone(neighbor, obstaculos(j))
                    continue;
                end
            end

            %2. Verificar Riesgo de Colisión (CRI)
            for j = 1:length(obstaculos)
                cri = CRI(ship0, obstaculos(j), L);
                if cri >= 0.7
                    continue;
                end
            end
            % =======================================================

            %calculo costo temporal para moverse al vecino(ETA)
            costo_paso = calcular_heuristica(nodo_actual, vecino);
            g_next = nodo_actual.g + costo_paso;
            
            %en caso de haber un camino mas rapido a ese vecino
            if g_next < vecino.g
                %actualizacion de valores
                vecino.parent = nodo_actual;
                vecino.g = g_next;
                vecino.h = calcular_heuristica(vecino, nodo_final);
                vecino.f = vecino.g + vecino.h;

            end
        end
    end

    %si el bucle terminase y la lista esta vacia -> no hay ruta obtenible
    path = [];
    disp('No se ha encontrado una RUTA');
