
[![GitHub issues](https://img.shields.io/github/issues/msfa12th/heartsense?style=for-the-badge)](https://github.com/msfa12th/heartsense/issues)
[![GitHub forks](https://img.shields.io/github/forks/msfa12th/heartsense?style=for-the-badge)](https://github.com/msfa12th/heartsense/network)
[![GitHub stars](https://img.shields.io/github/stars/msfa12th/heartsense?style=for-the-badge)](https://github.com/msfa12th/heartsense/stargazers)
[![GitHub license](https://img.shields.io/github/license/msfa12th/heartsense?style=for-the-badge)](https://github.com/msfa12th/heartsense)
# LUB DUB : A Machine Learning Based App for Non-invasive Diagnosis of Heart Disease.

## Summary:
<dt>According to the WHO, cardiovascular diseases (CVDs) are the number one cause of death globally, taking an estimated 17.9 million lives each year. Extensive research has identified factors that increase a person’s risk for coronary heart disease in general and heart attack in particular.The American Heart Association recommends focusing on heart disease prevention early in life. To start, assess your risk factors and work to keep them low. The sooner you identify and manage your risk factors, the better your chances of leading a heart-healthy life. This project is aimed at understanding some of the risk factors associated with heart disease and build a predictive model thereof citing the potential risk of occurrence in individuals. 
</dt>
The app is deployed at (Heroku link)

## Team members:
Mary Brown, Harmeet Kaur, Emi Babu, Sarah Mathew, Gargi Paul

## Data (ETL and App Integration) (Mary)
Original Source Data (extraction, transformation and load):

Pulled source data in CSV format from two websites 
1. Cleveland - https://archive.ics.uci.edu/ml/datasets/Heart+Disease
  Heart Disease Data Set originally from the University of California, Irvine Machine Learning Repository
  Many versions of the data are provided on this website.
  We chose to use the data set that was processed/cleansed by a Cleveland ML team. 
  The dataset contains approximately 14 medical attributes for approximately 300 patients.
  Numerical data stored in a semicolon delimited file.

2. Cardio Risk - https://www.kaggle.com/sulianova/cardiovascular-disease-dataset
  Cardiovascular Disease dataset from Kaggle
  The dataset consists of 70,000 records of patient data, 11 features + target in CSV format.

Loaded the data into PostGreSQL database in an AWS S3 bucket (via Jupyter Notebook). 
 Used pyspark to drop/create table inferring the column data types
 Cleveland data didn't have column headers so table created with generic column names.

NEW TABLES:

1. heart_cardio_risk

Used SQL queries in PGADMIN  schema.sql) to clean the data
1. Cleveland data
   renamed generic columns to column names consistent with documentation on the website
   null values in the dataset were = "?", changed this to NULL
   add new calculated column based on "num" column, which is a value from 0-3, indicate level of heart disease risk
   new column named "target" = 0 if "num" = 0, else set = "1", for binary heart disease indicator
   confirmed no duplicate records.

2. Cardio Risk (kaggle) data
   Column names were the values of the header row in the csv
   **Feature engineering and tansformation** (ages_yrs, height_inches, weight_lbs, bmi, bmi_category)
     1. age_yrs = age/365 (original age in days)
     2. height_inches = height*0.393701 (original height in cm)
     3. weight_lbs = weight*2.20462 (original weight in kg)
     4. bmi = kg/m2 = (weight/(height\*0.01)(height\*0.01))
     5. bmi_category (underweight: bmi<18.5, healthy weight: 18.5<=bmi<25, overweight: 25<=bmi<30, obese: bmi>=30)

   **Data cleanup** (deleted outliers):
     1. deleted records with systolic bp (ap_hi)<70 and systolic bp (ap_lo)<40
     2. deleted records with diastolic bp (ap_hi)>240 and diastolic bp (ap_lo)>160
     3. deleted records with height > 84 inches (taller than 7ft tall) and < 48 inches (shorter than 4ft tall)
     4. deleted records with weight < 75 lbs 
     5. 34 duplicate rows deleted 




## Visualizations (Sarah, Gargi)

**BI Tool used: Tableau**

Dataset: The dataset contained 13 columns, 12 features and 1 target (cardio). The target has two classes (0- heart disease "Absent", 1-heart disease "Present").

Tableau's analytics was leveraged to generate trend lines and averages for the plots. For interpretation of the data, the following calculated fields were created:
Cardio =0 "Absent" else "Present".For BMI,calculated field was height in cms/weight in kg square. Condition for BMI was 18 to 25 = "Normal", 25 to 30 = "Over weight" and more than 30 = "Obese". For Blood Pressure one common column was created to check if BP is normal or high. Condition was (Ap lo)<=80 and (Ap hi) <=120 considered as "Normal" else "High Blood Pressure".For Gender, condition was 1= male and 2=female. Condition for Cholesterol was Cholesterol= 1 "Normal, Cholesterol = 2 "Slightly Elevated", else "High Cholesterol".Condition for glocose was Glucose, Gluc = 1 "Normal", Gluc = 2 "Pre Diabetic", else "Diabetic". For Alcohol, condition was Alco = 0 "No Consumption" else "Consumption".

**Visualizations displayed:** 
1. BMI vs Age [Density plot]
2. Role of Age & Weight [Heat map]
3. Gender vs Age [Line plot]
4. Gender vs Heart Disease [Pie plot]
5. Blood Pressure vs Age [Area plot]
6. Cholesterol levels [Pie plot]
7. Smoking vs Blood Pressure [Bar plot]
8. Glucose vs Heart Disease [Circle plot]
9. Alcohol Consumption vs Heart Disease [Bar plot]


## Predictive Supervised Machine Learning:

**Dataset:** The dataset had 13 columns, 12 features and 1 target (cardio). The target has two classes (0- heart disease absent, 1-heart disease present).

**Libraries used:** Scikit-learn, Keras, Tensorflow

### **Data pre-processing:**

Feature Engineering: A new feature was added called BMI(Basal Metabolic Index) during ETL that took information of height and weight to return BMI values of individuals. Thus the dataset now had 6 continuous variables and 6 label-encoded categorical features. 

**Exploratory Data Analysis:**
EDA was performed in pandas to analyze the data, identify outliers, imbalanced features, data distribution, duplicate and null values. Data munging and transformation led to formation of a clean dataset.

**Feature Selection:**
Following statistical tests were performed to select the best features for modeling and avoid over-fitting.

1.Univariate Selection:
The scikit-learn library provides the SelectKBest class that can be used with a suite of different statistical tests to select a specific number of features. The code below uses the chi-squared (chi²) statistical test to select 10 of the best features.
1. Feature importance:
Feature importance is an inbuilt class that comes with Tree Based Classifiers. Extra Tree Classifier is used for extracting the top 10 features for the dataset.
1.Correlation Matrix with Heatmap
Correlation heatmap is built using the seaborn library to identify which features are most related to each other or the target variable and identify redundant data and eliminate threof to reduce over-fitting.
The following features were selected based on consensus of the processes. 
**gender, systolic pressure, diastolic pressure, cholesterol, age_yrs, weight_lbs, bmi**
 While smoke and alcohol are known to be great risk factors, but their distribution in the classes is highly imbalanced to train the model. Also, they show negative correlation with the target in the heatmap. 

**Scaling:**
Continuous features were standardized before data splitting into train and test set using StandardScaler such that the mean of the values was 0 and the standard deviation was 1. Categorical features were already label encoded. 

**Data Splitting:**
Data was splitted into random train and test subsets prior to model building. Since the target class had approximately equal ratio of datapoints, stratification was not performed. Both the train and test dataset had an approx. equal data distribution

**Model Building:**
The problem being addressed is a binary classification, hence the following machine learning classification algorithms were deployed for initial model building:
1.	**Logistic Regression:** Using default parameters the score was 72.63.

2.	**K Nearest Neighbors :** The classification parameters are values of neighbors (k) and distance. Different values of neighbours were used (k=1 to 20) to check the best output score. Best score was obtained for k= 19 at 72.19.

3.	**Support Vector Machine:** SVC was tested for all the kernels i.e. 'linear', 'poly', 'rbf', 'sigmoid'. Best score was obtained for ‘rbf’ at 73.09. 

4.	**Decision Tree:** Randomness of a tree is determined by parameter, ‘max_features’ . For classification max_features is set to sqrt(n_features) and best score was 64.46.

5.	**Random Forest:** Models were built with varying number of estimators i.e. number of trees to be built. Best score  of 69.94 was obtained at estimator=1000.

6.	**Naïve Bayes:** Model was built using GaussianNB classifier with a score of 71.23.

7. **Neural Network:** Model was built by varying the number of nodes as well as depth of the model with additional layer. As it was a binary classification model, loss was set to 'binary_crossentropy' , optimizer was ‘adam’. For activation, ‘relu’ was used. Model was generated with 100 epochs. Overall accuracy was 73.1. 

Since the scores for both Neural Network and Support Vector Machine model was above 73%, they were further subjected to hyperparameter tuning using GridSearch. The models obtained were evaluated for precision, recall, F1-score. Based on the comparative analysis, the model built using Support Vector Classifier algorithm with hyperparameters (‘C’: 5, ‘gamma’: 0.005) was chosen as the final candidate model. The accuracy of the model is 73%. 
**Pipeline followed for model building is explained in the figure below:**

![Alt Text](https://github.com/msfa12th/heartsense/blob/master/ML-pipeline.png)



## App Integration
An HTML form was created to gather input data from user. RESTful API was created using python flask/javascript to capture the data and feed to the ML model. Within python flask app, additional calculated data was created for bmi, based on user input to feed into the machine learning model. The ML model called was sent out to a route to output results/prediction on HTML page.


## Findings
The following have been observed from Visualization analysis:
1. BMI has a correlation with age, people tend to be more obese with age.
2. Age is one of the important factors for weight gain. There is a higher tendency of weight gain between 50 to 60 years which puts them in a risk category for heart disease.
3. Males are more prone to heart disease than females.
4. Chance of heart disease is 50% more with high blood pressure.
5. High Cholesterol is one of the major key factors for heart disease.
6. Smoking, alcohol consumption and physical activity do not show any noticeable impact in the tested dataset.

## Conclusion
With age, metabolism tends to slow down which leads to obesity. Therefore, one needs to keep check of one's diet to control sugar and fat(cholesterol) intake which may lead to higher blood pressure. While our dataset did not show significant coorelation of smoking, alcohol consumption and physical activity but these have been cited as behavioural risk factors affecting heart life. There are many other risk factors like genetic pre-disposition, salt intake etc. that have not been a aprt of the dataset and hence not analyzed. Therefore, the output of the app could be an approximate prediction. With this app, a common man can access his risk for the disease and can thereby take preventive measures to control it. This model is for predictive purposes only and should not be used as medical advice.

## Challenges 
1. The accuracy of the model obtained after hyperparameter tuning using GridSearch was 73%. The model would need further optimization and parameter tuning to increase the score. Since the process is highly compute intensive and time consuming, this is what could be achieved in the given time frame. 
2. Trained models initially had very low accuracy (65%) when all the features were used. Hyperparamteter tuning did not much affect the score. Finally, based off of statistical analysis and correlation matrix, dimensional space of the features was narrowed that significantly increased the model score.
3. Though we could pull data from PostgreSQL database on Tableau Desktop (using student license), it wasn't possible to publish the visualization dashboard to a webpage. Hence Tableau Public was used for visualization using csv(s) imported from the database (as it didn't let direct database connectivity). 
4. To view the embedded tableau dashboard on the html page as a whole, a specific dimension (min: 800px x 2260px and max: 1520x x 2660) had to be used.




## Heroku Deployment (giff)



## Installations

pip install requirements.txt


## To run locally
Clone the repo, run app.py
