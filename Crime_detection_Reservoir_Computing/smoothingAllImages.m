% Younes Slaoui DHS
% - Uses circular smoothing algorithm to smooth all images for all the
% crimes

load('allCrimeGrids.mat')
allCrimeGridsSmoothed = allCrimeGrids;

for crime = 1:25

    for day = 1:366


        matrix = allCrimeGrids{1,crime}{1,day};   
        
        % Define the radius of the circular kernel
        radius = 10; % Adjust the radius as needed
        
        % Get the size of the matrix
        [rows, cols] = size(matrix);
        
        % Initialize the smoothed matrix with zeros
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

        allCrimeGridsSmoothed{1,crime}{1,day} = smoothedMatrix;
    end
end

save('allCrimeGridsSmoothed.mat')

% Function to handle boundary conditions (zero padding)
function value = getValue(matrix, row, col, rows, cols)
    if row < 1 || row > rows || col < 1 || col > cols
        value = 0;
    else
        value = matrix(row, col);
    end
end
