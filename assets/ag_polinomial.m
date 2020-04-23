function coef=ag_polinomial(PE_AEN,seleccion,opciones)
% Función que determina los parámetros, mediante ALGORITMOS GENÉTICOS, de
% la función polinómica:
% f(x)=x(1)*y(:,1)^x(2) + x(3)*y(:,2)^x(4) + ... + x(n+1)*y(:,n)^x(n+2)
%
% Donde: x(1), x(2) ... x(n)        parámetros a optimizar. Los números
%                                   impares corresponden a los coeficientes
%                                   y los pares a los exponentes.
%        y(:,1), y(:,2) ... y(:,n)  registros de pozo para la predicción
%
% coef=ag_polinomica(PRED,PE_AEN,obj,seleccion,opciones) Calcula los
% coeficientes "coef" que mejor relacionan a los elementos del(los) 
% registro(s) de entrada con el de salida.
% Donde:
%     PE_AEN: Registros normalizados en el área de entrenamiento.
%  seleccion: vector que indica las posiciones (escogidas aleatoriamente)
%             del 50% de los datos seleccionados para el entrenamiento
%   opciones: estructura que contiene las opciones a utilizar en el
%             entrenamieto del algoritmo genético

global obj pred num

% Matriz ENT: contiene los datos de entrada para el entrenamiento 
%             del algoritmo.
ENT=PE_AEN(seleccion,pred);

% FIN: Vector que contiene el registro a calcular mediante el algoritmo,
%      en los mismos puntos que la matriz ENT.
FIN=PE_AEN(seleccion,obj);

% coef: coeficientes que brindan el mejor ajuste de la función de
%       entrenamiento
coef=zeros(size(ENT,1),2*size(ENT,2));

% Cálculo del coeficiente (minim) para cada elemento.
h=waitbar(0,'Ajustando mediante Algoritmos Genéticos...');
for i=1:(size(ENT,1))
    minim=ga(@(x) fun_polinomial_entrenamiento(x,i,ENT,FIN),...
        2*num,[],[],[],[],[],[],[],opciones);
    coef(i,:)=minim;
    waitbar(i/(size(ENT,1)),h)
end
close(h)

function Z=fun_polinomial_entrenamiento(x,i,y,w)
% Función de Entrenamiento (a optimizar) de la forma (relacionada
% con el Error Medio Cuadrático):
% f=[(x(1)*y(:,1)^x(2) + x(3)*y(:,2)^x(4) + ... + x(n+1)*y(:,n)^x(n+2))-w]^2
%
% Parámetros de entrada:
% i: Corresponde al número de elemento dentro del ciclo
% y: Matriz en donde cada columna contiene los datos seleccionados para la
%    predicción.
% w: Corresponde al registro medido cuya predicción se desea realizar
%    mediante algortimos genéticos

% x: Coeficientes a optimizar
z=zeros(size(y,1),1);
k=1;
for j=1:size(y,2)
    z(j)=x(k).*(y(i,j)^x(k+1));
    k=k+2;
end
zz=sum(z);
Z=(zz-w(i)).^2;
