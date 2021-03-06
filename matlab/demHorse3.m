% DEMHORSE3 Model the horse data with a 2-D MLP GPLVM.

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'horse';
experimentNo = 3;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set IVM active set size.
numActive = 100;

% Set default options.
options = gplvmOptions;

% because of small data-set, jointly optimise active points with kern params.
options.gplvmKern = 1;
options.kernIters = 100;

% Because of ordered noise models, optimise noise too.
options.noiseIters = 100;

orderedIndex = [1, 2, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 20];
gaussianIndex = [3, 4, 5, 15, 18, 19, 21];
for i = orderedIndex;
  noiseType{i} = 'ordered';
end
for i = gaussianIndex
  noiseType{i} = 'mgaussian';
end

options.initX = 'sppca';
kernelType = {'mlp', 'bias', 'white'};
selectionCriterion = 'entropy';
model = gplvmFit(Y, 2, options, kernelType, noiseType, selectionCriterion, numActive, lbls);


% Save the results.
[X, kern, noise, ivmInfo] = gplvmDeconstruct(model);
capName = dataSetName;
capName(1) = upper(capName(1));
save(['dem' capName num2str(experimentNo) '.mat'], 'X', 'kern', 'noise', 'ivmInfo');

% Load the results and display dynamically.
gplvmResultsDynamic(dataSetName, experimentNo, 'vector')

% Load the results and display statically.
% gplvmResultsStatic(dataSetName, experimentNo, 'vector')

% Load the results and display as scatter plot
% gplvmResultsStatic(dataSetName, experimentNo, 'none')
