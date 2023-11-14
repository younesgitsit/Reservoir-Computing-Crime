% Younes Slaoui DHS
% - Circular smoothing algorithm

load('allCrimeGrids.mat')

a = allCrimeGrids{1,1}{1,1};

matrix = a;

radius = 6; 

[rows, cols] = size(matrix);

smoothedMatrix = zeros(rows, cols);

% Iterate through each cell in the matrix
for row = 1:rows
    for col = 1:cols
        % Calculate the weighted sum of values in the circular region
        totalWeight = 0;
        weightedSum = 0;
        for i = -radius:radius
            for j = -radius:radius
                % Calculate the distance from the center (row, col) of the circular region
                distance = sqrt(i^2 + j^2);
                
                % Check if the distance is within the specified radius
                if distance <= radius
                    % Calculate the weight (decreasing with distance from the center)
                    weight = (radius - distance) / radius;
                    totalWeight = totalWeight + weight;
                    
                    % Calculate the weighted sum
                    weightedSum = weightedSum + weight * getValue(matrix, row + i, col + j, rows, cols);
                end
            end
        end
        
        % Calculate the smoothed value for the current cell
        smoothedMatrix(row, col) = weightedSum / totalWeight;
    end
end

% Display the original and smoothed matrices side by side
figure;
subplot(1, 2, 1);
imagesc(matrix);
axis image;
colormap('jet');
title('Original Image');

subplot(1, 2, 2);
imagesc(smoothedMatrix);
axis image;
colormap('jet');
title('Smoothed Image');

% Function to handle boundary conditions (zero padding)
function value = getValue(matrix, row, col, rows, cols)
    if row < 1 || row > rows || col < 1 || col > cols
        value = 0;
    else
        value = matrix(row, col);
    end
end

