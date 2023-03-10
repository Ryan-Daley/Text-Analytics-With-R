# Text-Analytics-With-R

#### This Project analyzes the word frequencies and sentiment analyses of TED Talks given by Brian Cox and Terry Moore. 
[Click here for full project](https://raw.githubusercontent.com/Ryan-Daley/Text-Analytics-With-R/main/MA331%20-%20Midterm%20Project.pdf) 
![MA331 - SA](https://user-images.githubusercontent.com/113039811/224321604-fcc4cbfc-9364-4cd2-b731-4c8f6db7260a.jpg)

The project is divided into four sections. The first section provides an introduction and a brief summary of the two speakers and their TED Talks. The second section describes the methods used in the analysis, including statistical summary measures and visualizations. The third section presents the results of the analysis, including word frequency analyses and sentiment analyses. The final section concludes the report with a brief discussion of the findings, limitations, and considerations of the analysis.

The word frequency analysis is performed using the tidyverse and tidytext packages. The ted_talks dataset is tidied and tokenized using the unnest_tokens function. Stop words are then removed using the get_stopwords function. Data frames for each speaker are created using the filter and count functions. Histograms and bar charts are then created to visualize the top 25 most frequent words used by each speaker, as well as a comparison of the word frequencies between both speakers.

The sentiment analysis is performed using the nrc lexicon. Sentiments are assigned to each word in the TED Talks using the inner_join function. The count function is used to count the frequency of sentiments for each speaker. The odds ratio and log odds ratio are then calculated using the compute_OR function from the dsEssex package. A bar chart is then created to compare the sentiment counts for each speaker against the log odds ratio.

Overall, this code demonstrates how to perform a word frequency and sentiment analysis on a dataset using R and various packages. It also shows how to create visualizations to display the results of the analysis.
![MA331 - SA2](https://user-images.githubusercontent.com/113039811/224319295-36b50fa1-5d9d-46f7-8294-95e9cb641c47.png)
