function kNNmodel = TrainkNN(TrainingFeatures, Labels)

    % Make sure the dimensions are compatible
    assert(size(TrainingFeatures, 1) == numel(Labels), 'Number of observations mismatch.');
    kNNmodel = fitcknn(TrainingFeatures, double(cell2mat(Labels)),"Distance","spearman");

end
