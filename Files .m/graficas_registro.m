function graficas_registro(X,N,UD,T,tsup,tinf)
% graficas_registro(X,N,obj) Realiza graficas de registros de pozo. Muestra
% tres gráficos por ventana hasta la totalidad de los registros que
% contenga el pozo. Donde:
% X: Matriz que contiene los registros de pozo a graficar
% N: Vector de celdas que contiene los nombres de los registros.
%
% graficas_registro(X,N,obj,UD,T,tsup,tinf) Adicionalmente, agrega la
% siguiente información a los registros:
% UD: Unidades en que fueron medidos los registros.
% T: Título del registro que se esta graficando.
% tsup: Tope superior de la arena de interés
% tinf: Tope inferior de la arena de interés

%% Condiciones
errmsg = nargchk(4,6,nargin);
    if ~isempty(errmsg)
        error('No hay argumentos suficientes para ejecutar la función');
    end
    
% col: Número de columnas presentes en la matriz X
col=size(X,2);

if ~iscell(N)
    error('Los nombres deben ser introducidos como un vector de celdas')
end

if ~ischar(T)
error('El título debe ser un caracter')
end

if size(N,2) ~= col
    error('El número de nombres y de registros deben ser iguales')
end

if nargin > 4 && nargin > 5
    if ~isnumeric(tsup) || ~isnumeric(tinf)
      error('Los topes deben ser números')
    end
    
    if tsup ~= 0
        if ~indice(X(:,1),round(tsup)) || ~indice(X(:,1),round(tinf));
            msg='El(los) Tope(s) especificados(s) no se encuentra(n) en este pozo';
            error(msg)
        end
    end
    
    % topes: matriz que contiene los topes de la arena de interes
    topes=[round(tsup) round(tinf);round(tsup) round(tinf)];
end

%% Gráfica de los registros.
%Cada ventana generada tendra un máximo de tres registros del pozo.
i=2;
while i <= col
    % La posición de la ventana dependerá del monitor en que se trabaje.
    % Para este caso, el vector [1 27 1024 639] se corresponde con una
    % ventana maximizada.
    figure('Name',T,'NumberTitle','off','Position',[1 27 1024 669],...
    'Color','w','Visible','off','Toolbar','none');

    for j=1:3
        try
        subplot(1,3,j), plot(X(X(:,i)>=0,i),X(X(:,i)>=0,1))

        % Propiedades de los ejes
        
        % ATENCIÓN MEJORAR!!!:
        % 1. LAS PROFUNDIDADES ES MEJOR QUE NO SE MUESTREN EN NOTACIÓN
        % CIENTÍFICA.
        % 2. HAY REGISTROS A GRAFICAR QUE TIENEN VALORES NEGATIVOS. HAY QUE
        % CONSIDERARLO DENTRO DE LA FUNCIÓN PARA QUE GRAFIQUE BIEN.
        % 3. ESTUDIAR EL FUNCIONAMIENTO DE TODA ESTA FUNCIÓN.
        % 4. SI EL .LAS TIENE 30 REGISTROS, ¿SE VAN A GRAFICAR TODOS? EN EL
        % PROGRAMA PRINCIPAL SE PUDIERA HACER UNA SELECCIÓN DE DICHOS
        % REGISTROS ANTES DE PASAR A ESTA FUNCIÓN.
        
        ylim=get(gca,'YLim'); M=ylim(2); m=ylim(1); r=M-m;
        ejey=[m , m+r/4 , m+r/2 , M-r/4, M];
        set(gca,'FontWeight','bold','XGrid','on','YGrid','on',...
        'GridLineStyle',':','YTick',ejey,'YDir','reverse',...
        'XAxisLocation','top','FontSize',13)
        
        if nargin > 4 && nargin > 5

            % linea: Fila 1 corresponde con el punto mínimo del registro a
            % graficar. Fila 2 el punto máximo. En conjunto con la
            % matriz "topes", permitirá graficar una línea
            % indicando el(los) tope(s) de la arena de interés.
            linea(1,[1 2])=min(get(gca,'XLim'));
            linea(2,[1 2])=max(get(gca,'XLim'));

            % Línea que representa los topes de la arena de interés.
            line(linea([1 2],:),topes,'color','g','LineWidth',2.5)
        end
        
        %Título del Registro
        [legend_h] = legend(N(i));
        set(legend_h,'Location','NorthOutside','Box','off')
        xlabel(UD(i))
        
        catch zerror
            disp(zerror)
            break
        end
        i=i+1;
    end
    set(gcf,'Visible','on')
end


