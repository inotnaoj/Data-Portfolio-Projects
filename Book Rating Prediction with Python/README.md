# Book Rating Prediction with Python
### Skills used: pandas, numpy, seaborn, matplotlib, sklearn.
## Overview
Welcome to this project, where we will explore and analyse data from a book dataset, in a further attempt to carry out some predictions.
## Objective
Our primary goal is to explore, clean and analyse the data to provide a comprehensive understanding of our features, in order to work in a ML model to predict book ratings.

## Workflow
### 1.Data Exploration and Vizualization
We had 11 features, numerical and qualitative and non null values nor duplicated records.
### 2.Data Cleaning
Fixed some feature names that had random blank spaces.
### 3.Data Visualization
Checked our target variable (Rating) distribuction, finding the most frecuent ratings arround 4.
We also looked for language frequencies, the number of books each rating has, and which books had more ratings. Also checked which books had more reviews, the top rated books under 200 pages for book lovers who have little time.
Then we looked for the longest 10 books in our data, aswell as the books and authors with more publications.
We also had interest on seeing which 10 authors had the most(not best) rated books, in order to know which books created more discussions among the readers.
Then we worked on some bivariant distributions: ratings and number of pages and ratings and number of reviews.
### 4.Data Preprocessing
Treated extreme ouliers that could affect the accuracy of the model. Worked on outliers from: number of pages, ratings count, number of reviews
Feature engineering: selected and transformed variables, encoding title, author and language in order to be usable for our ML model.
### 5.Machine Learning Model
Used linear regression, a basic method. Defined our predictor and target variables and divided our data into a training and test samples (80/20).
Evaluated the model precision by comparing the predicted ratings on the train set with the actual ratings and evaluated the performance with different statistics: MAE, RMSE, MAE, R2. This first model achieved pretty close predictions, but it can't explain much of the variability of the data.
In an attempt to improve our model, we encoded publisher to be added to the predictor variables, and also added month and year from the publication_date feature as predictors.
The outcome was not a significant improvement of the model. We concluded that with more information, such as genre of the books, awards, or separating authors for those books that have more than 1 writer, could help us have even more accurate predictions, while explaining higher amount of data variation.
