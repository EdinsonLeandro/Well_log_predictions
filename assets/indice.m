function r=indice(X,p)
% r = indice(X,p) busca el numero de fila (posicion) en que se encuentra 
% el numero "p" dentro del vector X (siendo un vector fila o columna)

r=0;
for i=1:size(X)
    if X(i)==p
       r=i;
    end
end

if r==0
    disp('Este elemento no se encuentra en el vector')
end
