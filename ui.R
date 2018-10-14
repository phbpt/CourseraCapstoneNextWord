#---------------------------------------------------------------------#
#    Coursera Data science specialization Capstone                    #
#    predict next word                                                #
#    Author: Peter B.                                                 #
#    October 2018                                                     #
#---------------------------------------------------------------------# 


# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.

library(shiny)
library(markdown)

shinyUI(fluidPage(theme="bootstrap.css",
                  
                  titlePanel("Next Word Prediction Application"),
                  
                  #Side bar with instructions for using the app
                  sidebarLayout(
                      sidebarPanel(
                          h4("Purpose:"),
                          p("Prediction of the next word for character input words/ phrases"),
                          h4("Instruction:"),
                          p("When starting on the ''Next Word Prediction'' tab, you have to wait until the App is initialized and 
                            the ''App is ready'' message appears. This might take initially 1-2 minutes.
                            After this step the user can begin to type the text for which you want to have 
                            the next word predicted."),
                          p("The input text along with suggested next words will be shown below the textbox as soon as 
                            you start typing."),
                          p("More inforamtion about the application can be received from the ''Application information'' tab.")
                          ),
                      
                      #Main panel with tabs containing the text prediction app and a separate tab for app details
                      mainPanel(
                          tabsetPanel(type = "tabs", 
                                      tabPanel("Next Word Prediction",
                                               br(),
                                               textInput('words', label="Input text", width = "100%"),
                                               verbatimTextOutput('predictedsentence')
                                      ),
                                      tabPanel("Application information",
                                               br(),
                                               includeMarkdown("README.md")
                                      )
                          )
                      )
                          )
                  ))
