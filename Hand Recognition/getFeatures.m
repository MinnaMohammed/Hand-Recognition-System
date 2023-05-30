function lbp_values = getFeatures(inputFolder,num)
% Get all Knuckles (knucklelist)
fileknuckles = dir(fullfile(inputFolder, '*.jpg'));
column = 1;
lbp_values = [];
knuckleiter = 1;

% Iterate over the users
for user = 1:33
    % Iterate over the knuckle images for each user
    for knuckle = 1:num

        % Read the knuckle image
        filename = fileknuckles(knuckleiter).name;
        imagePath = fullfile(inputFolder, filename);
        knuckleimg = imread(imagePath);

        % Define the parameters for LBP feature extraction
        radius = 5;
        numPoints = 20;
        cellSize = [12 12];

        % Extract LBP features (58 uniform and 59 non-uniform)
        lbp_img = extractLBPFeatures(knuckleimg, 'Radius', radius, 'NumNeighbors', numPoints, 'CellSize', cellSize);

        % Reshape the LBP values to be a column vector of size 59x1
        lbp_img = reshape(lbp_img, [], 1);
        
        % Append the LBP values to the column vector
        lbp_values(:, column) = lbp_img;
        
        knuckleiter = knuckleiter + 1;
        column = column + 1;
    end
end


end