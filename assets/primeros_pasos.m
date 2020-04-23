clc
clear all
% Pasos que buscan graficar de la manera que deseo los registros de pozo
obj=3;
PE=carga_registro('valoresGF-87N');
PEmed=eliminar(PE,obj); vs=PEmed(:,3); prof=PEmed(:,1); den=PEmed(:,2);


figure('NumberTitle','off','Position',[1 31 1024 664],...
        'Color','w','Visible','on');

co = get(gcf,'DefaultAxesColorOrder');

% Plot first plot

ax(1) = newplot;
set(gcf,'NextPlot','add')
h(1) = feval(@plot,vs,prof);
grid on
set(ax(1),'Box','on','XAxisLocation','top','YDir','reverse')
xlim1 = get(ax(1),'XLim');
ylim1 = get(ax(1),'YLim');


% Try to produce different colored lines on each plot by
% shifting the colororder by the number of different colors
% in the first plot.

% findobj(h1,'Type','line')= Find all line objects in the current axes

colors = get(findobj(h(1),'Type','line'),{'Color'});
if ~isempty(colors),
    colors = unique(cat(1,colors{:}),'rows');
    n = size(colors,1);
    % Set the axis color to match the single colored line
    if n==1
        set(ax(1),'XColor','k')
    end
    set(gcf,'DefaultAxesColorOrder',co([n+1:end 1:n],:))
end

% Plot second plot
ax(2) = axes('Position',get(ax(1),'Position'));
h(2) = feval(@plot,den,prof);
set(ax(2),'XAxisLocation','bottom','Color','none', ...
'XGrid','off','YGrid','off','Box','on', ...
'YDir','reverse','XTick',[],'YTick',[],'Box','off');
xlim2 = get(ax(2),'XLim');
ylim2 = get(ax(1),'YLim');



% Check to see if the second plot also has one colored line
colors = get(findobj(h(2),'Type','line'),{'Color'});
if ~isempty(colors),
    colors = unique(cat(1,colors{:}),'rows');
    n = size(colors,1);
    if n==1
        set(ax(2),'XColor','k')
    end
    set(gcf,'DefaultAxesColorOrder',co([n+2:end 2:n],:))
end

% set(ax(2),'XTick',[],'Box','off')
legend(findobj(h,'Type','line'),'1','2','Location','NorthOutside','Box','off')


set(ax(2),'Position',get(ax(1),'Position'))


% [legend_h,object_h] = legend(ax(1),'1');
% 
% set(legend_h,'Location','NorthOutside','Box','off')
% set(object_h(1),'String',{'DTs'},'HorizontalAlignment','center',...
%     'Color','k','Position',[0.5 1],'EdgeColor','k','Margin',10)
% get(gca,'OuterPosition')
% 
% 
% legend(ax(2),'2','Location','NorthOutside')


% fh=figure('MenuBar','figure','NumberTitle','off','Toolbar','auto','Visible','off');
% ed=get(fh);

% set(gca,'YGrid','on','Box','off','Color','none','XAxisLocation','top',...
%     'Title',text('String','New Title','Color','r'))
% set(gcf,'Color','w')
% 
% 
% legend(ax,{'Densidad' 'VS'},'Location','NorthOutside')
% set(get(gca,'Title'),'Color','r')



% error('dir:graficas_registro:numberOfInputs',[errmsg,' Se requiere al
% menos 3 argumentos']);


% % Arreglo del eje x, sus divisiones deben ser iguales a las del registro
% % medido
% xtick1=get(ax(1),'XTick');
% xlim2=get(ax(2),'XLim'); m2=min(xlim2); M2=max(xlim2); difx=M2-m2;
% 
% ejex=zeros(1,size(xtick1,2));
% ejex(1)=m2;
% for i=2:size(xtick1,2)
%     ejex(i)=ejex(i-1) + difx/(size(xtick1,2)-1);
% end
