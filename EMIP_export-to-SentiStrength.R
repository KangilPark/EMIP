# Read Libraries
library(dplyr)
library(readr)
library(stringr)
library(data.table)

# Imported tables are generated via DiscordChatExporter v2.20.0

filename = c("general-discussion", "eye-tracking-plus-other-data-fmri-eeg-and-such", "keynote-raymond-bertram", "proof-readers-error",
             "novice-programmers-gaze-patterns", "e-z-reader-model-prediction", "eye-movement-features", "teachers-didactic-guidance",
             "code-reviews-in-cplusplus")

# Import chat tables and export only the contents

for (file in filename) {
  fileData <- read.csv(paste("final/", file, ".csv", sep=""))
  
  # Remove pinned message announcements
  fileData <- fileData[!grepl("Pinned a message.", fileData$Content),]
  # Remove URLs
  fileData$Content <- gsub("(s?)(f|ht)tp(s?)://\\S+\\b", "", fileData$Content)
  
  write.csv(fileData$Content, file = paste("final/text/", file, "-text.txt", sep=""), row.names = FALSE)
}
