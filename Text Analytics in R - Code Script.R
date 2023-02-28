library(dsEssex)
data("ted_talks")

library(tidytext)
library(tidyverse)

tidy_talks <- ted_talks %>%
  tidytext::unnest_tokens(word, text)

ted_talks_nonstop <- tidy_talks %>%
  dplyr::anti_join(get_stopwords())

Cox_words <- ted_talks_nonstop %>%
  dplyr::filter(speaker == "Brian Cox") %>%
  dplyr::count(speaker, word, sort = TRUE)

sum(Cox_words$n)
sum(Moore_words$n)

1543/447
  

Moore_words <- ted_talks_nonstop %>%
  dplyr::filter(speaker == "Terry Moore") %>%
  dplyr::count(speaker, word, sort = TRUE)

Cox_words %>%
  dplyr::slice_max(n, n=25) %>%
  dplyr::mutate(word = reorder(word, n)) %>%
  ggplot2::ggplot(aes(n,word)) + ggplot2::geom_col() + 
  labs(title = "Top 25 Most Frequent Words Within Brian Cox's Ted Talks") +
  xlab("Frequency") + ylab("Words") +
  theme(plot.title = element_text(hjust = 0.5)0theme_bw()

Moore_words %>%
  dplyr::slice_max(n, n=25) %>%
  dplyr::mutate(word = reorder(word, n)) %>%
  ggplot2::ggplot(aes(n,word)) + ggplot2::geom_col() + 
  labs(title = "Top 25 Most Frequent Words Within Brian Moores' Ted Talks") +
  xlab("Frequency") + ylab("Words") +
  theme(plot.title = element_text(hjust = 0.5))

library(ggrepel)

dplyr::bind_rows(Cox_words, Moore_words) %>%
  group_by(word) %>%
  filter(sum(n) > 5) %>%
  ungroup() %>%
  pivot_wider(names_from = "speaker", values_from = "n", values_fill = 0) %>%
  ggplot(aes(`Brian Cox`, `Terry Moore`)) +
  geom_abline(color = "red", size = 1.2, alpha = 0.75, lty = 3) +
  geom_text_repel(aes(label = word), size = 2, max.overlaps = 15) +
  coord_fixed() + 
  labs(title = "Frequency comparison of speakers top words") +
  theme(axis.title.x = element_text(size = 10)) +
  theme(axis.title.y = element_text(size = 10)) +
  theme(plot.title = element_text(hjust = 0.5))

BT_words <- bind_rows(Cox_words, Moore_words)

sentiment_counts <- BT_words %>%
  inner_join(get_sentiments("nrc"), by = "word") %>%
  count(person, sentiment) 

BT_words %>%
  inner_join(get_sentiments("nrc"), by = "word") %>%
  count(person, sentiment) %>% 
  pivot_wider(names_from = person, values_from = n, values_fill = 0) %>%
  mutate(OR = dsEssex::compute_OR(Brian, Terry, correction = FALSE), 
         log_OR = log(OR), sentiment = reorder(sentiment, log_OR)) %>%
  ggplot(aes(sentiment, log_OR, fill = log_OR < 0)) +
  geom_col(show.legend = TRUE) +
  ylab("Log odds ratio") + ggtitle("Association of sentiment between speakers") +
  coord_flip() + 
  scale_fill_manual(name = "", values = c("darkgreen", "red"))

tidy_sentiment <- ted_talks_nonstop %>%
  dplyr::filter(speaker %in% c("Brian Cox", "Terry Moore"))
