function main()
     prepknucklesfolder("YOUR INPUT FILE PATH", "YOUR OUTPUT FILE PATH");
     prepknucklesfolder("YOUR INPUT FILE PATH", "YOUR OUTPUT FILE PATH");

     labels = LabelingFeatures(33, 24);
     testlabels = LabelingFeatures(33, 12);

     TrainingFeatures = getFeatures("YOUR OUTPUT FILE PATH", 24);
     TestFeatures = getFeatures("YOUR OUTPUT FILE PATH", 12);
    
     labels = labels'; % Transpose to match the expected format
     testlabels = testlabels'; % Transpose to match the expected format

     TestFeatures = TestFeatures';
     TrainingFeatures = TrainingFeatures';

     tic;
     kNNmodel = TrainkNN(TrainingFeatures, labels);
     % Stop the timer
     elapsed_time = toc;

     tic;
     predictedlabelsS = predict(kNNmodel, TestFeatures);
     % Stop the timer
     elapsed_time = toc;

    cnt = 0;
    FA = 0;
    for i = 1:numel(predictedlabelsS)
        if isequal(predictedlabelsS(i), double(cell2mat(testlabels(i))))
            cnt = cnt + 1;
        else
            % False Acceptance
            FA = FA + 1;
        end
    end

    % Calculate the classification accuracy
    accuracyS = cnt / numel(testlabels);
    fprintf('Classification Accuracy: %.2f%%\n', accuracyS * 100);
    

    % Matching 
    prepknucklesfolder("YOUR INPUT FILE PATH TO MATCH", "YOUR OUTPUT FILE PATH TO MATCH");
    matchFea = getMFeatures("YOUR OUTPUT FILE PATH TO MATCH", 6);
    matchFea = matchFea';
    matchy = predict(kNNmodel, matchFea);

    % Find the most repeated integer
    mostRepeated = mode(matchy);
    fprintf("\nYou're user %d! :D", mostRepeated);
    
end