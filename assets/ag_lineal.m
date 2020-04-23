function coef=ag_lineal(PE_AEN,seleccion,opciones)
% Función que determina los coeficientes, mediante ALGORITMOS GENÉTICOS, de
% la ecuación lineal:
% f(x)=x(1)*y(:,1) + x(2)*y(:,2) + x(n)*y(:,n)
%
% Donde: x(1), x(2) ... x(n)        coeficientes a optimizar
%        y(:,1), y(:,2) ... y(:,n)  registros de pozo para la predicción
%
% coef=ag_lineal(PRED,PE_AEN,obj,seleccion,opciones) Calcula los
% coeficientes "coef" que mejor relacionan a los elementos del(los) 
% registro(s) de entrada con el de salida.
% Donde:
%     PE_AEN: Registros normalizados en el área de entrenamiento.
%  seleccion: vector que indica las posiciones (escogidas aleatoriamente)
%             del 50% de los datos seleccionados para el entrenamiento
%   opciones: estructura que contiene las opciones a utilizar en el
%             entrenamieto del algoritmo genético

global obj pred num

% Matriz ENT: contiene los datos para el entrenamiento del algoritmo.
ENT=PE_AEN(seleccion,pred);

% FIN: Vector que contiene el registro a calcular mediante el algoritmo,
%      en los mismos puntos que la matriz ENT.
FIN=PE_AEN(seleccion,obj);

% coef: coeficientes que brindan el mejor ajuste de la funci�n de
%       entrenamiento
coef=zeros(size(ENT));

% Calculo del coeficiente (minim) para cada elemento.
h=waitbar(0,'Ajustando mediante Algoritmos Genéticos...');
for i=1:(size(ENT,1))
    minim=ga(@(x) fun_lineal_entrenamiento(x,i,ENT,FIN),num,...
        [],[],[],[],[],[],[],opciones);
    coef(i,:)=minim;
    waitbar(i/(size(ENT,1)),h)
end
close(h)

function Z=fun_lineal_entrenamiento(x,i,y,w)
% Funcilon de Entrenamiento del algoritmo genético de la forma (relacionada
% con el Error Medio Cuadrático):
% f=[(x(1)*y(:,1) + x(2)*y(:,2) + x(n)*y(:,n))-w]^2
%
% Parámetros de entrada:
% i: Corresponde al número de elemento dentro del ciclo
% y: Matriz en donde cada columna contiene los datos seleccionados para la
%    predicción.
% w: Corresponde al registro medido cuya predicción se desea realizar
%    mediante algoritmos genéticos

% x: Coeficientes a optimizar
z=zeros(size(y,2),1);
for j=1:(size(y,2))
    z(j)=x(j).*y(i,j);
end

if (size(y,2))==1
    zz=z;
else
    zz=sum(z);
end
Z=(zz-w(i)).^2;
