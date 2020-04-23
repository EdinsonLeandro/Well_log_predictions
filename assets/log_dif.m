function [FIS,ENT]=log_dif(PE_AEN,seleccion)
% Funcion que genera un FIS mediante la utilizacion de ANFIS, que mejor
% ajuste el(los) registro(s) de entrada con el de salida.

global pred obj

% Matriz ENT: contiene los datos para el entrenamiento. Su ultima columna 
%             debe corresponderse con los valores de salida 
%             (Registro que se desea predecir)
ent=PE_AEN(:,pred);
ent(:,end+1)=PE_AEN(:,obj);
ENT=ent(seleccion,:);

% Crea el archivo a ser leido por ANFIS, denominado "Entrenamiento ANFIS"
DS=dataset(ENT);
export(DS,'File','Entrenamiento ANFIS','Delimiter','tab','WriteVarNames',false);

% Llamada al editor de anfis
anfisedit

adv=warndlg('Presione OK o cierre esta ventana al finalizar ANFIS',...
    'Advertencia');
waitfor(adv)

% Al finalizar el editor, se ha de guardar un archivo .fis, el cual tiene 
% los datos del entrenamiento
% A continuacion, se desplegara una ventana en la que ha de escogerse el
% archivo .fis creado

FIS=readfis;

    % Se procedera en cada caso a evaluar los datos de entrada dentro del 
    % Sistema de Inferencia Difusa para de esta manera realizar la prediccion
    
    % epoch_n = 200;
    % in_fis  = genfis1(ENT,[3 3],'gaussmf','linear');
    % FIS = anfis(ENT,in_fis,epoch_n); 
