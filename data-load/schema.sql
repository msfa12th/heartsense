-- Create Heart Tables:
  -- heart_behavior_risk
  -- heart_cardio_train
  -- heart_ml_cleveland
  -- heart_mortality
  -- heart_nhis

  -- heart_patient => start as empty table, then data collected from app users
        -- will be pushed into the ml model, and output results stored

-- heart_behavior_risk
--      Behavioral risk factors for hear disease dataset
--      In this dataset, location data is state based.
--      https://data.world/cdc/behavioral-risk-factor-heart/workspace/query?queryid=sample-0


-- heart_cardio_train
--      https://www.kaggle.com/sulianova/cardiovascular-disease-dataset

    -- id ID number
    -- age in days
    -- gender 1 - women, 2 - men
    -- height cm
    -- weight kg
    -- ap_hi Systolic blood pressure
    -- ap_lo Diastolic blood pressure
    -- cholesterol 1: normal, 2: above normal, 3: well above normal
    -- gluc 1: normal, 2: above normal, 3: well above normal
    -- smoke whether patient smokes or not (boolean 0 or 1)
    -- alco Binary feature alcohol user
    -- active Binary feature active or sedantary lifestyle
    -- cardio Target variable

-- heart_ml_cleveland
--      Cleveland Heart Disease Machine Learning dataset
--      https://archive.ics.uci.edu/ml/datasets/Heart+Disease


-- heart_mortality
    -- Heart Disease Mortality dataset
    -- https://chronicdata.cdc.gov/Heart-Disease-Stroke-Prevention/Heart-Disease-Mortality-Data-Among-US-Adults-35-by/mfvi-hkb9/data
    -- Heart Disease Mortality Data Among US Adults (35+) by State/Territory and County – 2015-2017
    -- 2015 to 2017, 3-year average. Rates are age-standardized. County rates are spatially smoothed. 
    -- The data can be viewed by gender and race/ethnicity. 
    -- Data source: National Vital Statistics System. 

-- heart_nhis
    -- https://catalog.data.gov/dataset/national-health-interview-survey-nhis-national-cardiovascular-disease-surveillance-data
    -- 2001 forward. The National Health Interview Survey (NHIS) has monitored the health of the nation since 1957. 
    -- NHIS data on a broad range of health topics are collected through personal household interviews. 
    -- Indicators for this dataset has been computed by personnel in CDC's Division for Heart Disease and Stroke Prevention (DHDSP). 
    -- This is one of the datasets provided by the National Cardiovascular Disease Surveillance System. 
    -- The system is designed to integrate multiple indicators from many data sources to provide a comprehensive picture of the public health burden 
    -- of CVDs and associated risk factors in the United States. The data are organized by location (region) and indicator, 
    -- and they include CVDs (e.g., heart failure) and risk factors (e.g., hypertension). The data can be plotted as trends and stratified by age group, sex, and race/ethnicity.



-- extra reference link to explore as time permits

-- another use analyis for comparison
-- https://www.kaggle.com/benanakca/comparison-of-classification-disease-prediction

-- https://medium.com/@dskswu/machine-learning-with-a-heart-predicting-heart-disease-b2e9f24fee84

CREATE TABLE heart_behavior_risk
(
    "Year" integer,
    "LocationAbbr" text,
    "LocationDesc" text,
    "Datasource" text,
    "PriorityArea1" text,
    "PriorityArea2" text,
    "PriorityArea3" text,
    "PriorityArea4" text,
    "Category" text,
    "Topic" text,
    "Indicator" text,
    "Break_Out_Category" text,
    "Break_out" text,
    "Data_Value_Type" text,
    "Data_Value_Unit" text,
    "Data_Value" double precision,
    "Data_Value_Footnote_Symbol" text,
    "Data_Value_Footnote" text,
    "Confidence_Limit_Low" double precision,
    "Confidence_Limit_High" double precision,
    "CategoryID" text,
    "TopicID" text,
    "IndicatorID" text,
    "BreakoutCategoryID" text,
    "BreakOutID" text,
    "LocationID" double precision,
    "GeoLocation" text
);

CREATE TABLE heart_cardio_train
(
    id integer,
    age integer,
    gender integer,
    height integer,
    weight double precision,
    ap_hi integer,
    ap_lo integer,
    cholesterol integer,
    gluc integer,
    smoke integer,
    alco integer,
    active integer,
    cardio integer
);

CREATE TABLE heart_mortality
(
    "Year" integer,
    "LocationAbbr" text,
    "LocationDesc" text,
    "GeographicLevel" text,
    "DataSource" text,
    "Class" text,
    "Topic" text,
    "Data_Value" text,
    "Data_Value_Unit" text,
    "Data_Value_Type" text,
    "Data_Value_Footnote_Symbol" text,
    "Data_Value_Footnote" text,
    "StratificationCategory1" text,
    "Stratification1" text,
    "StratificationCategory2" text,
    "Stratification2" text,
    "TopicID" text,
    "LocationID" integer,
    "Y_lat" double precision,
    "X_lon" double precision,
    "Georeference Column" text,
    "States" integer,
    "Counties" text
);



CREATE TABLE heart_nhis
(
    "Year" integer,
    "LocationAbbr" text,
    "LocationDesc" text,
    "DataSource" text,
    "PriorityArea1" text,
    "PriorityArea2" text,
    "PriorityArea3" text,
    "PriorityArea4" text,
    "Category" text,
    "Topic" text,
    "Indicator" text,
    "Data_Value_Type" text,
    "Data_Value_Unit" text,
    "Data_Value" double precision,
    "Data_Value_Alt" double precision,
    "Data_Value_Footnote_Symbol" text,
    "Data_Value_Footnote" text,
    "LowConfidenceLimit" double precision,
    "HighConfidenceLimit" double precision,
    "Break_Out_Category" text,
    "Break_Out" text,
    "CategoryId" text,
    "TopicId" text,
    "IndicatorID" text,
    "Data_Value_TypeID" text,
    "BreakOutCategoryId" text,
    "BreakOutId" text,
    "LocationID" integer,
    "GeoLocation" text
);



CREATE TABLE heart_patient
(
    id serial,
	  name text,
	  input_date date,
    age integer,
    gender integer,
    height integer,
    weight double precision,
    ap_hi integer,
    ap_lo integer,
    cholesterol integer,
    gluc integer,
    smoke integer,
    alco integer,
    active integer,
    cardio integer
);



-- initially created tables with stub columns
-- then used pyspark to drop/recreate tables using pyspark inferSchema
-- capturing initial schema columns above based on csv
-- below showing alterations made after data placed in the tables

-- cleveland data didn't have headers
-- after pulling in the data renamed to match documentation
ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c0 TO age;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c1 TO sex;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c2 TO cp;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c3 TO trestbps;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c4 TO chol;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c5 TO fbs;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c6 TO restecg;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c7 TO thalach;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c8 TO exang;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c9 TO oldpeak;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c10 TO slope;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c11 TO ca;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c12 TO thal;

ALTER TABLE heart_ml_cleveland 
RENAME COLUMN _c13 TO num;

-- pyspark inserted '?' for null values when table initially created
-- and then made data type for columns with '?' text even if all other values where numbers
-- so I changed the value to NULL and changed datatype to numbers
--
update heart_ml_cleveland
set thal=null
where thal='?';

update heart_ml_cleveland
set ca=null
where ca='?';

ALTER TABLE heart_ml_cleveland
ALTER COLUMN ca TYPE double precision USING ca::double precision;

ALTER TABLE heart_ml_cleveland
ALTER COLUMN thal TYPE double precision USING thal::double precision;


--rename all columns to be lower case

-- Table: public.heart_behavior_risk

-- DROP TABLE public.heart_behavior_risk;

alter table heart_behavior_risk RENAME COLUMN "Year" to year;
alter table heart_behavior_risk RENAME COLUMN "LocationAbbr" to locationabbr;
alter table heart_behavior_risk RENAME COLUMN "LocationDesc" to locationdesc;
alter table heart_behavior_risk RENAME COLUMN "Datasource" to datasource;
alter table heart_behavior_risk RENAME COLUMN "PriorityArea1" to priorityarea1;
alter table heart_behavior_risk RENAME COLUMN "PriorityArea2" to priorityarea2;
alter table heart_behavior_risk RENAME COLUMN "PriorityArea3" to priorityarea3;
alter table heart_behavior_risk RENAME COLUMN "PriorityArea4" to priorityarea4;
alter table heart_behavior_risk RENAME COLUMN "Category" to category;
alter table heart_behavior_risk RENAME COLUMN "Topic" to topic;
alter table heart_behavior_risk RENAME COLUMN "Indicator" to indicator;
alter table heart_behavior_risk RENAME COLUMN "Break_Out_Category" to break_out_category;
alter table heart_behavior_risk RENAME COLUMN "Break_out" to break_out;
alter table heart_behavior_risk RENAME COLUMN "Data_Value_Type" to data_value_type;
alter table heart_behavior_risk RENAME COLUMN "Data_Value_Unit" to data_value_unit;
alter table heart_behavior_risk RENAME COLUMN "Data_Value" to data_value;
alter table heart_behavior_risk RENAME COLUMN "Data_Value_Footnote_Symbol" to data_value_footnote_symbol;
alter table heart_behavior_risk RENAME COLUMN "Data_Value_Footnote" to data_value_footnote;
alter table heart_behavior_risk RENAME COLUMN "Confidence_Limit_Low" to confidence_limit_low;
alter table heart_behavior_risk RENAME COLUMN "Confidence_Limit_High" to confidence_limit_high;
alter table heart_behavior_risk RENAME COLUMN "CategoryID" to categoryid;
alter table heart_behavior_risk RENAME COLUMN "TopicID" to topicid;
alter table heart_behavior_risk RENAME COLUMN "IndicatorID" to indicatorid;
alter table heart_behavior_risk RENAME COLUMN "BreakoutCategoryID" to breakoutcategoryid;
alter table heart_behavior_risk RENAME COLUMN "BreakOutID" to breakoutid;
alter table heart_behavior_risk RENAME COLUMN "LocationID" to locationid;
alter table heart_behavior_risk RENAME COLUMN "GeoLocation" to geolocation;



alter table heart_behavior_risk RENAME COLUMN year to "Year";
alter table heart_behavior_risk RENAME COLUMN locationabbr to "LocationAbbr" ;
alter table heart_behavior_risk RENAME COLUMN locationdesc to "LocationDesc";
alter table heart_behavior_risk RENAME COLUMN datasource to "Datasource";
alter table heart_behavior_risk RENAME COLUMN priorityarea1 to "PriorityArea1";
alter table heart_behavior_risk RENAME COLUMN priorityarea2 to "PriorityArea2";
alter table heart_behavior_risk RENAME COLUMN priorityarea3 to "PriorityArea3";
alter table heart_behavior_risk RENAME COLUMN priorityarea4 to "PriorityArea4";
alter table heart_behavior_risk RENAME COLUMN category to "Category";
alter table heart_behavior_risk RENAME COLUMN topic to "Topic";
alter table heart_behavior_risk RENAME COLUMN indicator to "Indicator";
alter table heart_behavior_risk RENAME COLUMN break_out_category to "Break_Out_Category";
alter table heart_behavior_risk RENAME COLUMN break_out to "Break_out";    
alter table heart_behavior_risk RENAME COLUMN data_value_type to "Data_Value_Type";
alter table heart_behavior_risk RENAME COLUMN data_value_unit to "Data_Value_Unit";
alter table heart_behavior_risk RENAME COLUMN data_value to "Data_Value";
alter table heart_behavior_risk RENAME COLUMN data_value_footnote_symbol to "Data_Value_Footnote_Symbol";
alter table heart_behavior_risk RENAME COLUMN data_value_footnote to "Data_Value_Footnote";
alter table heart_behavior_risk RENAME COLUMN confidence_limit_low to "Confidence_Limit_Low";
alter table heart_behavior_risk RENAME COLUMN confidence_limit_high to "Confidence_Limit_High";
alter table heart_behavior_risk RENAME COLUMN categoryid to "CategoryID";
alter table heart_behavior_risk RENAME COLUMN topicid to "TopicID";
alter table heart_behavior_risk RENAME COLUMN indicatorid to "IndicatorID";
alter table heart_behavior_risk RENAME COLUMN breakoutcategoryid to "BreakoutCategoryID";
alter table heart_behavior_risk RENAME COLUMN breakoutid to "BreakOutID";
alter table heart_behavior_risk RENAME COLUMN locationid to "LocationID";
alter table heart_behavior_risk RENAME COLUMN geolocation to "GeoLocation";

-- consider making columns lower case

-- add primary key for work with python flask sqlalchemy base automap
ALTER TABLE heart_behavior_risk ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE heart_behavior_risk ADD PRIMARY KEY (id);
