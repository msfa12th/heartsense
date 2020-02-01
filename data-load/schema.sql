-- Create Heart Tables
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



