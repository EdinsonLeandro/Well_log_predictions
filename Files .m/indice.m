function r=indice(X,p)
% r = indice(X,p) busca el número de fila (posición) en que se encuentra
% el número "p" dentro del vector X (siendo un vector fila o columna)

% i=1;
% while X(i) ~= p
%     i=i+1;
% end
% r=i;

% ATENCIÓN-MEJORAR!!!: EVALUAR BIEN EL FUNCIONAMIENTO DE ESTA FUNCIÓN. SE
% UTILIZA DENTRO DE LA FUNCIÓN DE GRAFICA_REGISTROS
r=0;
for i=1:size(X)
    if X(i)==p
        r=i;
    end
end

if r==0
    disp('Este elemento no se encuentra en el vector')
end