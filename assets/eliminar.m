function X=eliminar(reg)
% Función que excluye puntos de los registros de pozo.
% 
% X=eliminar(reg) arroja una matriz X cuyas columnas contiene los
% registro de pozo sólo con los puntos donde hubo medición común (entre 
% los registros de entrada de los algoritmos), exceptuando el registro 
% del que se quiere efectuar su predicción (con la finalidad de completarlo).
% 
%  reg: Matriz que contiene todos los registros originales.

global obj

error(nargchk(1,3,nargin));

if size(reg,2) < 2
    error('La matriz indicada debe tener al menos un registros de pozo')
end

C=reg;

% Sustitución de los elementos nulos en el registro por -Infinito
for i=1:size(C,1)
    for j=1:size(C,2)
        % -10 indica que en un registro no hay números negativos válidos
        if C(i,j)<-10
            C(i,j)=-Inf;
        end
    end
end

% Cálculo de la Matriz X.

if nargin == 1
    X=reg(sum(C,2)>=0,:);
else
    % La columna en la posición "obj" se borra debido a que se exeptúan los 
    % puntos del registro a predecir
    
    if ~isnumeric(obj)
        error('La posición indicada debe ser un número')
    end

    if obj > size(reg,2)
        error('prog:input','La matriz reg tiene menos columnas que el número "%s"',inputname(2));
    end   
    C(:,obj)=[];
    X=reg(sum(C,2)>=0,:);
end