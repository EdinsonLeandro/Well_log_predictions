function Z=eval_ag_lineal(X,c,P)
% Z=eval_ag_lineal(X,c,num) Realiza el cálculo del registro de salida "Z",
% utilizando coeficientes de una ecuación lineal [c(1),c(2),...,c(n)] de 
% la forma:
%
% Z=c(1)*X(:,1) + c(2)*X(:,2) + ... + c(n)*X(:,n)
%
% Donde "X" son los registros de entrada del algoritmo.

global pred num pred_control

if P==1
    pos=pred;
elseif P==2
    pos=pred_control;
end

% W: Vector que contiene el registro final predicho 
%        del Pozo de entrenamiento.
W=X(:,pos);
Z=zeros(size(W,1),num);
for i=1:num
    Z(:,i)=c(i).*(W(:,i));
end
Z=sum(Z,2);