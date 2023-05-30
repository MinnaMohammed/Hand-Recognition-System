function Labels = LabelingFeatures(users,featuresNum)
counter = 1;
arritera = 1;

    for i=1:users
        for j = 1:featuresNum
        Labels{arritera} = counter;
        arritera = arritera + 1;
        end
        counter = counter + 1;
    end
end