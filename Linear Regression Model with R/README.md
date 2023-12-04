# Bike Users Prediction with Weather Data in R
### Skills used: Data Exploration, Data Cleaning, Time Series, ML, Linear Regression, Backward Elimination, Theoretical Assumptions Check.
### Libraries used: "doBy", "ggplot2", "dplyr", "car", "MASS", "lmtest", "caret", "psych", "corrplot", "RcmdrMisc"
## Overview
Welcome to this project, where we will explore and analyse data from a public bike servive, which gathers active users and weather data. 
## Objectives
Our primary goal is to create a ML model to predict the number of users that will be using the service by using weather and date related features as predictors. We will asess our first ML model and try to improve it by addind new features as predictors and also interactions between variables.
## Key Features
### Data exploration and cleaning with Python
Firstly, we assessed with what kind of data we were working with. Then we proceeded to look for null and duplicated values. 

Then, we proceeded with data transformation, changing the format of our date column. We also dropped the first column, which was not necessary for this project. Finally, we worked on re-coding our qualitative features for a better interpretation.

### Descriptive analysis
We carried on a detailed descriptive analysis of all features, calculating mean, sd, median, min, max, etc of our numerical features and creating boxplots for each one.
We did the same with the qualitative features, creating a frecuency and relative frecuency table for each of them, aswell as barplots.
Then we assessed our first and last date of registered data, looked for duplicated records and if there were any gaps in the dates.

### Correlations and bivariant analysis
Then we carried out a heat map with the correlations of our numerical features.
We also worked on bivariant analysis between all our features and cnt feature(the count of active users), creating scatterplots for each pair. Then, using the summaryBy function, we created tables for bivariant analysis between the qualitative features with cnt. 

### ML model, Multiple Lineal Regression
Once our data was ready to be used, we created divided our data into a training sample(70%) and a test sample, and carried a first multiple regression model using only the numerical features to predict cnt on the training sample.

We assessed the model's quality and tried to improve it adding a qualitative feature as a predictor(weathersit, with different weather situations as factors). 

In a third attempt to improve our model, we added the interaction of 2 numerical features, windspeed and humidity.

Taking our best model, we also worked with backward elimination method to reduce the complexity of the model.

### Checking Theoretical Assumptions and Reporting Fit Indicator for the Test Sample
We checked for the assumptions of Linearity, Independence(no autocorrelation), Homoscedasticity, Normality and Multicolinearity.

Finally, we reported on a fit indicator for the test sample, using R2, RMSE and MAE, and the Prediction Error Rate of the model on the test and train sample, finding lower error rates in predictions for our trained model.
