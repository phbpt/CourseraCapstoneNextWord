## Word Prediction Application

This application was developed for the final Capstone Project in the Data Science Specialization course from Coursera by Johns Hopkins University.

### How the word prediction works:

In former stpes N-gram models were created and resulting computations were saved into CSV files.
After the start of the application these text files are initialized. 

The prediction is done by using a so-called stupid backoff algorithm on Trigram, Bigram and Unigram probability models. 
When a word is typed in the text field, the application algortihm attempts to find matches from the Trigram Model using the computed Maximum Likelihood Extimates (MLE) for each Trigram. If no matching trigram is available, the algorithm "backs off"" to find a match in the next lower model (= Bigram Model).
If neither a  Trigram or Bigram model predicted match is found, Unigrams are taken in consideration and a prediction based on the smootehd Kneser-Ney probability for the unigram will be used.

The output and prediction results will be shown by using a wordcloud.


### Used files and libraries in the applications repository:
0. Following R libraries are used: shiny, quanteda, data.table and dplyr
1. ui.R - user-interface for next word prediction application
2. server.R - server logic for the next word prediction application, including the `predictNextWord` function that 
   generates the actual next word predictions.
3. UnigramProb.csv  - file containing the Unigram MLE and Kneser-Ney probabilities received from the training corpus
4. BigramProb.csv   - file containing the Bigram MLE probabilities obtained from the training corpus
4. TrigramProb.csv  - file containing the Trigram MLE probabilities computed from the sample. 
5. FourgramProb.csv - file containing the Trigram MLE probabilities computed from the training corpus
6. additional markdown files having application details

