#load initial packages
install.packages("dsEssex")
library(dsEssex)
library(tidytext)
library(tidyverse)
library(dplyr)
library(ggrepel)

# load the data located in dsessex library
data("ted_talks") 

# tokenise and tidy the text from input column 'text' to output column 'word'
tidy_talks <- ted_talks %>%
  tidytext::unnest_tokens(word, text)

# remove stop words
ted_talks_nonstop <- tidy_talks %>%
  dplyr::anti_join(get_stopwords())

# create vector and keep only the words by Brian COx
Cox_words <- ted_talks_nonstop %>%
  dplyr::filter(speaker == "Brian Cox") %>%
  dplyr::count(speaker, word, sort = TRUE) # count with two arguments and sort in descending order

# doing the same but for Terry Moore
Moore_words <- ted_talks_nonstop %>%
  dplyr::filter(speaker == "Terry Moore") %>%
  dplyr::count(speaker, word, sort = TRUE)

sum(Cox_words$n)
sum(Moore_words$n)

Cox_words %>%
  dplyr::slice_max(n, n=25) %>% # select the 25 highest frequency words
  dplyr::mutate(word = reorder(word, n)) %>% # reorder variable
  ggplot2::ggplot(aes(n,word)) + ggplot2::geom_col() + # plot frequency on x axis and words on y axis
  labs(title = "Top 25 Most Frequent Words Within Brian Cox's Ted Talks") + #insert X and Y axis labels and adjust main title to centre
  xlab("Frequency") + ylab("Words") + 
  theme(plot.title = element_text(hjust = 0.5)theme_bw())

# doing the same for Terry Moore's words
Moore_words %>%
  dplyr::slice_max(n, n=25) %>%
  dplyr::mutate(word = reorder(word, n)) %>%
  ggplot2::ggplot(aes(n,word)) + ggplot2::geom_col() + 
  labs(title = "Top 25 Most Frequent Words Within Brian Moores' Ted Talks") +
  xlab("Frequency") + ylab("Words") +
  theme(plot.title = element_text(hjust = 0.5))

library(ggrepel)

dplyr::bind_rows(Cox_words, Moore_words) %>% # bind data frames
  group_by(word) %>% # group data by word
  filter(sum(n) > 5) %>% # filter by sum of the frequencies with each group (word)
  ungroup() %>% # ungroup
  pivot_wider(names_from = "speaker", values_from = "n", values_fill = 0) %>% # convert to wide format: get column names from the speaker variable
  ggplot(aes(`Brian Cox`, `Terry Moore`)) + # assign  x and y variables to aesthetics of geoms
  geom_abline(color = "red", size = 1.2, alpha = 0.75, lty = 3) + # add straight line, modify colour, size and opacity
  geom_text_repel(aes(label = word), size = 2, max.overlaps = 15) + # outlines texts and prevent overalpping amongst text
  coord_fixed() + # force specified ratio of data units on the axis
  labs(title = "Frequency comparison of speakers top words") + # insert main title
  theme(axis.title.x = element_text(size = 10)) + # next 3 lines are adjusting graphs axis and title sizes
  theme(axis.title.y = element_text(size = 10)) +
  theme(plot.title = element_text(hjust = 0.5))

BT_words <- bind_rows(Cox_words, Moore_words)

tidy_sentiment <- ted_talks_nonstop %>%
  dplyr::filter(speaker %in% c("Brian Cox", "Terry Moore"))

tidy_sentiment %>%
  inner_join(get_sentiments("nrc"), by = "word") %>% # match words with appropriate sentiments
  count(person, sentiment) %>% # count frequency of sentiments by speakers
  pivot_wider(names_from = person, values_from = n, values_fill = 0) %>% # widen data frame
  mutate(OR = dsEssex::compute_OR(`Brian Cox`, `Terry Moore`, correction = FALSE), # create new columns for odds ratio and log odds ratio
         log_OR = log(OR), sentiment = reorder(sentiment, log_OR)) %>%
  ggplot(aes(sentiment, log_OR, fill = log_OR < 0)) + # map graph aesthetics
  geom_col(show.legend = TRUE) + # plot bar chart
  ylab("Log odds ratio") + ggtitle("Association of sentiment between speakers") + # label y-axis and main title
  coord_flip() + # flip x and y axis 
  scale_fill_manual(name = "", values = c("darkgreen", "red")) +
  theme(plot.title = element_text(hjust = 0.5)) # centre main title

