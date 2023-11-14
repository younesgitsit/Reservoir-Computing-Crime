% Younes Slaoui DHS
% 

numTimestamps = 100000;
load('smoothincidents.mat')
data =[];
for i = 1:25

    incidents = smoothincidents{1, i};
    incidents(:,1) = [];
    incidents(:,365) = [];

    crime = [];
    
    for col = 1:364
    
        numCrimes = sum(incidents(:,col));
        crime = [crime, numCrimes];
    
    end

data(:, i) = crime';

end


figure;
plot(data(:,1))


% Create an array of original x-values (days 1 to 364)
x_original = 1:364;

% Create an array of x-values for the desired number of timestamps
x_interp = linspace(1, 100000, numTimestamps);

% Initialize a matrix to store the interpolated data
interpolatedMatrix = zeros(numTimestamps, 25);

% Perform interpolation for each column
for col = 1:25
    crimeData = data(:, col);
    interpolatedMatrix(:, col) = interp1(x_original, crimeData, x_interp, 'linear');
end

figure;
plot(interpolatedMatrix(:,1))

save('interpolatedMatrix');

