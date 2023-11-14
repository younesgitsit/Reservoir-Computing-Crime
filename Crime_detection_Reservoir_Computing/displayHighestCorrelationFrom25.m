load('trainingErrorMatrix.mat')
load('testingErrorMatrix.mat')

zeroIndices = trainingErrorMatrix == 0;
trainingErrorMatrix(zeroIndices) = 9999;

zeroIndices = testingErrorMatrix == 0;
testingErrorMatrix(zeroIndices) = 9999;

% Assuming you have a 25x25 matrix named 'errorMatrixTraining'
% Reshape the matrix into a column vector and sort it in ascending order
[sorted_values, sorted_indices] = sort(testingErrorMatrix(:));

% Get the 10 smallest values and their corresponding row and column indices
smallest_values = sorted_values(1:20);
[row_indices, col_indices] = ind2sub(size(testingErrorMatrix), sorted_indices(1:20));

% Display the results
disp('10 Smallest Values:');
disp(smallest_values);
disp('Indices (Row, Column):');
disp([row_indices, col_indices]);
