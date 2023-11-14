% Younes Slaoui DHS
% Removes irrelevant data
load('concatincidents2.mat');

for i = 1:25

original_matrix = concatincidents2{1,i};

non_zero_rows = original_matrix(:, 10) ~= 0 & original_matrix(:, 11) ~= 0;

% Extract only the relevant rows from the original matrix
filtered_matrix = original_matrix(non_zero_rows, :);

maxLat = max(filtered_matrix(:, 10));
minLat = min(filtered_matrix(:,10));
maxLong = max(filtered_matrix(:,11));
minLong = min(filtered_matrix(:,11));

concatincidents2{1, i} = filtered_matrix;

end

save('concatincidents2.mat')