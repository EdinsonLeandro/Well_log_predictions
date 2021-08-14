function X=dataNormalization(data, markers)
% Performs data normalization of well logs, according to the function proposed by Rafael Banchs, 2001.
% https://library.seg.org/doi/10.1190/1.1816689
%
% Input:
% data: 2D Array. Well log data.
% markers: 1D Array. Well markers of area of interest (top and bottom)
%
% Output Parameter:
% X: Array with normalized data

% Find indexes of depth interval. Asssumption: depth is the first column of  the array
indexTop = find( data(:, 1) == round(markers(1)) );
indexBottom = find( data(:, 1) == round(markers(2)) );

% Select well log data in area of interest and compute the mean
dataInterest = data(indexTop : indexBottom, :);
meanDataIntst = mean(dataInterest);

% Compute deviation of each well log. It is the difference between each data point and its average on interval of interest.
% Skip depth column
deviation= zeros(size(data));
for i= 2:size(data,2)
    deviation(:,i) = data(:,i) - meanDataIntst(i);
end

% Maximum deviation
maxDeviation = max(abs(deviation));

% Ouput array with normalized data
X= zeros(size(data));
for i=2:size(data,2)
    X(:,i) = ((data(:,i) - meanDataIntst(i))/maxDeviation(i))+1;
end

% Depth column of normalized data
X(:,1) = data(:,1);