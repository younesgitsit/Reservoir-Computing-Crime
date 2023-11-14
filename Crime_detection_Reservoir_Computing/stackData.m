% Younes Slaoui DHS - Last step in data processing: 
% - Turns each data image (matrix) into a single row vector by setting the 
% rows next to eachother. 
% - Stacks each of the 366 image row vectors to create one matrix where 
% each row represents one days worth of crime data for a given crime 
% - Result = array of 25 crimes, each crime represented by a matrix with
% 366 rows for each day.

load('allCrimeGridsSmoothed.mat')

allStackedCrimes = cell(1,25);

for crime = 1:25

    stackedCrime = zeros(366, 399);
    
    for day = 1:366
    
        image = allCrimeGridsSmoothed{1,crime}{1,day};
        
        imageRow = [];
        
        for row = 1:19
        
            imageRow = [imageRow, image(row, :)];
        
        end
    
        stackedCrime(day, :) = imageRow;
    
    end

allStackedCrimes{1,crime} = stackedCrime;

end
save('allStackedCrimes.mat');

