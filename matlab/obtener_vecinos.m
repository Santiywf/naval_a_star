function vecinos = obtener_vecinos(nodo, grid, cog)
%% obtener_vecinos
%   dado un nodo y una matriz de nodos se calcula que nodos son visitables
%   desde el nodo dado, usando una busqueda de +- 112,5 grados

    vecinos = [];

    tam_grid = size(grid, 1);

    i_nodo = nodo.x-grid(1,1).x;
    j_nodo = nodo.y-grid(1,1).y;

    for i = -2:2
        for j = -2:2

            i_vecino = round(i_nodo + i);
            j_vecino = round(j_nodo + j);

            if (i_vecino <  1) || (j_vecino < 1) || (i_vecino > tam_grid) || (j_vecino > tam_grid)
                continue
            end
            
            if j == j_nodo && i == i_nodo + 1
                vecinos = [vecinos, grid(i_vecino, j_vecino)];
            end
            if i == i_nodo && j == j_nodo
                continue
            end
            
            dx = grid(1,1).x - nodo.x;
            dy = grid(1,1).y - nodo.y;
            dist = sqrt(dx^2 +dy^2);

            a = mod(atan2(dx, dy), 360);

            a_relativo = mod(a - cog, 360);

            if a_relativo > 180
                a_relativo = a_relativo - 360;
            end
            
            if a_relativo >= -112.5 && a_relativo <= 112.5
                if a_relativo <= 60 && a_relativo >= -60
                    if a_relativo > -5 && a_relativo <= 5
                        continue
                    else
                        if dist < 6
                            vecinos = [vecinos, grid(i_vecino, j_vecino)];
                        end
                    
                    end
                else
                    if dist < 3
                        vecinos = [vecinos, grid(i_vecino, j_vecino)];
                    end
                end
            end


        end
    end
    
end