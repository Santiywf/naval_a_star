function [path] = A_starCRI(nodo0,nodo_final, grid_nodos, obstaculos)
    
    lista = []; % Vector de nodos

    % Nodo inicial
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
            % 1. Verificar Zona de Penalización (COLREGs)
            % if esta_en_zona_penalizacion(neighbor, targetShips)
            %     continue;
            % end
            %
            % 2. Verificar Riesgo de Colisión (CRI)
            % cri = calcular_CRI(neighbor, targetShips);
            % if cri >= 0.7
            %     continue;
            % end
            % =======================================================

            %calculo costo temporal para moverse al vecino(ETA)
            costo_paso = distancia(nodo_actual, vecino);
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
