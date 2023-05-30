function prepknucklesfolder(inputpath, outpautpath)
inputFolder = inputpath;
outputFolder = outpautpath;

% Get a list of all image files in the input folder
fileList = dir(fullfile(inputFolder, '*.jpg'));  % Update the file extension if necessary

% Iterate through the images
for i = 1:numel(fileList)
    filename = fileList(i).name;
    imagePath = fullfile(inputFolder, filename);

    knuckles = SegmentKnuckles(imagePath);

    % Save each knuckle image in the output folder
    for j = 1:numel(knuckles)
        [~, name, ext] = fileparts(filename);
        knuckleFilename = sprintf('%s_knuckle%d%s', name, j, ext);  % Modify the filename as per your needs
        knucklePath = fullfile(outputFolder, knuckleFilename);
        imwrite(knuckles{j}, knucklePath);  % Save the knuckle image to the output folder
    end
end

end