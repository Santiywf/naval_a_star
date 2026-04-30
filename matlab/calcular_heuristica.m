function h = calcular_heuristica(nodo_a,nodo_b, sogA, sogB)
%% calcular heuristica
%   Calculo de lo que se tarda en llegar de un nodo A a un nodo B
%   Hay un calculo con distacia euclidea
%   El calculo ideal seria calcular el ETA con la distancia de circulo
%   maximo
    %distancia = sqrt((nodo_a.x - nodo_b.x)^2 + (nodo_a.y - nodo_b.y)^2);
    
    %% ETA
    R = 3440.065; 
    
    lat1 = deg2rad(nodo_a.y);
    lon1 = deg2rad(nodo_a.x);
    lat2 = deg2rad(nodo_b.y);
    lon2 = deg2rad(nodo_b.x);
    
    dlat = lat2 - lat1;
    dlon = lon2 - lon1;
    
    a = sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2;

    c = 2*atan2(sqrt(a), sqrt(1 - a));

    distancia = R * c;
    


    h = 2*(distancia)/(sogA + sogB);
    

end