#---------------------------------------------------------------------#
#    Coursera Data science specialization Capstone                    #
#    predict next word                                                #
#    Author: Peter B.                                                 #
#    October 2018                                                     #
#---------------------------------------------------------------------#    
 
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.




# needed libraries
library(shiny)
library(quanteda)
library(data.table)
library(dplyr)


# Read in ngram models as base for prediction
UnigramProb  <- read.csv("UnigramProb.csv" , header = T, sep = ",")
BigramProb   <- read.csv("BigramProb.csv"  , header = T, sep = ",")
TrigramProb  <- read.csv("TrigramProb.csv" , header = T, sep = ",")
FourgramProb <- read.csv("FourgramProb.csv", header = T, sep = ",")




#Create function for predicting next words based on ngram model

predictNextWord <- function(sentence, choices=NULL) {
    
    # harmonize input sentence as it was done for the training set
    # Remove numbers, punctuation, symbols, hyphens, lower case only
    
    sentenceToken <- tokens(tolower(sentence), remove_numbers = TRUE,
                              remove_symbols = TRUE, remove_hyphens = TRUE, remove_url =TRUE,
                              remove_twitter = TRUE, remove_punct= TRUE, what="fasterword")
    sentenceToken <- unlist(sentenceToken)
    
    #Check if entered text is valid and display a message
    if (length(sentenceToken) == 0) {
        return("App is ready. Please enter a text using alphabet characters only in the textbox above.")
        
    } else {
        
        #Start Predicting Next Word
        
        #Initialize an empty data frame storing the next word predictions
        match <- data.frame(Next=character(), MLEProb=numeric())
        
        #Attempt to match to a 4-gram if sentence has 3 or more words using MLE 
        if (length(sentenceToken) >= 3) {
            lastTrigram <- paste0(sentenceToken[length(sentenceToken)-2], " ",
                                  sentenceToken[length(sentenceToken)-1], " ", 
                                  sentenceToken[length(sentenceToken)])
            match <- filter(FourgramProb, lastTrigram==Trigram) %>% 
                arrange(desc(MLEProb))  %>% 
                top_n(5, MLEProb) %>% select(Next, MLEProb)
        }
        
        #If sentence has only 2 words or if match has less than 5 results
        if (length(sentenceToken) >= 2 | nrow(match) < 5) {
            lastBigram <- paste0(sentenceToken[length(sentenceToken)-1], " ", sentenceToken[length(sentenceToken)])
            x <- filter(TrigramProb, lastBigram==Bigram) %>% top_n(5, MLEProb) %>% 
                select(Next, MLEProb) %>% mutate(MLEProb=MLEProb*0.4) 
            match <- filter(x, !(Next %in% match$Next)) %>% bind_rows(match)
        }
        
        #If sentence has only 1 word or if match has less than 5 results
        if (length(sentenceToken) == 1 | nrow(match) < 5){
            lastWord <- sentenceToken[length(sentenceToken)]
            x <- filter(BigramProb, lastWord==Prev) %>%  top_n(5, MLEProb) %>%
                select(Next, MLEProb) %>% mutate(MLEProb=MLEProb*0.4*0.4)
            match <- filter(x, !(Next %in% match$Next)) %>% bind_rows(match)
        } 
        
        #If Bigram match has failed, if match has less than 5 results
        if (nrow(match) < 5){
            x <- top_n(UnigramProb, 5, KNProb) %>% select(Next, KNProb) %>% 
                mutate(MLEProb=KNProb*0.4*0.4*0.4)
            match <- filter(x, !(Next %in% match$Next)) %>% bind_rows(match)
        } 
        
        #Sort matches by MLE
        match <- arrange(match, desc(MLEProb))
        
        return(paste0(sentence, " ", match$Next))
    }
}



#Update the UI with the output of the predicted next word(s)
shinyServer(function(input, output) {
    output$predictedsentence <- renderText({ 
        text <- predictNextWord(input$words) 
        paste(text, collapse = "\n")
    })
    
    output$wordcloud <- renderPlot({
        par(mfrow=c(1,3))
        wordcloud(top3$Trigram, top3$TrigramFreq, scale=c(3,.3), colors=(brewer.pal(8, 'Dark2')))
        wordcloud(top2$Bigram , top2$BigramFreq , scale=c(3,.3), colors=(brewer.pal(8, 'Dark2')))   
    })
})




