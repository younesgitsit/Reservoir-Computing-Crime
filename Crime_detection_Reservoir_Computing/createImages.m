load('concatincidents2.mat');
load('numGridColumns.mat');
load('numGridRows.mat');
load('robberyImages.mat');
load('maximumLat');
load('maximumLong');
load('minimumLat');
load('minimumLong');

clear cell

%% Creating the empty 366 grids for each of the 25 crimes and storing in allCrimeGrids 
emptyGrid = zeros(numGridRows, numGridColumns);
emptyCrime = cell(1, 366);

for day = 1:366
    emptyCrime{1,day} = emptyGrid;
end

allCrimeGrids = cell(1, 25);

for crime = 1:25
    allCrimeGrids{1,crime} = emptyCrime;
end
%%
%%
for crime = 1:25
    %extracting relevant data: days, latitude, and longitude (robberies)
    crimeData = concatincidents2{1,crime};
    crimeData = crimeData(:,[1, 10, 11]);
    
    for row = 1:size(crimeData, 1)
        
        day = crimeData(row,1);
        
        latitude = 100*(crimeData(row,2) - minimumLat)+1;
        longitude = 100*(crimeData(row,3) - minimumLong)+1;
        
        insertRow = round(latitude);
        insertColumn = round(longitude);
        
        allCrimeGrids{1,crime}{1,day}(insertRow, insertColumn) = allCrimeGrids{1,crime}{1,day}(insertRow, insertColumn)+1;
        %robberyImages{1,day}(insertRow, insertColumn) = robberyImages{1,day}(insertRow, insertColumn)+1;
    end

end
save('allCrimeGrids.mat');