# Read Libraries
library(dplyr)
library(readr)
library(stringr)
library(data.table)
## Word cloud things
library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(tm)
library(webshot)
webshot::install_phantomjs()
library(htmlwidgets)

# Imported tables are generated via DiscordChatExporter v2.20.0

##
## Wordplot for each text channel
##
filename = c("general-discussion", "eye-tracking-plus-other-data-fmri-eeg-and-such", "keynote-raymond-bertram", "proof-readers-error",
             "novice-programmers-gaze-patterns", "e-z-reader-model-prediction", "eye-movement-features", "teachers-didactic-guidance",
             "code-reviews-in-cplusplus")

EMIP_discord = NULL

for (file in filename) {
  fileData <- read_csv(paste("final/", file, ".csv", sep=""))
  
  # Remove pinned message announcements
  fileData <- fileData[!grepl("Pinned a message.", fileData$Content),]
  # Remove URLs
  fileData$Content <- gsub("(s?)(f|ht)tp(s?)://\\S+\\b", "", fileData$Content)
  
  # Create a vector containing only the text
  text <- fileData$Content

  # Create a corpus  
  docs <- Corpus(VectorSource(text))
  tm_map(docs, function(x) iconv(enc2utf8(x), sub = "byte"))
  
  # Clean the text data
  docs <- docs %>%
    tm_map(removeNumbers) %>%
    tm_map(removePunctuation) %>%
    tm_map(stripWhitespace)
  docs <- tm_map(docs, content_transformer(tolower))
  docs <- tm_map(docs, removeWords, stopwords("english"))
  
  # Create a document-term-matrix
  dtm <- TermDocumentMatrix(docs) 
  matrix <- as.matrix(dtm) 
  words <- sort(rowSums(matrix),decreasing=TRUE) 
  df <- data.frame(word = names(words),freq=words)
  
  # Generate the word cloud
  set.seed(789) # for reproducibility 
  wc <- wordcloud2(data = df, size = 0.7, shape = 'diamond')
  
  htmldir <- paste(file, ".html", sep="")
  pngdir <- paste(file, ".png", sep="")
  saveWidget(wc, htmldir, selfcontained = F)
  webshot::webshot(htmldir,pngdir,vwidth = 640, vheight = 640, delay = 10)
  
  EMIP_discord <- rbind(EMIP_discord, fileData)
  
}


# Create a vector containing only the text
text <- EMIP_discord$Content

# Create a corpus
docs <- Corpus(VectorSource(text))

tm_map(docs, function(x) iconv(enc2utf8(x), sub = "byte"))


# Clean the text data
docs <- docs %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(stripWhitespace)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))

# Create a document-term-matrix
dtm <- TermDocumentMatrix(docs) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)

# Generate and save word cloud
set.seed(789) # for reproducibility 
wc_server <- wordcloud2(data = df, size = 1.0, shape = 'diamond')
htmldir <- paste("EMIP.html", sep="")
pngdir <- paste("EMIP.png", sep="")
saveWidget(wc, htmldir, selfcontained = F)
webshot::webshot(htmldir,pngdir,vwidth = 640, vheight = 640, delay = 10)

