function [PE,PC,n_r,p_dif,p_hb,zerror]=hibrido(FIS,ENT,pe,pc,op)
% [PE,PC,n_r,p_dif,p_hb,zerror]=hibrido(FIS,ENT,pe,pc,op) 
% Realiza una combinación entre Lógica Difusa y Algoritmos Genéticos para
% la predicción de Registros de Pozo.
% Donde:
%    FIS: Estructura generada en ANFIS que contiene todos los parámetros
%         asociados a él.
%    ENT: Contiene los datos para el entrenamiento. Su última columna debe 
%         corresponderse con los valores de salida.
%         (Registro que se desea predecir).
%     pe: Registros Normalizados de entrada del Pozo de Entrenamiento.
%     pc: Registros Normalizados de entrada del Pozo Control.
%     op: Opciones para la funcion "ga.m" de Algoritmos Geneticos
% 
%     PE: Registro de Salida. Pozo de Entrenamiento
%     PC: Registro de Salida. Pozo Control
%    n_r: Vector que indica con ceros las reglas difusas que no
% 	    fueron optimizadas.
%  p_dif: Parámetros del FIS creado por ANFIS.
%   p_hb: Parámetros Optimizados del FIS mediante Algoritmos Geneticos.
%         En las reglas difusas que no fueron optimizadas, tendrá sus
%	  correspondientes parametros de ANFIS.

global num

% mf_max= Número de funciones de membresía máximo que alcanza entrada 
%         alguna dentro del FIS creado
mf_max=zeros(1,num);
for i=1:num
    mf_max(i)=size(FIS.input(i).mf,2);
end
mf_max=max(mf_max);

% Ha de tomarse en cuenta que, en dicha combinación, no necesariamente el
% número de reglas difusas para la(s) variable(s) de entrada son iguales.

sigma=zeros(mf_max,num); c=zeros(mf_max,num);
rango_min=zeros(mf_max,num); rango_max=zeros(mf_max,num);
for i=1:num
    for j=1:mf_max
        try
            % Parámetros de todas las funciones de membresía. Denotadas con
            % "sigma" y "c".
            sigma(j,i)=FIS.input(i).mf(j).params(1);
            c(j,i)=FIS.input(i).mf(j).params(2);
    
            % Valores topes de entrada (a media altura), de cada función de 
            % membresía. Cada fila va a contener [mínimo y máximo]
            rango_min(j,i)=c(j,i)-sqrt(2*log(1/0.5)*sigma(j,i)^2);
            rango_max(j,i)=c(j,i)+sqrt(2*log(1/0.5)*sigma(j,i)^2);
        catch zerror
           continue 
        end
    end
end

% H_ENT: Matriz que contiene los registros seleccionados para la
%        entrenamiento de la "Hibridización". 
%        Su última columna se corresponde con el registro de salida

regla=zeros(size(FIS.output.mf,2),num);
n_r=zeros(1,size(FIS.output.mf,2));
p_dif=zeros(size(FIS.output.mf,2),num+1);
p_hb=zeros(size(FIS.output.mf,2),num+1);
for k=1:size(FIS.output.mf,2)
% Hibridización para cada Regla Difusa tipo Takagi - Sugeno - Khan
% k=1 Regla Difusa Número 1
% k=2 Regla Difusa Número 2
% k=3 Regla Difusa Número 3 ...

    % Selección, desde la matriz de Entrenamiento del SID "ENT", sólo los
    % datos que se encuentren dentro de cada rango calculado, siguiendo las
    % correspondientes reglas difusas.
    % El prefijo "H_" antes de cada nombre indica que se ha obtenido
    % en el proceso de Hibridización
       
    % Obtención de la regla difusa.
    regla(k,:)=FIS.rule(k).antecedent;
    
    % Bloque de sentencias. Devuelve un vector de unos sólo en el caso en
    % que los elementos en una profundidad determinada pertenezcan al rango
    % correspondiente de su función de membresía.
    
    H_ENT=zeros(size(ENT)); sentencia=zeros(1,num);    
    for i=1:size(ENT,1)
        for h=1:num
            % Comparación de cada elemento con el rango calculado.
            % sentencia(1)= Verifica la entrada 1 (input 1)
            % sentencia(2)= Verifica la entrada 2 (input 2) ...
            sentencia(h)=ENT(i,h) > rango_min(regla(k,h),h) ...
		&& ENT(i,h) < rango_max(regla(k,h),h);
        end
        
        if sentencia
            H_ENT(i,:)=ENT(i,:);
        else
            continue
        end
    end
     
    puntos=find(H_ENT(:,1));
    H_ENT=H_ENT(puntos,:);

    % Verificación. Si no se encuentran puntos para una regla difusa
    % determinada, no se podrá realizar la optimización de esta regla. Esto
    % constituye una limitante de este método de Hibridización. En caso que
    % eso ocurra, habrá que continuar hacia la siguiente regla.
    
    % parametro: Vector que contiene los Parámetros de la k-ésima ecuación 
    %            lineal obtenido a partir del FIS creado por ANFIS
    parametro=FIS.output.mf(1,k).params;
            
    % p_dif: Matriz cuyas filas contienen los parámetros de
    %                la k-ésima regla difusa
    p_dif(k,:)=parametro;
    
    if ~isempty(H_ENT)
        % Cálculo del Registro Teórico utilizando los parámetros obtenidos
        % mediante las reglas difusas.
            
        REGTEO=zeros(size(H_ENT,1),size(parametro,2)-1);
        for i=1:size(parametro,2)-1
            REGTEO(:,i) = parametro(i)*H_ENT(:,i);
        end
        REGTEO=REGTEO + parametro(end);

        % Ajuste, mediante algortimos genéticos, del registro calculado.
        % Se utilizará la función "fun_lineal_fis"
        
        % H_coefs: nuevos coeficientes que brindarán un nuevo ajuste 
        %          entre los datos de entrenamiento
        H_coefs=zeros(size(H_ENT));

        % Ciclo. Se calcula el coeficiente (minim) para cada elemento
        h=waitbar(0,'Ajustando Reglas Difusas mediante Algoritmos Genéticos...');
        for i=1:(size(H_ENT,1))
            minim=ga(@(x) fun_lineal_fis(x,i,REGTEO,H_ENT(:,end)),num+1,...
                [],[],[],[],[],[],[],op);
            H_coefs(i,:)=minim;
            waitbar(i/(size(H_ENT,1)),h)
        end
        close(h)

        H_coefs=mean(H_coefs);

        % Sustitución de los coeficientes obtenidos en la primera regla difusa.
        FIS.output.mf(1,k).params=H_coefs;
            
        % Matriz que guardará todos los coeficientes optimizados para
        % cada regla difusa
        p_hb(k,:)=H_coefs;
            
        clear sentencia H_ENT REGTEO
        
    else
        p_hb(k,:)=p_dif(k,:);
        
        % n_r: Vector que indicará la regla difusa que no ha sido
        %            optimizada (dicha regla será el número de fila
        %            marcado con el número 1) al no encontrarse datos que
        %            cumplieran con las condiciones
        n_r(k)=1;
    end
end

% Finalmente, se reevalúa el FIS ahora modificado:

%--------------------%
% Pozo Entrenamiento %
%--------------------%
PE=evalfis(pe,FIS);

%--------------%
% Pozo Control %
%--------------%
PC=evalfis(pc,FIS);


function Z=fun_lineal_fis(x,i,y,w)
% Función de Entrenamiento (a optimizar) de la forma:
% f=[(x(1)*y(:,1) + x(2)*y(:,2) + x(n)*y(:,n) + x(n+1))-w]^2
% 
% Esta función es utilizada dentro del proceso de Hibridización
% 
% Parámetros de entrada:
% i: Corresponde al número de elemento dentro del ciclo
% y: Matriz en donde cada columna contiene los datos seleccionados para la
%    predicción.
% w: Corresponde al registro medido cuya predicción se desea realizar
%    mediante algortimos genéticos

% x: Coeficientes a optimizar
z=zeros(size(y,2),1);
for j=1:(size(y,2))
    z(j)=x(j).*y(i,j);
end
zz=sum(z);

% Ecuación final a ajustar.
Z=(zz+x(j+1)-w(i)).^2;
