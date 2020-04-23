function Z=eval_ag_polinomio(X,c,P)
% Z=evalag_polinomio(X,c,num) Realiza el cálculo del registro de salida "Z",
% utilizando los parámetros de la función de la forma:
%
% Z=c(1)*X(:,1)^c(2) + c(3)*X(:,2)^c(4) + ... + c(n-1)*X(:,n)^c(n+1)
%
% Donde "X" son los registros de entrada del algoritmo.

global pred num pred_control

if P==1
    pos=pred;
elseif P==2
    pos=pred_control;
end

% W: Vector que contiene el registro final predicho del Pozo de 
%        Entrenamiento.
W=X(:,pos);
Z=zeros(size(W,1),num);
j=1;
for i=1:num
    Z(:,i)=c(j).*((W(:,i)).^c(j+1));
    j=j+2;
end
Z=sum(Z,2);
