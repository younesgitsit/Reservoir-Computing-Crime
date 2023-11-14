% Younes Slaoui DHS
% Prepares temporal data alone

load('concatincidents2.mat');

data = zeros(366, 25);

for dataCol = 1:25

    crime = concatincidents2{1, dataCol};    
    numRows = size(crime, 1)
    
    for i = 1:numRows
    
        day = crime(i, 1);    
        data(day, dataCol) = data(day, dataCol) + 1;
    
    end

end

save('data.mat')