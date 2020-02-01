-- Behavioral risk factors for hear disease dataset
--https://data.world/cdc/behavioral-risk-factor-heart/workspace/query?queryid=sample-0
select count(*) 
from heart_behavior_risk; --35004 records

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