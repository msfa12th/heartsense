# LUB DUB : A Machine Learning Based App for Non-invasive Diagnosis of Heart Disease.

# Summary:
According to the WHO, cardiovascular diseases (CVDs) are the number one cause of death globally, taking an estimated 17.9 million lives each year. Extensive research has identified factors that increase a person’s risk for coronary heart disease in general and heart attack in particular.The American Heart Association recommends focusing on heart disease prevention early in life. To start, assess your risk factors and work to keep them low. The sooner you identify and manage your risk factors, the better your chances of leading a heart-healthy life. This project is aimed at understanding some of the risk factors associated with heart disease and build a predictive model thereof citing the potential risk of occurrence in individuals. 

The app is deployed at (Heroku link)

# Data (ETL and App Integration) (Mary)
Original Source Data (extraction, transformation and load):

Pulled source data in CSV format from two websites 
1. Cleveland - https://archive.ics.uci.edu/ml/datasets/Heart+Disease
  Heart Disease Data Set originally from the University of California, Irvine Machine Learning Repository
  Many versions of the data are provided on this website.
  We chose to use the data set that was processed/cleansed by a Cleveland ML team
  The dataset contains approximately 14 medical attributes for approximately 300 patients.
  Numerical data stored in a semicolon delimited file

2. Cardio Risk - https://www.kaggle.com/sulianova/cardiovascular-disease-dataset
  Cardiovascular Disease dataset from Kaggle
  The dataset consists of 70,000 records of patient data, 11 features + target in CSV format

Loaded the data into PostGreSQL database in an AWS S3 bucket (via Jupyter Notebook)
 Used pyspark to drop/create table inferring the column data types
 Cleveland data didn't have column headers so table created with generic column names

NEW TABLES:
1. heart_ml_cleveland
2. heart_cardio_risk

Used SQL queries in PGADMIN (kept in schema.sql) to clean the data
1. Cleveland data
   renamed generic columns to column names consistent with documentation on the website
   null values in the dataset were = "?", changed this to NULL
   add new calculated column based on "num" column, which is a value from 0-3, indicate level of heart disease risk
   new column named "target" = 0 if "num" = 0, else set = "1", for binary heart disease indicator
   confirmed no duplicate records

2. Cardio Risk (kaggle) data
   column names were the values of the header row in the csv
   created 5 new columns (ages_yrs, height_inches, weight_lbs, bmi, bmi_category)
     age_yrs = age/365 (origina age in days)
     height_inches = height*0.393701 (original height in cm)
     weight_lbs = weight*2.20462 (original weight in kg)
     bmi = kg/m2 (weight/(height*0.01)(height*0.01))
     bmi_category (underweight: bmi<18.5, healthy weight: 18.5<=bmi<25, overweight: 25<=bmi<30, obese: bmi>=30)

   data cleanup (deleted records that seem invalid/unnecessary):
     1. deleted records with systolic bp (ap_hi)<70
     2. deleted records with diastolic bp (ap_hi)>240
     3. deleted records with systolic bp (ap_lo)<40
     4. deleted records with diastolic bp (ap_lo)>160
     5. deleted records with height > 84 inches (taller than 7ft tall)
     6. deleted records with height < 48 inches (shorter than 4ft tall)
     7. deleted records with weight < 75 lbs 
     8. check for duplicate rows, deleted 34 rows

INPUT DATA (ETL/App Integration)
  1. Created HTML forms to gather input data from user
  2. Created RESTful API using python flask/javascript to capture the data and feed to the ML model
  3. Within python flask app, created additional calculated data based on user input to feed into the machine learning model.
  4. Called the ML model and sent the model out to a route to output results on HTML page






# Visualizations (Sarah, Gargi)







# Predictive Modelling (Harmeet)






# Conclusions (Visualizations conclusion Sarah, Gargi, Modelling: Harmeet)






# Challenges (All)




# Heroku Deployment (Explain the app and deployment) (Emi, make a giff/video of the app that navigate through all tabs and monitors risk and put that here when the app is ready)



# Installations



# To run
