function h = calcular_heuristica(nodo_a,nodo_b)
%% calcular heuristica
%   Calculo de lo que se tarda en llegar de un nodo A a un nodo B
%   Hay un calculo con distacia euclidea
%   El calculo ideal seria calcular el ETA
    h = sqrt((nodo_a.x - nodo_b.x)^2 + (nodo_a.y - nodo_b.y)^2);

    
%% ETA


end