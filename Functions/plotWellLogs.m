function plotWellLogs(data, wellNames, units, wellTops)
% This function perform well logs plots. Show 3 wells by row.
% data:      Matrix with well log data.
% wellNames: Cell array. Well logs names.
% units:     Cell array. Measurement units of well log data.
% wellTops:  Vector. Upper and Lower marker of the stratigraphic unit.
    
% nCols: Number of columns in matrix "data".
nCols=size(data,2);

%% Check input data.
narginchk(4, 4);

if ~iscell(wellNames) || ~iscell(units)
    error('Well names and Units must be cell arrays.')
end

if size(wellNames, 1) ~= nCols
    error('The size of "wellNames" array must be equal to number of columns of "data".')
end

if nargin > 3
    if wellTops(1) ~= 0
        if ~find(data(:,1) == round(wellTops(1))) || ~find(data(:,1) == round(wellTops(2)))
            msg= 'Well tops are not in depth range of data';
            error(msg)
        end
    end
    
    % WELL_TOPS. Matrix with markers of the stratigraphic unit of interest.
    WELL_TOPS=[round(wellTops(1)) round(wellTops(2)) ; round(wellTops(1)) round(wellTops(2))];
end

%% Plot Well Logs.

item= 2;

while item <= nCols
    axisArray = cell(3,1);
    for jColum= 1:3
        try
        ax = subplot(1,3,jColum);
        axisArray{jColum} = ax;
        
        % Filter NaN values
        plot(data(~isnan(data(:,item)),item), data(~isnan(data(:,item)),1));

        % Axis properties
        set(gca,'XGrid', 'on',  'YGrid', 'on', 'GridLineStyle', ':', ...
                'YDir', 'reverse', 'XAxisLocation', 'top')
        
        if nargin > 3

            % XLIM_MATRIX: Get minimum and maximum values of the current
            % axis in order to plot the line of the well tops.
            XLIM_MATRIX(1,[1 2])= min(get(gca,'XLim'));
            XLIM_MATRIX(2,[1 2])= max(get(gca,'XLim'));
        
            % Plot line
            line(XLIM_MATRIX([1 2],:), WELL_TOPS, 'color', 'g', 'LineWidth', 2.5)
        end
        
        % Set titles to plot.
        xlabel(units(item))
        title(upper(wellNames(item)))
        
        catch zerror
            disp(zerror)
            break
        end
        item=item+1;
        
    end
    
    % Erase Y-axis from the other logs
    for jColum= 2:3
        yticklabels(axisArray{jColum},{});
    end
    
    % Synchronize the y-axis limits of each plot. This is need because
    % sometimes the well logs does not have the same measurement interval.
    linkaxes([axisArray{1} axisArray{2} axisArray{3}], 'y')
    
    clear axisArray;
end
