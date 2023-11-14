% Younes Slaoui DHS
% Finds dimensions of images to create using the Latitudes and Longitudes
% of the incidents

load('concatincidents2.mat');

%% Finding Max and Min Lats and Longs

% Finding max min long and lat for first crime, to use in loop
% extracting relevant data
r = concatincidents2{1, 1};
relevantData = r(:, [1,2,10,11]);

maximumLat = max(relevantData(:, 3));
minimumLat = min(relevantData(:,3));
maximumLong = max(relevantData(:,4));
minimumLong = min(relevantData(:,4));


for cell = 2:1:25
    
    r = concatincidents2{1, cell};
    
    relevantData = r(:, [1,2,10,11]);
    
    maxLat = max(relevantData(:, 3));
    minLat = min(relevantData(:,3));
    maxLong = max(relevantData(:,4));
    minLong = min(relevantData(:,4));
    
    if maxLat > maximumLat
        maximumLat = maxLat;
    end
    if minLat < minimumLat
        minimumLat = minLat;
    end
    if maxLong > maximumLong
        maximumLong = maxLong;
    end
    if minLong < minimumLong
        minimumLong = minLong;
    end

end

%% Find grid dimensions
numGridRows = round(100*(maximumLat - minimumLat))+1;
numGridColumns = round(100*(maximumLong - minimumLong))+1;
%%
save('numGridRows');
save('numGridColumns');
save('maximumLat');
save('maximumLong');
save('minimumLat');
save('minimumLong');
