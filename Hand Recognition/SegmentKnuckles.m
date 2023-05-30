function arrofknuck = SegmentKnuckles(img)
I = imread(img);
% Increasing  the brightness
I = I + 5;
[h, w, c] = size(I);
s = zeros(h+10, w+10, c);

% Apply intensity slicing
for i = 1:h
    for j = 1:w
        if I(i,j,1) > 50 && I(i,j,1) > (I(i,j,2) + 20) 
            s(i,j,:) = I(i,j,:);
        end
    end
end
res = uint8(s);

% Apply morphological operations to extract only the fingers
x = rgb2gray(res);
x = imfill(x, "holes");
bw_hand = imbinarize(x);
se = strel('disk', 110);
se2 = strel('square',70);
bw_palm = imopen(bw_hand, se);
bw_palm2 = imdilate(bw_palm, se2);
bw_palm2 = ~bw_palm2;


% Apply Anding operation to get the fingers only
bw_finger = imbinarize(bw_hand .* bw_palm2);
% Cleaning the resultant image
minObjectArea = 650; % Adjust the threshold value as needed
bw_cleaned = bwareaopen(bw_finger, minObjectArea);
moreThan0 = bw_cleaned > 0; % Filter out noise
moreThan0 = bwmorph(moreThan0, 'majority'); 
% creating bounding boxes on the largest blobs
boundingBoxes = regionprops(moreThan0, 'BoundingBox', 'Orientation');
firstFingerIndex = 2;  % Exclude the first finger
lastFingerIndex = length(boundingBoxes) - 1;  % Exclude the last finger
flag = 0;
itera = 1;

for k = firstFingerIndex:lastFingerIndex
curr = boundingBoxes(k).BoundingBox;
orientation = boundingBoxes(k).Orientation;

% Crop the bounding box
        x1 = curr(1);
        y1 = curr(2);
        x2 = curr(1) + curr(3);
        y2 = curr(2) + curr(4);
        croppedImages{k} = res(round(y1:y2), round(x1:x2), :);
        cropp = bwareafilt(imbinarize(rgb2gray(croppedImages{k})), 1); % Extract largest blob only.
        
        % Excluding the unneeded objects
        [rows, cols] = size(cropp);
        min_rows = 90; % Minimum number of rows for a valid finger region
        min_cols = 50; % Minimum number of columns for a valid finger region
        if rows >= min_rows && cols >= min_cols
        fing = croppedImages{k} .* uint8(cropp);
        flag = flag + 1;

        % Rotate the image to straighten the finger
        if orientation < -45
        angleToRotate = -(90 + orientation);
        else
        angleToRotate = 90-orientation;
        end

        if (flag<=3)

        fixedFingerImg = imrotate(fing, angleToRotate, 'crop');
        
        [height, width, ~] = size(fixedFingerImg);
        % Estimated positions of knuckles based on proportions
         firstKnucklePosition = height * 0;
        secondKnucklePosition = height * 0.5;
        % Cropping regions for each knuckle
        firstKnuckleRegion = [1, firstKnucklePosition + 30, width, height - secondKnucklePosition];
        secondKnuckleRegion = [1, secondKnucklePosition, width, height - secondKnucklePosition - firstKnucklePosition - 20];
        % Crop each knuckle region from the image
        firstKnuckleImage = imcrop(fixedFingerImg, firstKnuckleRegion);
        secondKnuckleImage = imcrop(fixedFingerImg, secondKnuckleRegion);
        

         firstKnuckleRegion2 = regionprops(imbinarize(rgb2gray(firstKnuckleImage)), 'BoundingBox');
         firstKnuckleBoundingBox = firstKnuckleRegion2.BoundingBox;
         heightFactor = 0.81; % Adjust the factor as needed
         firstKnuckleBoundingBox(4) = firstKnuckleBoundingBox(4) * heightFactor;

         % Removing the black unneeded areas around the knuckle
         firknuckcropped = imcrop(firstKnuckleImage,firstKnuckleBoundingBox);
         firstKnuckleRegion3 = regionprops(imbinarize(rgb2gray(firknuckcropped)), 'BoundingBox');
         firstKnuckleBoundingBox2 = firstKnuckleRegion3.BoundingBox;
         firknuckcropped2 = imcrop(firknuckcropped,firstKnuckleBoundingBox2);

         deductWidth = 10;   % Replace with the desired deduction width
         deductedFir = firknuckcropped2(:, deductWidth+1:end-deductWidth,:);
         deductedFir = imresize(deductedFir, [100, 50]);

 
        secondKnuckleRegion2 = regionprops(imbinarize(rgb2gray(firstKnuckleImage)), 'BoundingBox');
        secondKnuckleBoundingBox = secondKnuckleRegion2.BoundingBox;
        secknuckcropped = imcrop(secondKnuckleImage,secondKnuckleBoundingBox);

        deductWidth2 = 10;   % Replace with the desired deduction width
        deductedSec = secknuckcropped(:, deductWidth2+1:end-deductWidth2,:);
        deductedSec = imresize(deductedSec, [100, 50]); 
        
        % Additional preprocessing on knuckle 1
        deductedFir = rgb2gray(deductedFir);

        normalizedImage2 = im2double(deductedFir);

       % Define the parameters for bilateral filtering
       sigmaRange = 0.1; % Adjust the range parameter as needed
       sigmaDomain = 1; % Adjust the domain parameter as needed

       % Apply bilateral filtering
       normalizedImage2 = imbilatfilt(normalizedImage2, sigmaRange, sigmaDomain);

       % Perform contrast stretching
       lowIn2 = min(normalizedImage2(:));
       highIn2 = max(normalizedImage2(:));
       lowOut2 = 0;  % Adjust the desired output range as needed
       highOut2 = 1;
       stretchedImage2 = imadjust(normalizedImage2, [lowIn2, highIn2], [lowOut2, highOut2]);
       stretchedImage2 = adapthisteq(stretchedImage2);
       stretchedImage2 = medfilt3(stretchedImage2);


        % Additional preprocessing on knuckle 2
        deductedSec = rgb2gray(deductedSec);
        normalizedImage = im2double(deductedSec);
        % Define the parameters for bilateral filtering
        sigmaRange = 0.1; % Adjust the range parameter as needed
        sigmaDomain = 1; % Adjust the domain parameter as needed

        % Apply bilateral filtering
        normalizedImage = imbilatfilt(normalizedImage, sigmaRange, sigmaDomain);

         % Perform contrast stretching
         lowIn = min(normalizedImage(:));
         highIn = max(normalizedImage(:));
         lowOut = 0;  % Adjust the desired output range as needed
         highOut = 1;
         stretchedImage = imadjust(normalizedImage, [lowIn, highIn], [lowOut, highOut]);
         stretchedImage = adapthisteq(stretchedImage);
         stretchedImage = medfilt3(stretchedImage);


         arrofknuck{itera} = stretchedImage2;
         itera = itera + 1;

         arrofknuck{itera} = stretchedImage;
         itera = itera + 1;
        end
        
        end
end


end