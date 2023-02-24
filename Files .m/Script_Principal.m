clc
clear all

% Constant to be used throughout the algorithm. It will be declared once.
global obj pred num

% Well log selection for predictions.
% obj: column number of well log (into the file), selected to predict.
obj=3;

% pred: column number of well logs (into the file), selected for train the 
% model and subsequent predictions.
pred=[6 7];

% num: Number of independent variables train the algorithm, i.e. number of
% input well logs for predictions.
num=size(pred,2);

% Selection of prediction technique.
% 1: Genetic Algorithms using linear equation.
% 2: Genetic Algorithms using polynomial equation.
% 3: Fuzzy Logic.
PREDICCION=3;

%% Input Data
%
%--------------------%
% Training Well Logs %
%--------------------%

% PE: Training Well Logs.
PE=carga_registro('valoresGF-87N');

% Definición de los topes de la arena de interés del pozo de entrenamiento
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

% ATENCIÓN-MEJORAR!!!: HACER UNA FUNCIÓN PARA TRANSFORMAR DE UNIDADES DE
% LENTITUD A UNIDADES DE VELOCIDAD, PARA NO HACER LA DETECCIÓN DE ESTA
% FORMA AUTOMÁTICA, YA QUE LOS NEMÓNICOS PUEDEN VARIAR: DT, DTP, DTC,
% DT COMPRERSIONAL, ETC. NO SON UNO SÓLO COMO PARA HACER LA DISCRIMINACIÓN.
% PARA ESTO PODRÍA UTILIZARSE LA VARIABLE "obj".

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

% Gráficas de los registros del pozo. Solo se desean graficar las
% profundidades en las que se haya registrado.
graficas_registro(PE,nombresPE,unidadesPE,tituloPE,tsupPE,tinfPE);

% En ocasiones, los registros estan incompletos. Por esta razon:
% PEmed: Matriz que contiene todos los registros del Pozo de Entrenamiento
% solo en las puntos donde hubo medicion
PEmed=eliminar(PE);

% Seleccion de los datos para el entrenamiento. Primero ha de seleccionar
% las lutitas que suprayacen la arena, luego la que le infrayace
g=ginput(2);
prof1=indice(PEmed(:,1),round(abs(g(1,2))));
prof2=indice(PEmed(:,1),round(abs(g(2,2))));

% Primero ha de seleccionarse el tope superior y luego el tope inferior y
% no al reves
if prof1 > prof2
    error('Se debe seleccionar primero el tope superior y luego el inferior')
end

% Matriz PE_AE: contiene cada registro del Pozo de Entrenamiento en el
% area de Entrenamiento
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


