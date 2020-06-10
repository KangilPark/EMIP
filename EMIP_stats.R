# Read Libraries
library(dplyr)
library(readr)
library(stringr)
library(data.table)

# Imported tables are generated via DiscordChatExporter v2.20.0

# Import chat tables
## General
general.discussion <- read.csv("general-discussion.csv")
eye.tracking.plus.other.data.fmri.eeg.and.such <- read.csv("eye-tracking-plus-other-data-fmri-eeg-and-such.csv")
## Paper presentation and discussions
proof.readers.error <- read.csv("proof-readers-error.csv")
novice.programmers.gaze.patterns <- read.csv("novice-programmers-gaze-patterns.csv")
e.z.reader.model.prediction <- read.csv("e-z-reader-model-prediction.csv")
eye.movement.features <- read.csv("eye-movement-features.csv")
teachers.didactic.guidance <- read.csv("teachers-didactic-guidance.csv")
code.reviews.in.cplusplus <- read.csv("code-reviews-in-cplusplus.csv")

# Add channel names as a separate column
general.discussion$channel <- "general-discussion"
eye.tracking.plus.other.data.fmri.eeg.and.such$channel <- "eye-tracking-plus-other-data-fmri-eeg-and-such"
proof.readers.error$channel <- "proof-readers-error"
novice.programmers.gaze.patterns$channel <- "novice-programmers-gaze-patterns"
e.z.reader.model.prediction$channel <- "e-z-reader-model-prediction"
eye.movement.features$channel <- "eye-movement-features"
teachers.didactic.guidance$channel <- "teachers-didactic-guidance"
code.reviews.in.cplusplus$channel <- "code-reviews-in-cplusplus"


# Merge data frames into one
EMIP_discord <- rbind(general.discussion, eye.tracking.plus.other.data.fmri.eeg.and.such, proof.readers.error,
                      novice.programmers.gaze.patterns, e.z.reader.model.prediction,
                      eye.movement.features, teachers.didactic.guidance, code.reviews.in.cplusplus)

# Remove pinned message announcements
EMIP_discord <- EMIP_discord[!grepl("Pinned a message.", EMIP_discord$Content),]
# Remove URLs
EMIP_discord$Content <- gsub("(s?)(f|ht)tp(s?)://\\S+\\b", "", EMIP_discord$Content)

# Get word count
EMIP_discord$wordcount <- lengths(strsplit(EMIP_discord$Content, "\\W+"))
# Generate Author frequency table of the EMIP 2020 server
EMIP_freq <- data.frame(table(EMIP_discord$Author))

# Average word count
EMIP_wordcount_average <- mean(EMIP_discord$wordcount)

# Export as CSV
write.csv(EMIP_discord, file = "EMIP_discord.csv")
write.csv(EMIP_freq, file = "EMIP_freq.csv")
