%% main
%   Lanza varias simulaciones para probar el A*

    nodo_final = nodo(36, 36);
    
    ship0 = ship();
    ship0.id = '0';
    ship0.position = [1, 1];
    ship0.SOG = 3;
    ship0.COG = 45;

    L = 1;
    
    % obstaculo recto en misma direccion sentido contraria
    obstaculo1 = ship();
    obstaculo1.id = '1';
    obstaculo1.position = [16 16];
    obstaculo1.SOG = 2;
    obstaculo1.COG = 225;
    
    % % obstaculo que se va a cruzar pero no esta en la direccion
    % obstaculo2 = ship();
    % obstaculo2.id = '2';
    % obstaculo2.position = [12, 14];
    % obstaculo2.SOG = 5;
    % obstaculo2.COG = 105;
    % 
    % % obstaculos que estan en medio del camino
    % obstaculo3 = ship();
    % obstaculo3.id = '3';
    % obstaculo3.position = [18, 14];
    % obstaculo3.SOG = 12;
    % obstaculo3.COG = 315;
    % 
    % obstaculo4 = ship();
    % obstaculo4.id = '4';
    % obstaculo4.position = [22, 26];
    % obstaculo4.SOG = 10;
    % obstaculo4.COG = 225;

    obs1 = [obstaculo1];
    % obs2 = [obstaculo2];
    % obs3 = [obstaculo3 obstaculo4];

    tam_grid = 100;
    separacion_nodos = 1;
    grid_nodos(tam_grid, tam_grid) = nodo();

    for i = 1:tam_grid
        for j = 1:tam_grid
            
            % Calculamos la posición exacta basándonos en la iteración y en L.
            % Restamos 1 para que el primer nodo (i=1, j=1) quede en el (0, 0).
            pos_x = (j) * separacion_nodos;
            pos_y = (i) * separacion_nodos;
            
            % Instanciamos tu clase nodo y la guardamos en la matriz
            nodo_n = nodo(pos_x, pos_y);
            if nodo_n.x == nodo_final.x && nodo_n.y == nodo_final.y
                disp("El nodo objetivo existe en la malla de nodos");
            end
            grid_nodos(i, j) = nodo_n;
        end
    end

    %disp(['Grid de ', num2str(tam_grid), 'x', num2str(tam_grid), ' creado con éxito.']);


    path1 = A_starCRI(ship0, nodo_final, grid_nodos, obs1, L);

    % path2 = A_starCRI(ship0, nodo_final, grid_nodos, obs2, L);
    % 
    % path3 = A_starCRI(ship0, nodo_final, grid_nodos, obs3, L);
    
    representar_path(1, ship0, obs1, path1);
    % representar_path(2, ship0, obs2, path2);
    % representar_path(3, ship0, obs3, path3);
    

    


