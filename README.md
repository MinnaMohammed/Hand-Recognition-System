                                            Hand Recognition System 
This is a hand recognition system that uses knuckles as its main feature to see if a person - when providing their hand to the system- is registered in the database or not.

We segment the hand from the background using the intensity slicing technique. Then, We extract the fingers only by excluding the palm and applying some morphological operations.

We decided to use only 3 fingers(ring, middle, and index fingers) to do the preprocessing steps to get their knuckles and make them more enhanced for the feature-extracting step.

After extracting the knuckles, We then prepare the folders by putting the training dataset knuckles in one folder and the testing dataset knuckles in another folder.

Then we extract the features using the local binary pattern (LBP) method of the training set and testing set and prepare their labels to give to the KNN classifier to train it.

After training the classifier we give it the test dataset to get the accuracy.

In the matching step, We will provide the classifier with a new image of a person registered in the database and another that is not registered and the most repeated number in the matching labels that comes out of the classifier will be the person matched in the database.

                               ---------------------------------------------------------------
Functions Descriptions:
-----------------------
->SegmentKnuckles.m: This function is responsible for segmenting the knuckles and has all the preprocessing steps used for extracting the knuckles.

->prepknucklesfolder.m: This function is responsible for putting the knuckles extracted in the folders specified.

->getFeatures.m and getMFeatures.m: This function is responsible for extracting the features of the knuckles using the LBP method.

->TrainKNN.m: This function is responsible for training the knn classifier.

->main.m: The matching process happens here and all the functions call.

                                           -------------------------------

DB Description:
---------------
we got images from 33 subjects.from each subject we gathered 6 images, 4 of them are used for training and 2 for testing. those are real images taken from people around us from different ages and genders with their phones doing different poses to have a diverse DB to work with.
