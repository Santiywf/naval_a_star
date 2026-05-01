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
    
    dxF = nodo_final.x - ship0.position(1);
    dyF = nodo_final.y - ship0.position(2);
    
    cog_hacia_final = mod(atan2d(dxF, dyF), 360);
    sog_final = predecir_sog(ship0.COG, cog_hacia_final, ship0.SOG);


    % Nodo inicial
    nodo0 = nodo();
    nodo0.x = ship0.position(1);
    nodo0.y = ship0.position(2);
    nodo0.g = 0;
    nodo0.h = calcular_heuristica(nodo0, nodo_final, ship0.SOG, sog_final);
    nodo0.f = nodo0.g + nodo0.h;

    lista = [lista, nodo0];
    
    % Objeto para evaluar las posiciones siguientes
    ship_v = ship();
    ship_v.id = ship0.id;
    ship_v.position = ship0.position;
    ship_v.SOG = ship0.SOG;
    ship_v.COG = ship0.COG;


    obs = [];

    for i = 1:length(obstaculos)
        obs_v = ship();
        obs_v.id = obstaculos(i).id;
        obs_v.position = obstaculos(i).position;
        obs_v.SOG = obstaculos(i).SOG;
        obs_v.COG = obstaculos(i).COG;

        obs = [obs, obs_v];
    end

    while not(isempty(lista))
        
        % tomar el nodo de menor costo
        [~, min_indice] = min([lista.f]);
        nodo_actual = lista(min_indice);
        
        %comprobacion de si se ha llegado al destino
        if norm([nodo_actual.x - nodo_final.x, nodo_actual.y - nodo_final.y]) < 0.5
            disp('RUTA ENCONTRADA');
            path = trackback(nodo_actual);
            return;
        end

        %en caso de no haber llegado se marca como visitado
        lista(min_indice) = [];
        nodo_actual.visitado = true;

        % obtener nodos adyacentes
        %disp(["Obteniendo vecinos del nodo", num2str(nodo_actual.x), ", ", num2str(nodo_actual.y)]);
        vecinos = obtener_vecinos(nodo_actual, grid_nodos, ship_v.COG);
        fprintf('Vecinos encontrados: %d, nodo: %g, %g\n', length(vecinos), nodo_actual.x, nodo_actual.y);
        for i = 1:length(vecinos)
            vecino = vecinos(i);

            if vecino.visitado
                continue;
            end

            dx = vecino.x - nodo_actual.x;
            dy = vecino.y - nodo_actual.y;
            
            cog_hacia_vecino = mod(atan2d(dx, dy), 360);
            
            sog_vecino = predecir_sog(ship_v.COG, cog_hacia_vecino, ship0.SOG);
            costo_paso = calcular_heuristica(nodo_actual, vecino, ship0.SOG, sog_vecino);
            g_next = nodo_actual.g + costo_paso;

            ship_v.position = [vecino.x vecino.y];
            ship_v.SOG = sog_vecino;
            ship_v.COG = cog_hacia_vecino;

            % =======================================================
            % INYECCIÓN DEL PAPER: FILTROS DE SEGURIDAD (CRI y COLREG)
            % =======================================================
            %1. Verificar Zona de Penalización (COLREGs)
            for j = 1:length(obstaculos)
                obs_v = ship();
                obs_v.id = obstaculos(j).id;
                obs_v.position = obstaculos(j).position;
                obs_v.SOG = obstaculos(j).SOG;
                obs_v.COG = obstaculos(j).COG;
                
                distancia_recorrida = obs_v.SOG * g_next; 
    
                obs_vx = obs_v.position(1) + distancia_recorrida * sind(obs_v.COG);
                obs_vy= obs_v.position(2) + distancia_recorrida * cosd(obs_v.COG);

                obs_v.position = [obs_vx obs_vy];

                obs(j) = obs_v;
            end
            
            % for j = 1:length(obs)
            %     if in_penalty_zone(vecino, obs(j))
            %         dis("penalty")
            %         continue;
            %     end
            % end
            % 
            % %2. Verificar Riesgo de Colisión (CRI)
            % for j = 1:length(obs)
            %     cri = CRI(ship_v, obs(j), L);
            %     if cri >= 0.7
            %         cri
            %         continue;
            %     end
            % end
            % =======================================================
            
            %en caso de haber un camino mas rapido a ese vecino
            if g_next < vecino.g
                %actualizacion de valores
                vecino.parent = nodo_actual;
                vecino.g = g_next;
                vecino.h = calcular_heuristica(vecino, nodo_final, ship0.SOG, sog_vecino);
                vecino.f = vecino.g + vecino.h;

                if ~ismember(vecino, lista)
                    lista = [lista, vecino];
                    disp(['Nodos en lista: ', num2str(length(lista))]);
                end

            end
        end
    end

    %si el bucle terminase y la lista esta vacia -> no hay ruta obtenible
    path = [];
    disp('No se ha encontrado una RUTA');
