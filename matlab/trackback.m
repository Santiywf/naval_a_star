function path = trackback(nodo)
%% FUNCION DE TRACKBACK
%   Devuelve la ruta final volviendo por el camino de vecinos que se han
%   ido encontrado con menor peso
%   nodo -> nodo a partir del que hacer trackback
path = [];
actual = nodo;

while not(isempty(actual))
    path = [[actual.x, actual.y]; path];
    actual = actual.parent;
end
end