# Read Libraries
library(dplyr)
library(readr)
library(stringr)
library(data.table)

# Imported tables are generated via DiscordChatExporter v2.20.0

filename = c("general-discussion", "eye-tracking-plus-other-data-fmri-eeg-and-such", "keynote-raymond-bertram", "proof-readers-error",
             "novice-programmers-gaze-patterns", "e-z-reader-model-prediction", "eye-movement-features", "teachers-didactic-guidance",
             "code-reviews-in-cplusplus")

for (file in filename) {
  fileData <- read_delim(paste("final/text/", file, "-text+results.txt", sep=""), "\t",
                         escape_double = FALSE, trim_ws = TRUE, quote = "\\\"")
  fileData <- na.omit(fileData)
  colnames(fileData) = c("Text", "Positive", "Negative") # Rename column
  fileData$Overall <- "Neutral"
  fileData$Overall[fileData$Positive+fileData$Negative > 0] <- "Positive"
  fileData$Overall[fileData$Positive+fileData$Negative < 0] <- "Negative"
  
  write.csv(fileData, file = paste("final/sentiment/", file, "-Sentiment.csv", sep=""), row.names = FALSE)
}

#code_reviews_in_cplusplus_text_results <- read_delim("final/text/code-reviews-in-cplusplus-text+results.txt", 
#                                                     "\t", escape_double = FALSE, trim_ws = TRUE)

