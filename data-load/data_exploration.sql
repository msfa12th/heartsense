-- Behavioral risk factors for hear disease dataset
-- In this dataset, location data is state based.
--https://data.world/cdc/behavioral-risk-factor-heart/workspace/query?queryid=sample-0

select count(*) 
from heart_behavior_risk; --35004 records

select  "Year", count(*)
from heart_behavior_risk
group by "Year"
order by "Year";
-- Year count
-- 2011	"13186"
-- 2012	"4316"
-- 2013	"13186"
-- 2014	"4316"

select  "Year","Category",
count(*)
from heart_behavior_risk
where "Category" = 'Cardiovascular Diseases'
group by "Year","Category"
order by "Category","Year";

-- 2011	"Cardiovascular Diseases"	"2526"
-- 2013	"Cardiovascular Diseases"	"2526"
-- 2011	"Risk Factors"	"10660"
-- 2012	"Risk Factors"	"4316"
-- 2013	"Risk Factors"	"10660"
-- 2014	"Risk Factors"	"4316"

select  
	"Year","Category","Indicator",
-- 	"Break_Out_Category",
	count(*)
from heart_behavior_risk
where 
	"Category" = 'Cardiovascular Diseases'
	--and "Break_Out_Category" = 'Age'
	
group by "Year","Category","Indicator"
order by "Category","Year","Break_Out_Category"

--** MY CONCLUSION this dataset is insufficient
--** We need to go from data.world to the original source CDC
-- https://catalog.data.gov/dataset/behavioral-risk-factor-data-heart-disease-amp-stroke-prevention
-- https://catalog.data.gov/dataset/national-health-interview-survey-nhis-national-cardiovascular-disease-surveillance-data
-- https://data.cdc.gov/Heart-Disease-Stroke-Prevention/National-Health-Interview-Survey-NHIS-National-Car/fwns-azgu






-- Cleveland Heart Disease Machine Learning dataset
-- https://archive.ics.uci.edu/ml/datasets/Heart+Disease
select count(*) 
from heart_ml_cleveland; --303 records

-- Heart Disease Mortality dataset
-- https://chronicdata.cdc.gov/Heart-Disease-Stroke-Prevention/Heart-Disease-Mortality-Data-Among-US-Adults-35-by/mfvi-hkb9/data
-- Heart Disease Mortality Data Among US Adults (35+) by State/Territory and County – 2015-2017
-- 2015 to 2017, 3-year average. Rates are age-standardized. County rates are spatially smoothed. 
-- The data can be viewed by gender and race/ethnicity. 
-- Data source: National Vital Statistics System. 
-- Additional data, maps, and methodology can be viewed 
-- on the Interactive Atlas of Heart Disease and Stroke 
-- http://www.cdc.gov/dhdsp/maps/atlas

-- this data tells you how many peope died due to heart diease
-- by year (2015 through 2017)
-- by county in the USA (includes geo coordinates), 
-- by gender (Stratification1) 
-- and by race/ethnicity (Stratificaiton2)

select count(*) 
from heart_mortality; -- 59094 records

select
select 
-- 	"Year",
	"LocationDesc",
	count(*) 
from heart_nhis
group by 
-- 	"Year",
	"LocationDesc"
order by 
-- 	"Year",
	"LocationDesc";

-- LocationDescription, count
-- "Midwest"	"3168"
-- "Northeast"	"3168"
-- "South"	"3168"
-- "United States"	"3168"
-- "West"	"3168"

-- year, count() 880 per year 2000 through 2017
-- 2000	"880"

-- Table: public.heart_cardio_train

-- DROP TABLE public.heart_cardio_train;

-- https://www.kaggle.com/sulianova/cardiovascular-disease-dataset

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

-- extra reference link
-- https://medium.com/@dskswu/machine-learning-with-a-heart-predicting-heart-disease-b2e9f24fee84
