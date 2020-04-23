clc
clear all

% linea 105 y 182
% linea 114
prof1=701;
prof2=1301;

% Constantes que seran utilizadas a lo largo del algoritmo. Por lo que se
% declararan una sola vez

global obj pred num

% Seleccion del registro para la prediccion. Este debe encontrarse entre
% los seleccionados anteriormente.
% obj: numero que indica la columna en que se encuentra el 
%      registro que se ha seleccionado para la prediccion.
obj=3;

% pred: Vector que contiene la posicion del(los) registro(s) para el
%       entrenamiento del algoritmo y posterior prediccion.
pred=[6 7];

% num: Numero de variables independientes para realizar el entrenamiento
%      del algoritmo. Se corresponde con el numero de registros de entrada 
%      para la prediccion
num=size(pred,2);

% Seleccion de la tecnica de prediccion a utilizar
PREDICCION=3;

%% Carga de los Pozos

%---------------------------------%
% Carga del Pozo de Entrenamiento %
%---------------------------------%

% PE: Matriz que contiene los registros del Pozo de Entrenamiento
PE=carga_registro('valoresGF-87N');

% Definicion de los topes de la arena de interes del pozo de entrenamiento
% (en pies).
% tsupPE: Tope Superior
% tinfPE: Tope Inferior
tsupPE=7297.9702; tinfPE=7377.0601;

% Escogencia de los registros con los que cuenta el pozo.
% Arreglo de celdas que contiene los Nombres de los Registros
nombresPE={'Profundidad','Densidad de Bulk','DTs','DTp','Saturacion de Agua',...
    'Porosidad','Volumen de Arcilla'};

% Arreglo de celdas que contiene las unidades en que fueron medidos cada 
% registros
unidadesPE={'(ft)','(g/cc)','(us/ft)','(us/ft)','(v/v)','(fraccion)','(v/v)'};

% Titulo que identifica al pozo
tituloPE='Registros: Pozo GF-87N';

% Si entre estos registros seleccionados se encuentra el Sonico de Onda P
% y/o el de Onda S puede convertirse a Velocidad.

for i=2:size(PE,2)
    if strcmp(nombresPE{i},'DTs')
        % Posicion del Registro DTs en el archivo
        vs=i;
        % Conversion a Registro de Velocidad. El factor 10^6 implica una 
        % modificacion en las unidades de ft/us a ft/s
        PE(:,vs)=10^6*(1./PE(:,vs));
        nombresPE{vs}=('Velocidad Onda S');
        unidadesPE{vs}=('(ft/s)');
    elseif strcmp(nombresPE{i},'DTp')
        % Posicion del Registro DTp en el archivo
        vp=i;
        % Conversion a Registro de Velocidad. El factor 10^6 implica una 
        % modificacion en las unidades de ft/us a ft/s        
        PE(:,vp)=10^6*(1./PE(:,vp));
        nombresPE{vp}=('Velocidad Onda P');
        unidadesPE{vp}=('(ft/s)');
    else
        continue
    end
end

% Graficas de los registros del pozo. Solo se desean graficar las 
% profundidades en las que se haya registrado.
% graficas_registro(PE,nombresPE,unidadesPE,tituloPE,tsupPE,tinfPE);

% En ocasiones, los registros estan incompletos. Por esta razon:
% PEmed: Matriz que contiene todos los registros del Pozo de Entrenamiento
%        solo en las puntos donde hubo medicion
PEmed=eliminar(PE);

% Seleccion de los datos para el entrenamiento. Primero ha de seleccionar
% las lutitas que suprayacen la arena, luego la que le infrayace

% g=ginput(2);
% prof1=indice(PEmed(:,1),round(abs(g(1,2))));
% prof2=indice(PEmed(:,1),round(abs(g(2,2))));

% Primero ha de seleccionarse el tope superior y luego el tope inferior y
% no al reves
if prof1 > prof2
    error('Se debe seleccionar primero el tope superior y luego el inferior')
end

% Matriz PE_AE: contiene cada registro del Pozo de Entrenamiento en el 
%               area de Entrenamiento
PE_AE=PEmed(prof1:prof2,:);

%-----------------------%
% Carga del Pozo Control%
%-----------------------%

% PE: Matriz que contiene los registros del Pozo Control
PC=carga_registro('valoresGF-109N');

% Definicion de los topes de la arena de interes (en pies).
% tsupPC: Tope Superior
% tinfPC: Tope Inferior
tsupPC=8295.0703; tinfPC=8377.0703;

% Arreglo de celdas que contiene los Nombres de los Registros del Pozo
% Control.
% nombresPC={'(ft)','(g/cc)','(us/ft)','(us/ft)','(v/v)','(v/v)','(fraccion)'};

nombresPC={'Profundidad','Densidad de Bulk','DTs','DTp','Volumen de Arcilla',...
    'Saturacion de Agua','Porosidad'};

% Arreglo de celdas que contiene las unidades en que fueron medidos cada 
% registros
unidadesPC={'(ft)','(g/cc)','(us/ft)','(us/ft)','(v/v)','(v/v)','(fraccion)'};

% Titulo que identifica al Pozo
tituloPC='Registros: Pozo GF-109N';

% Si entre estos registros seleccionados se encuentra el Sonico de Onda P
% y/o el de Onda S puede convertirse a Velocidad.

for i=2:size(PC,2)
    if strcmp(nombresPC{i},'DTs')
        % Posicion del Registro DTs en el archivo
        vs=i;
        % Conversion a Registro de Velocidad. El factor 10^6 implica una 
        % modificacion en las unidades de ft/us a ft/s
        PC(:,vs)=10^6*(1./PC(:,vs));
        nombresPC{vs}=('Velocidad Onda S');
        unidadesPC{vs}=('ft/s');
    elseif strcmp(nombresPC{i},'DTp')
        % Posicion del Registro DTp en el archivo
        vp=i;
        % Conversion a Registro de Velocidad. El factor 10^6 implica una 
        % modificacion en las unidades de ft/us a ft/s        
        PC(:,vp)=10^6*(1./PC(:,vp));
        nombresPC{vp}=('Velocidad Onda P');
        unidadesPC{vp}=('ft/s');
    else
        continue
    end
end

% Graficas de los registros del pozo. Solo se desean graficar las 
% profundidades en las que se haya registrado.
% graficas_registro(PC,nombresPC,unidadesPC,tituloPC,tsupPC,tinfPC);

% El Pozo Control no necesariamente tiene el registro seleccionado para la
% prediccion.
% Matriz PCmed: contiene todos los registros del Pozo Control en aquellos 
%               puntos donde hay medicion.
PCmed=eliminar(PC);

% Matriz PC_AI: cada registro del Pozo Control en el area de Interes
PC_AI=PCmed((indice(PCmed(:,1),round(abs(tsupPC)))):(indice(PCmed(:,1),round(abs(tinfPC)))),:);


% ######################################### %
%% Entrenamiento del Sistema de Prediccion %%
% ######################################### %

% Normalizacion de los registros de pozo
% RN_PE: Registros Normalizados del Pozo de Entrenamiento
RN_PE=normalizacion(PEmed,PE_AE);

% RN_PC: Registros Normalizados del Pozo Control
RN_PC=normalizacion(PCmed,PC_AI);

% Registros normalizados en el area de entrenamiento y area de interes
% respectivamente.
PE_AEN=RN_PE(prof1:prof2,:);
PC_AIN=RN_PC((indice(PCmed(:,1),round(abs(tsupPC)))):(indice(PCmed(:,1),round(abs(tinfPC)))),:);

    % defaultStream = RandStream.getDefaultStream;
    % savedState = defaultStream.State;
    % u1= rand(1,5)
    % defaultStream.State = savedState;
    % u2 = rand(1,5) % contains exactly the same values as u1

% Para el entrenamiento solo ha de seleccionarse aleatoriamente el
% 50% del total de los datos. El termino 0.4 asegura que la seleccion 
% sea dentro de ese rango.

seleccion=find((rand(1,size(PE_AE,1)))>0.4,round(size(PE_AE,1)*0.5));

% Opciones de los algoritmos geneticos
opciones=gaoptimset('PopulationSize',10,'EliteCount',1,...
                    'CrossoverFcn',@crossoverscattered,...
                    'SelectionFcn',@selectionstochunif,...
                    'Mutation',@mutationgaussian,...
                    'Generations',60,...
                    'Display','off');
    
if PREDICCION==1
    % Ajuste de los coeficientes utilizando una ecuacion lineal
    coef=ag_lineal(PE_AEN,seleccion,opciones);

elseif PREDICCION==2
    % Ajuste de los coeficientes utilizando una ecuacion polinomial
    coef=ag_polinomial(PE_AEN,seleccion,opciones);
    
else
    % Se utilizara la Logica Difusa como metodo de prediccion
    [FIS,ENT]=log_dif(PE_AEN,seleccion);
end

% ################################# %
%% Prediccion del Registro de Pozo %%
% ################################# %

% Calculo del Registro final. Dependera del metodo seleccionado.
global pred_control

% Seleccion de los Registros del Pozo Control para la prediccion. Deben
% ser los mismos que se utilizaron para el entrenamiento
pred_control=zeros(1,size(pred,2));
for i=1:size(pred,2)
    for j=1:size(nombresPC,2)
        if isequal(nombresPE{pred(i)},nombresPC{j})
            pred_control(i)=j;
            break
         end
     end
 end

if PREDICCION==1
    % Calculo del(los) coeficiente(s)
    coeficientes=mean(coef);

    %-----------------------%
    % Pozo de Entrenamiento %
    %-----------------------%
    P=1;
    RF_PE=eval_ag_lineal(RN_PE,coeficientes,P);
    
    %--------------%
    % Pozo Control %
    %--------------%
    P=2;
    RF_PC=eval_ag_lineal(RN_PC,coeficientes,P);

elseif PREDICCION==2
    % Calculo de los coeficientes
    coeficientes=mean(coef);
    
    P=1;
    %-----------------------%
    % Pozo de Entrenamiento %
    %-----------------------%
    RF_PE=eval_ag_polinomio(RN_PE,coeficientes,P);

    P=2;
    %--------------%
    % Pozo Control %
    %--------------%
    RF_PC=eval_ag_polinomio(RN_PC,coeficientes,P);

else
    %-----------------------%
    % Pozo de Entrenamiento %
    %-----------------------%
    RF_PE=evalfis(RN_PE(:,pred),FIS);
    
    %--------------%
    % Pozo Control %
    %--------------%
    RF_PC=evalfis(RN_PC(:,pred_control),FIS);
end

% ################## %
%% Graficas Finales %%
% ################## %
%-----------------------%
% Pozo de Entrenamiento %
%-----------------------%
R(1)=registro_final(RN_PE(:,obj),RF_PE,PEmed(:,1),tituloPE,nombresPE{obj});

%--------------%
% Pozo Control %
%--------------%
R(2)=registro_final(RN_PC(:,obj),RF_PC,PCmed(:,1),tituloPC,nombresPC{obj});

% ################### %
%% Calculo del Error %%
% ################### %

% En el Pozo de Entrenamiento
Error_PE=sqrt(sum((RF_PE-RN_PE(:,3)).^2)/size(RF_PE,1));

% En el Pozo Control
Error_PC=sqrt(sum((RF_PC-RN_PC(:,3)).^2)/size(RF_PC,1));

Error=[Error_PE Error_PC];


% ############### %
%% Hibridizacion %%
% ############### %

if PREDICCION==3
    clear RF_PE RF_PC

    % pdif: Parametros de las reglas difusas antes de ser optimizadas.
    % phib: Parametros de las reglas difusas optimizadas.
    
    [RF_PE,RF_PC,reglas,pdif,phib]=hibrido(FIS,ENT,RN_PE(:,pred),...
        RN_PC(:,pred_control),opciones);

    % ################# %
    %% Nuevas Graficas %%
    % ################# %

    %-----------------------%
    % Pozo de Entrenamiento %
    %-----------------------%
    H_R(1)=registro_final(RN_PE(:,obj),RF_PE,PEmed(:,1),tituloPE,...
        nombresPE{obj});

    %--------------%
    % Pozo Control %
    %--------------%
    H_R(2)=registro_final(RN_PC(:,obj),RF_PC,PCmed(:,1),tituloPC,...
        nombresPC{obj});

    % ################### %
    %% Calculo del Error %%
    % ################### %

    % En el Pozo de Entrenamiento
    H_Error_PE=sqrt(sum((RF_PE-RN_PE(:,3)).^2)/size(RF_PE,1));
    
    % En el Pozo Control
    H_Error_PC=sqrt(sum((RF_PC-RN_PC(:,3)).^2)/size(RF_PC,1));

    H_Error=[H_Error_PE H_Error_PC];
end
