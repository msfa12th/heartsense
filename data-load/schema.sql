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
  GeoLocation text,
);

CREATE TABLE billing_info (
  billing_id INT PRIMARY KEY NOT NULL,
  street_address TEXT,
  state TEXT,
  username TEXT
);

CREATE TABLE payment_info (
  billing_id INT PRIMARY KEY NOT NULL,
  cc_encrypted TEXT
);
