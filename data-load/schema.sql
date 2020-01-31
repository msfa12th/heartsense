-- Create Active User Table
CREATE TABLE behavior_risk (
  Year int,
  LocationAbbr text,
  LocationDesc text,
  Datasource text,
  PriorityArea1 text,
  PriorityArea2 text,
  PriorityArea3 text,
  PriorityArea4 text,
  Category text,
  Topic text,
  Indicator text,
  Break_Out_Category text,
  Break_out text,
  Data_Value_Type text,
  Data_Value_Unit text,
  Data_Value number,
  Data_Value_Footnote_Symbol text,
  Data_Value_Footnote text,
  Confidence_Limit_Low number,
  Confidence_Limit_High number,
  CategoryID int,
  TopicID int,
  IndicatorID int,
  BreakoutCategoryID int,
  BreakOutID int,
  LocationID int,
  GeoLocation text
);

CREATE TABLE heart_mortality (
    Year int,
    LocationAbbr text,
    LocationDesc text,
    GeographicLevel text,
    DataSource text,
    Class text,
    Topic text,
    Data_Value text,
    Data_Value_Unit text,
    Data_Value_Type text,
    Data_Value_Footnote_Symbol text,
    Data_Value_Footnote text,
    StratificationCategory1 text,
    Stratification1 text,
    StratificationCategory2 text,
    Stratification2 text,
    TopicID text,
    LocationID text, 
    Y_lat text,
    X_lon text,
    Georeference text,
    States text,
    Counties text
);

CREATE TABLE heart_ml_cleveland (
    age int,
    sex int,
    cp int,
    trestbps int,
    chol int,
    fbs int,
    restecg int,
    thalach int,
    exang int,
    oldpeak int,
    slope int,
    ca int,
    thal int,
    num int
);



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



