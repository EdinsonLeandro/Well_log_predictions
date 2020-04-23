function X=normalizacion(V,W)
% X = normalizacion(V,W) realiza la normalización de registros de pozo, de 
% acuerdo a la función propuesta por Rafael Banchs, 2001.
% 
% Parámtros de Entrada:
% V: Matriz que contiene los registros a normalizar (incluyendo
% profundidad).
% W: Matriz que contiene los registros en el área de estudio
% 
% Parámetro de Salida:
% X: Matriz que contiene cada registro normalizado

% desv: Desviación de cada registro. Es la diferencia de éste y su promedio
%       en el area de estudio
desv=zeros(size(V));
for i=2:size(V,2)
    desv(:,i)=V(:,i)-mean(W(:,i));
end
maxdesv=max(abs(desv));

% X: Matriz que contiene cada Registro Normalizado
X=zeros(size(V));
for i=2:size(V,2)
    X(:,i)=((V(:,i)-mean(W(:,i)))/maxdesv(i))+1;
end
