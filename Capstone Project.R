---
title: Capstone Project
author: Johannes Le Blanc
output: html_document
---

```{r setup, include=FALSE}
library(dslabs)
library(tidyverse)
library(tibble)
library(dplyr)
library(tidyr)
library(devtools)
library(ggplot2)
library(statsr)
library(ggrepel)
library(SLICER)
library(stringr)
library(htmlwidgets)
library(purrr)
library(lubridate)
library(ggthemes)
library(bindrcpp)
library(gridExtra)
library(MASS)
library(caret)
library(purrr)
library(randomForest)
library(e1071)
library(rpart)
knitr::opts_chunk$set(echo = TRUE)
```

## Loading the data and creating the train and test set.

```{r, message=FALSE}
#############################################################
# Create edx set, validation set, and submission file
#############################################################

# Note: this process could take a couple of minutes

if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(caret)) install.packages("caret", repos = "http://cran.us.r-project.org")

# MovieLens 10M dataset:
# https://grouplens.org/datasets/movielens/10m/
# http://files.grouplens.org/datasets/movielens/ml-10m.zip

dl <- tempfile()
download.file("http://files.grouplens.org/datasets/movielens/ml-10m.zip", dl)

ratings <- read.table(text = gsub("::", "\t", readLines(unzip(dl, "ml-10M100K/ratings.dat"))),
                      col.names = c("userId", "movieId", "rating", "timestamp"))

movies <- str_split_fixed(readLines(unzip(dl, "ml-10M100K/movies.dat")), "\\::", 3)
colnames(movies) <- c("movieId", "title", "genres")
movies <- as.data.frame(movies) %>% mutate(movieId = as.numeric(levels(movieId))[movieId],
                                           title = as.character(title),
                                           genres = as.character(genres))

movielens <- left_join(ratings, movies, by = "movieId")

# Validation set will be 10% of MovieLens data

set.seed(1)
test_index <- createDataPartition(y = movielens$rating, times = 1, p = 0.1, list = FALSE)
edx <- movielens[-test_index,]
temp <- movielens[test_index,]

# Make sure userId and movieId in validation set are also in edx set

validation <- temp %>% 
  semi_join(edx, by = "movieId") %>%
  semi_join(edx, by = "userId")

# Add rows removed from validation set back into edx set

removed <- anti_join(temp, validation)
edx <- rbind(edx, removed)

rm(dl, ratings, movies, test_index, temp, movielens, removed)
```

## Part1 -  Quiz: MovieLens Dataset

1. How many rows and columns are there in the edx dataset?
  
  ```{r pressure, echo=FALSE}
dim(edx)
```


2.a How many zeros were given as ratings in the edx dataset?
  
  ```{r}
edx %>% filter(rating == 0) %>% tally()
```

2.b How many threes were given as ratings in the edx dataset?
  
  ```{r}
edx %>% filter(rating == 3) %>% tally()
```


3. How many different movies are in the edx dataset?
  
  ```{r}
n_distinct(edx$movieId)
```

4. How many different users are in the edx dataset?
  
  ```{r}
n_distinct(edx$userId)
```

5. How many movie ratings are in each of the following genres in the edx dataset?
  
  ```{r}
edx %>% separate_rows(genres, sep = "\\|") %>%
  group_by(genres) %>%
  summarize(count = n()) %>%
  arrange(desc(count))
```


6. Which movie has the greatest number of ratings?
  
  ```{r}
edx %>% group_by(movieId, title) %>%
  summarize(count = n()) %>%
  arrange(desc(count))
```

7. What are the five most given ratings in order from most to least?
  
  ```{r}
edx %>% group_by(rating) %>% summarize(count = n()) %>% top_n(5) %>%
  arrange(desc(count)) 
```

8. True or False: In general, half star ratings are less common than whole star ratings (e.g., there are fewer ratings of 3.5 than there are ratings of 3 or 4, etc.).

TRUE

## Part 2 - Predicted movie ratings and RMSE

### The first naive model

```{r}
mu_hat <- mean(edx$rating)
mu_hat
```

# Naive RMSE

```{r}
naive_rmse <- RMSE(validation$rating, mu_hat)
naive_rmse
```

# results table for the naive approach

```{r}
rmse_results <- data_frame(method = "Just the average", RMSE = naive_rmse)
```















