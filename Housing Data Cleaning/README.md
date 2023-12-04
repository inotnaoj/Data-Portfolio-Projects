# Housing Data Cleaning with SQL
## Overview
Welcome to this project, where we will explore and clean data from a the housing industry. 
## Objectives
Our primary goal is to explore and clean our dataset, focusing on transforming our data so it becomes more usable for further analysis to gain valuable insights from it.
## Key Features
### Data exploration with SQL
Once we extracted the data, it was uploaded to PostgreSQL with a simple Python script(see files). Then we selected the data we needed for our dashboard. 
### Data cleaning
-Standarized our date feature format and added it as a new column to our data set. (**Skills used:** CAST, ALTER TABLE, UPDATE)

-We treated and filled missing values from PropertyAddress feature, doing estimations based on another features, such as UniqueID and ParcelID. (**Skills used:** COALESCE(similar to a self join), JOIN, UPDATE)

-Broke out PropertyAddress and OwnerAddress features into individual features (Address, City, State) in order to make it more usable. (**Skills used**: SUBSTRING, LENGHT, POSITION, SPLIT_PART ALTER TABLE, UPDATE)

-Transformed Sold as Vacant feature: Yes and No values as "Y" and "N". (**Skills used:** REPLACE, ALTER TABLE, UPDATE)

-Removed duplicate data. (**Skills used:** CTE, DELETE)

-Removed unnecessary columns. (**Skills used:** ALTER TABLE, DROP COLUMN)


