library(jsonlite)
library(tidyr)
library(tidytext)
library(dplyr)
library(wordcloud)
library(ggplot2)
library(knitr)
library(kableExtra)

### Set up
## Adzuna
# 50 results, jobs in us, full time, data science
Adzuna_file <- jsonlite::fromJSON("https://api.adzuna.com/v1/api/jobs/us/search/1?app_id=018d3e05&app_key=c61bad16e0597343a3b672a6984062a8&results_per_page=100&what_phrase=data%20science&full_time=1", flatten=TRUE)
adzuna <- Adzuna_file$results
tidy_adzuna <- adzuna %>% unnest_tokens(word, description) %>% anti_join(stop_words)

## Github jobs
# 8 results, jobs in us, full time, data science
Github_Jobs_file <- jsonlite::fromJSON("https://jobs.github.com/positions.json?utf8=%E2%9C%93&description=data+science&location=usa&full_time=on", flatten=TRUE)
github <- Github_Jobs_file
tidy_github <- github %>% unnest_tokens(word, description) %>% anti_join(stop_words) %>%
  filter(word != "li" & word != "ul")

## The muse
# jobs in us, full time, data science
Muse_file <- jsonlite::fromJSON("https://www.themuse.com/api/public/jobs?category=Data%20Science&page=1", flatten=TRUE)
muse <- Muse_file$results
tidy_muse <- muse %>% unnest_tokens(word, contents) %>% anti_join(stop_words) %>% filter(word != "li" & word != "br" & word != "de" & word != "ul" & word != "ml")


### Word frequencies
# adzuna
tidy_adzuna %>% count(word, sort = TRUE)
# github
tidy_github %>% count(word, sort = TRUE)
# muse
tidy_muse %>% count(word, sort = TRUE)


### Wordclouds
# adzuna
tidy_adzuna %>% count(word) %>% with(wordcloud(word, n, max.words = 50))
# github
tidy_github %>% count(word) %>% with(wordcloud(word, n, max.words = 50))
# muse
tidy_muse %>% count(word) %>% with(wordcloud(word, n, max.words = 50))


### Histograms
# adzuna
adzuna_count <- tidy_adzuna %>% count(word, sort = TRUE)
adzuna_count <- adzuna_count[1:20,]
ggplot(data = adzuna_count, aes(x = word, y = n)) + geom_col() + ylab("Frequency") + 
  ggtitle("Most Common Job Description Words on Adzuna") + 
  theme(axis.text.x = element_text(angle = 45))

# github
github_count <- tidy_github %>% count(word, sort = TRUE)
github_count <- github_count[1:20,]
ggplot(data = github_count, aes(x = word, y = n)) + geom_col() + ylab("Frequency") + 
  ggtitle("Most Common Job Description Words on Github Jobs") + 
  theme(axis.text.x = element_text(angle = 45))

# muse
muse_count <- tidy_muse %>% count(word, sort = TRUE)
muse_count <- muse_count[1:20,]
ggplot(data = muse_count, aes(x = word, y = n)) + geom_col() + ylab("Frequency") + 
  ggtitle("Most Common Job Description Words on The Muse") + 
  theme(axis.text.x = element_text(angle = 45))


### comparing counts of common words
# data, strong, science, experience, team, learning
muse_count$site <- rep("muse", 20)
github_count$site <- rep("github", 20)
adzuna_count$site <- rep("adzuna", 20)
all_count <- rbind(adzuna_count, github_count, muse_count)
common_words <- filter(all_count, word == "data" | word == "strong" | word == "science" | word == "experience" | word == "team" | word == "learning")

ggplot(data = common_words, aes(x = word, y = n)) + geom_col(aes(fill = site)) + 
  ylab("Frequency") + ggtitle("Frequencies of Words Common Across all Job Sites")


