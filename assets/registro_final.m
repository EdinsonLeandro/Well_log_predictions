function RR=registro_final(RegMed,RegPre,Prof,T,nombrePre)
% Función que realiza las siguientes graficas de comparación entre el 
% registro medido (real) y el predicho.
%    RegMed: Registro Medido (Real)
%    RegPre: Registro Predicho
%      Prof: Profundidades en las que se desea graficar
%         T: Título que identifica al pozo
% nombrePre: Nombre del Registro que se ha predicho
%
%         R: coeficiente de determinación de la gráfica

% ------------------- %
%% Registros de Pozo %%
% ------------------- %

figure('Name',T,'NumberTitle','off','Position',[1 31 1024 669],...
        'Color','w','Visible','off','Toolbar','none');

% Para una mejor visualización e interpretación, el mismo registro se ha 
% separado en dos. De manera que, de izquierda a derecha, aparecerá así:
% El Registro Completo - La Mitad Superior - La Mitad Inferior.

% Registro Completo
pos=1;
registros_aux(RegMed,RegPre,Prof,nombrePre,pos)

% Mitad Superior
pos=2; filas=round(size(RegPre,1)/2);
registros_aux(RegMed(1:filas,:),RegPre(1:filas,:),Prof(1:filas,:),...
    nombrePre,pos)

% Mitad Inferior
pos=3;
registros_aux(RegMed(filas:end,:),RegPre(filas:end,:),Prof(filas:end,:),...
    nombrePre,pos)

% La Figura es ahora visible
set(gcf,'Visible','on')

% ---------------------------------------- %
%% Gráfica Comparativa: Predicho vs. Real %%
% ---------------------------------------- %
% Puntos que ayudan a mostrar el grado de certidumbre con el que se ha 
% realizado la predicción.
% Se mostrará el valor de R^2 que indica el grado de relación entre ambos.

% Calculo de R^2
r=corrcoef(RegMed,RegPre);
RR=r(1,2)^2;
R=num2str(RR);

figure('Name','Resultados: Pozo Entrenamiento','NumberTitle','off',...
    'Color','w','Toolbar','none')
plot(RegMed,RegPre,'*','MarkerEdgeColor',[0.5 0.1 0.1])

% Longitud de los ejes
% axis([fix(min(RegMed)) ceil(max(RegMed)) fix(min(RegPre)) ceil(max(RegPre))])

% Modificación de los ejes. Sólo aparecerán 5 líneas en el grid.
% xlim=get(gca,'XLim'); mx=xlim(1); MX=xlim(2); difx=MX-mx;
% ejex=[mx , mx+difx/4 , mx+difx/2 , MX-difx/4 , MX];
% 
% ylim=get(gca,'YLim'); my=ylim(1); MY=ylim(2); dify=MY-my;
% ejey=[my , my+dify/4 , my+dify/2 , MY-dify/4 , MY];

% Propiedades de los ejes
set(gca,'FontWeight','bold',...
    'Box','on','GridLineStyle',':','Color',get(gcf,'Color'),'FontSize',12)

% Cálculo de la línea de tendencia
[m,b]=min_cuad(RegMed,RegPre);
X=[min(RegMed) max(RegMed)]; Y=zeros(1,2);
for i=1:2
    Y(i)=m*X(i)+b;
end

% Dibujo de la línea en el gráfico
LL=line(X,Y);
set(LL,'LineWidth',2.5,'Color','k')

% Valor de R^2 en el gráfico
x=get(gca,'XTick');
y=get(gca,'YTick');
TT=text(x(end-1),(y(2)+y(1))/2,['{R}^{2}{= }' R]);
set(TT,'BackgroundColor',[0.5 0.1 0.1],'FontSize',12,'FontWeight','bold',...
    'HorizontalAlignment','center','Margin',8,'Color','w','FontName','Times')
xlabel([nombrePre ': Real'],'FontSize',13)
ylabel([nombrePre ': Predicho'],'FontSize',13)
grid('on')

end

function [m,b]=min_cuad(x,y)
% Función que calcula, mediante mínimos cuadrados, los parámetros "pendiente
% e interseccion" ("m" y "b") de la ecuacion lineal y = mx + b.
% Tanto "x" como "y" deben ser introducidos como columnas
m=((size(x,1)*sum(x.*y))-(sum(x)*sum(y)))/(size(x,1)*sum(x.^2)-(sum(x))^2);
b=(1/size(x,1))*(sum(y)-m*sum(x));
end

function registros_aux(RegMed,RegPre,Prof,nombrePre,pos)
% pos: Posición, dentro de la ventana, en que se encontrarán los registros
%      a graficar.

% Se han de graficar dos registros en un mismo eje.

%------------- 1er Registro: Real-------------%
ax = subplot(1,3,pos);
h=plot(RegMed,Prof,RegPre,Prof); grid on

% Modificación del eje y. Sólo aparecerán puntos específicos.

% if pos==1
%     ylim=get(gca,'YLim'); m=min(ylim); M=max(ylim); dify=M-m;
%     ejey=[m , m+dify/4 , m+dify/2 , M-dify/4 , M];
% elseif pos==2
%     ylim=get(gca,'YLim'); m=min(ylim); M=max(ylim); dify=M-m;
%     ejey=[m , m+dify/4 , m+dify/2 , M-dify/4 , M];
% else  % pos==3
%     ylim=get(gca,'YLim'); m=min(ylim); M=max(ylim); dify=M-m;
%     ejey=[m , m+dify/4 , m+dify/2 , M-dify/4 , M];
% end

% Opciones de los ejes
set(gca,'FontWeight','bold','GridLineStyle',':','Box','on',...
    'XAxisLocation','top','YDir','reverse','FontSize',12);
% xlabel({' '});

% Legenda
[legend_h] = legend(findobj(h,'Type','line'),...
    [nombrePre ': Real'],[nombrePre ': Predicho']);
set(legend_h,'Location','NorthOutside','Box','off')

end
