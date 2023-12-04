# Wather Prediction with ML in Python
### Skills used: Data Exploration, Data Cleaning, Time Series, Back testing, ML, Pandas and Sklearn
## Overview
Welcome to this project, where we will explore and analyse weather data from Global Historical Climatology Network, collected since 1970. We will also try to predict tomorrow's temperature with ML.
## Objectives
Our primary goal is to create a ML model to predict temperature.
## Key Features
### Data exploration and cleaning with Python
We explored the data types. We also looked for duplicated and missing data, and we worked on it in order to get our data ready for further analysis. For null values, we used ffill, which looks for NAN,, looks at the last nonNaN and uses it to fill. Logic behind this is that, if snow depth was 0 yesterday, it is more likely to be 0 aswell today.

We also changed the index to date type, in order to work with it as a time series data set. We also ensured that we didn't have any gaps in our time serie.

### ML model
Once our data was ready to be used, we created a Ridgre Regression Model, setting our alpha parameter to control collinearity and setting our predictor features.
After that, we used back testing (or Time Series Cross-validation) and started making predictions
We checked our model's accuracy with MAE, and saw that our prefictions were off by an average of 5 degrees, so tried to improve our model, this time using rolling computations, aiming to reduce the impact of those days that for some reason had odd temperature. We also added some more predictors to the model. We accomplished a light improvement on the model, but we also discovered that there were values hard to predict with the actual information that we have. We might need more detailed atmosferic data, such as wind conditions or parametric pressure, cloud cover, etc.

Also, in another project found in this portfolio, we will try to achieve a more accurate model using XGBOOST or random forest(diffrerent ML algorythms)

