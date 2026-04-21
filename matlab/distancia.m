function h = distancia(nodo_a, nodo_b)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
h = sqrt((nodo_a.x - nodo_b.x)^2 + (nodo_a.y - nodo_b.y)^2);
end