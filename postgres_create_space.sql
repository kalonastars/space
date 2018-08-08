-- This file creates the space schema for Postgres databases.
-- Version 1.2.0, generated on 2018-08-08.
-- DO NOT MODIFY THIS FILE.  It is automatically generated.

-- Print intro message.
\echo ------------------------------------------------------------------------
\echo -- Installing space database version 1.2.0, generated on 2018-08-08.
\echo --
\echo -- This data is from JSR Launch Vehicle Database, 2017 Dec 28 Edition.
\echo -- This file was generated by Jon Heller, jon@jonheller.org.
\echo -- The database installs 20 tables and uses about 27MB of space.
\echo --
\echo -- The installation will run for about a minute and will stop on any
\echo -- errors.  You should see a "done" message at the end.
\echo ------------------------------------------------------------------------

-- Session settings.
set client_encoding to 'utf8';




--------------------------------------------------------------------------------
-- ORGANIZATION
--------------------------------------------------------------------------------


CREATE TABLE ORGANIZATION 
 (	ORG_CODE VARCHAR(9), 
	ORG_NAME VARCHAR(81), 
	ORG_CLASS VARCHAR(29), 
	PARENT_ORG_CODE VARCHAR(13), 
	ORG_STATE_CODE VARCHAR(7), 
	ORG_LOCATION VARCHAR(53), 
	ORG_START_DATE DATE, 
	ORG_STOP_DATE DATE, 
	ORG_UTF8_NAME VARCHAR(230), 
	 CONSTRAINT ORGANIZATION_PK PRIMARY KEY (ORG_CODE)
  
 ) ;

\copy ORGANIZATION from 'c:\space\ORGANIZATION.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- PLATFORM
--------------------------------------------------------------------------------


CREATE TABLE PLATFORM 
 (	PLATFORM_CODE VARCHAR(11), 
	PLATFORM_UCODE VARCHAR(12), 
	PLATFORM_STATE_ORG_CODE VARCHAR(8), 
	PLATFORM_TYPE VARCHAR(17), 
	PLATFORM_CLASS VARCHAR(29), 
	PLATFORM_SHORT_NAME VARCHAR(18), 
	PLATFORM_NAME VARCHAR(81), 
	PLATFORM_PARENT_ORG_CODE VARCHAR(13), 
	 CONSTRAINT PLATFORM_PK PRIMARY KEY (PLATFORM_CODE)
  , 
	 CONSTRAINT PLATFORM_STATE_FK FOREIGN KEY (PLATFORM_STATE_ORG_CODE)
	  REFERENCES ORGANIZATION (ORG_CODE) , 
	 CONSTRAINT PLATFORM_PARENT_FK FOREIGN KEY (PLATFORM_PARENT_ORG_CODE)
	  REFERENCES ORGANIZATION (ORG_CODE) 
 ) ;


CREATE INDEX PLATFORM_IDX1 ON PLATFORM (PLATFORM_STATE_ORG_CODE) 
;

CREATE INDEX PLATFORM_IDX2 ON PLATFORM (PLATFORM_PARENT_ORG_CODE) 
;
\copy PLATFORM from 'c:\space\PLATFORM.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- ORGANIZATION_ORG_TYPE
--------------------------------------------------------------------------------


CREATE TABLE ORGANIZATION_ORG_TYPE 
 (	ORG_CODE VARCHAR(9), 
	ORG_TYPE VARCHAR(4000), 
	 CONSTRAINT ORGANIZATION_ORG_TYPE_PK PRIMARY KEY (ORG_CODE, ORG_TYPE)
  , 
	 CONSTRAINT ORGANIZATION_ORG_TYPE_KK FOREIGN KEY (ORG_CODE)
	  REFERENCES ORGANIZATION (ORG_CODE) 
 ) ;

\copy ORGANIZATION_ORG_TYPE from 'c:\space\ORGANIZATION_ORG_TYPE.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- SITE
--------------------------------------------------------------------------------


CREATE TABLE SITE 
 (	SITE_ID NUMERIC, 
	SITE_NAME VARCHAR(9), 
	SITE_CODE VARCHAR(13), 
	SITE_TYPE VARCHAR(32), 
	STATE_ORG_CODE VARCHAR(9), 
	START_DATE DATE, 
	STOP_DATE DATE, 
	SITE_SHORT_NAME VARCHAR(18), 
	SITE_FULL_NAME VARCHAR(81), 
	SITE_LOCATION VARCHAR(53), 
	LONGITUDE NUMERIC, 
	LATITUDE NUMERIC, 
	DEGREES_UNCERTAINTY NUMERIC, 
	 CONSTRAINT SITE_PK PRIMARY KEY (SITE_ID)
  , 
	 CONSTRAINT SITE_ORG_FK FOREIGN KEY (STATE_ORG_CODE)
	  REFERENCES ORGANIZATION (ORG_CODE) 
 ) ;


CREATE INDEX SITE_IDX ON SITE (STATE_ORG_CODE) 
;
\copy SITE from 'c:\space\SITE.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- SITE_ORG
--------------------------------------------------------------------------------


CREATE TABLE SITE_ORG 
 (	SITE_ID NUMERIC, 
	ORG_CODE VARCHAR(4000), 
	 CONSTRAINT SITE_ORG_PK PRIMARY KEY (SITE_ID, ORG_CODE)
  , 
	 CONSTRAINT SITE_ORG_SITE_FK FOREIGN KEY (SITE_ID)
	  REFERENCES SITE (SITE_ID) , 
	 CONSTRAINT SITE_ORG_ORG_FK FOREIGN KEY (ORG_CODE)
	  REFERENCES ORGANIZATION (ORG_CODE) 
 ) ;

\copy SITE_ORG from 'c:\space\SITE_ORG.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- LAUNCH_VEHICLE_FAMILY
--------------------------------------------------------------------------------


CREATE TABLE LAUNCH_VEHICLE_FAMILY 
 (	LV_FAMILY_CODE VARCHAR(21), 
	LV_FAMILY_CLASS VARCHAR(28), 
	 CONSTRAINT LAUNCH_VEHICLE_FAMILY_PK PRIMARY KEY (LV_FAMILY_CODE)
  
 ) ;

\copy LAUNCH_VEHICLE_FAMILY from 'c:\space\LAUNCH_VEHICLE_FAMILY.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- LAUNCH_VEHICLE
--------------------------------------------------------------------------------


CREATE TABLE LAUNCH_VEHICLE 
 (	LV_ID NUMERIC, 
	LV_NAME VARCHAR(33), 
	LV_VARIANT VARCHAR(11), 
	LV_CLASS VARCHAR(37), 
	LV_FAMILY_CODE VARCHAR(21), 
	LV_ALIAS VARCHAR(20), 
	MIN_STAGE NUMERIC, 
	MAX_STAGE NUMERIC, 
	LENGTH NUMERIC, 
	DIAMETER NUMERIC, 
	LAUNCH_MASS NUMERIC, 
	LEO_CAPACITY NUMERIC, 
	GTO_CAPACITY NUMERIC, 
	TAKE_OFF_THRUST NUMERIC, 
	APOGEE NUMERIC, 
	RANGE NUMERIC, 
	 CONSTRAINT LAUNCH_VEHICLE_PK PRIMARY KEY (LV_ID)
  , 
	 CONSTRAINT LAUNCH_VEHICLE_UQ UNIQUE (LV_NAME, LV_VARIANT)
  , 
	 CONSTRAINT LAUNCH_VEHICLE_FAMILY_FK FOREIGN KEY (LV_FAMILY_CODE)
	  REFERENCES LAUNCH_VEHICLE_FAMILY (LV_FAMILY_CODE) 
 ) ;


CREATE INDEX LAUNCH_VEHICLE_IDX1 ON LAUNCH_VEHICLE (LV_FAMILY_CODE) 
;
\copy LAUNCH_VEHICLE from 'c:\space\LAUNCH_VEHICLE.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- LAUNCH_VEHICLE_MANUFACTURER
--------------------------------------------------------------------------------


CREATE TABLE LAUNCH_VEHICLE_MANUFACTURER 
 (	LV_ID NUMERIC, 
	LV_MANUFACTURER_ORG_CODE VARCHAR(4000), 
	 CONSTRAINT LAUNCH_VEHICLE_MAN_ORG_PK PRIMARY KEY (LV_ID, LV_MANUFACTURER_ORG_CODE)
  , 
	 CONSTRAINT LAUNCH_VEHICLE_MAN_ORG_FK1 FOREIGN KEY (LV_MANUFACTURER_ORG_CODE)
	  REFERENCES ORGANIZATION (ORG_CODE) , 
	 CONSTRAINT LAUNCH_VEHICLE_MAN_ORG_FK2 FOREIGN KEY (LV_ID)
	  REFERENCES LAUNCH_VEHICLE (LV_ID) 
 ) ;


CREATE INDEX LAUNCH_VEHICLE_MANUFACT_IDX1 ON LAUNCH_VEHICLE_MANUFACTURER (LV_MANUFACTURER_ORG_CODE) 
;
\copy LAUNCH_VEHICLE_MANUFACTURER from 'c:\space\LAUNCH_VEHICLE_MANUFACTURER.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- LAUNCH
--------------------------------------------------------------------------------


CREATE TABLE LAUNCH 
 (	LAUNCH_ID NUMERIC, 
	LAUNCH_TAG VARCHAR(15), 
	LAUNCH_DATE DATE, 
	LAUNCH_CATEGORY VARCHAR(31), 
	LAUNCH_STATUS VARCHAR(31), 
	LV_ID NUMERIC, 
	FLIGHT_ID1 VARCHAR(21), 
	FLIGHT_ID2 VARCHAR(25), 
	MISSION VARCHAR(25), 
	FLIGHTCODE VARCHAR(25), 
	FLIGHT_TYPE VARCHAR(25), 
	SITE_ID NUMERIC, 
	PLATFORM_CODE VARCHAR(10), 
	APOGEE NUMERIC, 
	 CONSTRAINT LAUNCH_PK PRIMARY KEY (LAUNCH_ID)
  , 
	 CONSTRAINT LAUNCH_LV_FK FOREIGN KEY (LV_ID)
	  REFERENCES LAUNCH_VEHICLE (LV_ID) , 
	 CONSTRAINT LAUNCH_SITE_FK FOREIGN KEY (SITE_ID)
	  REFERENCES SITE (SITE_ID) , 
	 CONSTRAINT LAUNCH_PLATFORM_FK FOREIGN KEY (PLATFORM_CODE)
	  REFERENCES PLATFORM (PLATFORM_CODE) 
 ) ;


CREATE INDEX LAUNCH_IDX1 ON LAUNCH (LV_ID) 
;

CREATE INDEX LAUNCH_IDX2 ON LAUNCH (SITE_ID) 
;

CREATE INDEX LAUNCH_IDX3 ON LAUNCH (PLATFORM_CODE) 
;

CREATE INDEX LAUNCH_IDX4 ON LAUNCH (LAUNCH_TAG) 
;
\copy LAUNCH from 'c:\space\LAUNCH.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- LAUNCH_PAYLOAD_ORG
--------------------------------------------------------------------------------


CREATE TABLE LAUNCH_PAYLOAD_ORG 
 (	LAUNCH_ID NUMERIC, 
	PAYLOAD_ORG_CODE VARCHAR(4000), 
	 CONSTRAINT LAUNCH_PAYLOAD_ORG_PK PRIMARY KEY (LAUNCH_ID, PAYLOAD_ORG_CODE)
  , 
	 CONSTRAINT LAUNCH_PAYLOAD_ORG_LAUNCH_FK FOREIGN KEY (LAUNCH_ID)
	  REFERENCES LAUNCH (LAUNCH_ID) , 
	 CONSTRAINT LAUNCH_PAYLOAD_ORG_ORG_FK FOREIGN KEY (PAYLOAD_ORG_CODE)
	  REFERENCES ORGANIZATION (ORG_CODE) 
 ) ;

\copy LAUNCH_PAYLOAD_ORG from 'c:\space\LAUNCH_PAYLOAD_ORG.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- LAUNCH_AGENCY
--------------------------------------------------------------------------------


CREATE TABLE LAUNCH_AGENCY 
 (	LAUNCH_ID NUMERIC, 
	AGENCY_ORG_CODE VARCHAR(4000), 
	 CONSTRAINT LAUNCH_AGENCY_PK PRIMARY KEY (LAUNCH_ID, AGENCY_ORG_CODE)
  , 
	 CONSTRAINT LAUNCH_AGENCY_LAUNCH_FK FOREIGN KEY (LAUNCH_ID)
	  REFERENCES LAUNCH (LAUNCH_ID) , 
	 CONSTRAINT LAUNCH_AGENCY_ORG_FK FOREIGN KEY (AGENCY_ORG_CODE)
	  REFERENCES ORGANIZATION (ORG_CODE) 
 ) ;

\copy LAUNCH_AGENCY from 'c:\space\LAUNCH_AGENCY.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- SATELLITE
--------------------------------------------------------------------------------


CREATE TABLE SATELLITE 
 (	SATELLITE_ID NUMERIC, 
	NORAD_ID VARCHAR(28), 
	COSPAR VARCHAR(15), 
	OFFICIAL_NAME VARCHAR(41), 
	SECONDARY_NAME VARCHAR(25), 
	LAUNCH_ID NUMERIC, 
	CURRENT_STATUS VARCHAR(17), 
	STATUS_DATE DATE, 
	ORBIT_DATE DATE, 
	ORBIT_PERIOD NUMERIC, 
	PERIGEE NUMERIC, 
	APOGEE NUMERIC, 
	INCLINATION NUMERIC, 
	ORBIT_CLASS VARCHAR(35), 
	 CONSTRAINT SATELLITE_PK PRIMARY KEY (SATELLITE_ID)
  , 
	 CONSTRAINT SATELLITE_FK FOREIGN KEY (LAUNCH_ID)
	  REFERENCES LAUNCH (LAUNCH_ID) 
 ) ;


CREATE INDEX SATELLITE_IDX1 ON SATELLITE (LAUNCH_ID) 
;
\copy SATELLITE from 'c:\space\SATELLITE.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- SATELLITE_ORG
--------------------------------------------------------------------------------


CREATE TABLE SATELLITE_ORG 
 (	SATELLITE_ID NUMERIC, 
	OWNER_OPERATOR_ORG_CODE VARCHAR(4000), 
	 CONSTRAINT SATELLITE_ORG_PK PRIMARY KEY (SATELLITE_ID, OWNER_OPERATOR_ORG_CODE)
  , 
	 CONSTRAINT SATELLITE_ORG_SAT_FK FOREIGN KEY (SATELLITE_ID)
	  REFERENCES SATELLITE (SATELLITE_ID) , 
	 CONSTRAINT SATELLITE_ORG_ORG_FK FOREIGN KEY (OWNER_OPERATOR_ORG_CODE)
	  REFERENCES ORGANIZATION (ORG_CODE) 
 ) ;

\copy SATELLITE_ORG from 'c:\space\SATELLITE_ORG.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- ENGINE
--------------------------------------------------------------------------------


CREATE TABLE ENGINE 
 (	ENGINE_ID NUMERIC, 
	ENGINE_NAME VARCHAR(21), 
	ENGINE_FAMILY VARCHAR(21), 
	ENGINE_ALT_NAME VARCHAR(13), 
	FIRST_LAUNCH_YEAR NUMERIC, 
	USAGE VARCHAR(20), 
	MASS NUMERIC, 
	IMPULSE NUMERIC, 
	THRUST NUMERIC, 
	SPECIFIC_IMPULSE NUMERIC, 
	DURATION NUMERIC, 
	CHAMBER_COUNT NUMERIC, 
	 CONSTRAINT ENGINE_PK PRIMARY KEY (ENGINE_ID)
  
 ) ;

\copy ENGINE from 'c:\space\ENGINE.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- STAGE
--------------------------------------------------------------------------------


CREATE TABLE STAGE 
 (	STAGE_NAME VARCHAR(21), 
	STAGE_FAMILY VARCHAR(21), 
	STAGE_ALT_NAME VARCHAR(21), 
	LENGTH NUMERIC, 
	DIAMETER NUMERIC, 
	LAUNCH_MASS NUMERIC, 
	DRY_MASS NUMERIC, 
	THRUST NUMERIC, 
	DURATION NUMERIC, 
	ENGINE_ID NUMERIC, 
	ENGINE_COUNT NUMERIC, 
	 CONSTRAINT STAGE_PK PRIMARY KEY (STAGE_NAME)
  , 
	 CONSTRAINT STAGE_ENGINE_FK FOREIGN KEY (ENGINE_ID)
	  REFERENCES ENGINE (ENGINE_ID) 
 ) ;


CREATE INDEX STAGE_IDX1 ON STAGE (ENGINE_ID) 
;
\copy STAGE from 'c:\space\STAGE.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- LAUNCH_VEHICLE_STAGE
--------------------------------------------------------------------------------


CREATE TABLE LAUNCH_VEHICLE_STAGE 
 (	LV_ID NUMERIC, 
	STAGE_NAME VARCHAR(21), 
	STAGE_NO VARCHAR(3), 
	IS_DUMMY NUMERIC, 
	MULTIPLICITY NUMERIC, 
	STAGE_IMPULSE NUMERIC, 
	STAGE_APOGEE NUMERIC, 
	STAGE_PERIGEE NUMERIC, 
	 CONSTRAINT LAUNCH_VEHICLE_STAGE_PK PRIMARY KEY (LV_ID, STAGE_NAME, STAGE_NO)
  , 
	 CONSTRAINT LAUNCH_VEHICLE_STAGE_FK1 FOREIGN KEY (LV_ID)
	  REFERENCES LAUNCH_VEHICLE (LV_ID) , 
	 CONSTRAINT LAUNCH_VEHICLE_STAGE_FK2 FOREIGN KEY (STAGE_NAME)
	  REFERENCES STAGE (STAGE_NAME) 
 ) ;


CREATE INDEX LAUNCH_VEHICLE_STAGE_IDX1 ON LAUNCH_VEHICLE_STAGE (LV_ID) 
;

CREATE INDEX LAUNCH_VEHICLE_STAGE_IDX2 ON LAUNCH_VEHICLE_STAGE (STAGE_NAME) 
;
\copy LAUNCH_VEHICLE_STAGE from 'c:\space\LAUNCH_VEHICLE_STAGE.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- STAGE_MANUFACTURER
--------------------------------------------------------------------------------


CREATE TABLE STAGE_MANUFACTURER 
 (	STAGE_NAME VARCHAR(21), 
	MANUFACTURER_ORG_CODE VARCHAR(4000), 
	 CONSTRAINT STAGE_MANUFACTURER_PK PRIMARY KEY (STAGE_NAME, MANUFACTURER_ORG_CODE)
  , 
	 CONSTRAINT STAGE_MANUFACTURER_STAGE_FK FOREIGN KEY (STAGE_NAME)
	  REFERENCES STAGE (STAGE_NAME) , 
	 CONSTRAINT STAGE_MANUFACTURER_MANUF_FK FOREIGN KEY (MANUFACTURER_ORG_CODE)
	  REFERENCES ORGANIZATION (ORG_CODE) 
 ) ;


CREATE INDEX STAGE_MANUFACTURER_IDX1 ON STAGE_MANUFACTURER (MANUFACTURER_ORG_CODE) 
;
\copy STAGE_MANUFACTURER from 'c:\space\STAGE_MANUFACTURER.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- PROPELLENT
--------------------------------------------------------------------------------


CREATE TABLE PROPELLENT 
 (	PROPELLENT_ID NUMERIC, 
	PROPELLENT_NAME VARCHAR(4000), 
	 CONSTRAINT PROPELLENT_PK PRIMARY KEY (PROPELLENT_ID)
  , 
	 CONSTRAINT PROPELLENT_UQ UNIQUE (PROPELLENT_NAME)
  
 ) ;

\copy PROPELLENT from 'c:\space\PROPELLENT.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- ENGINE_PROPELLENT
--------------------------------------------------------------------------------


CREATE TABLE ENGINE_PROPELLENT 
 (	ENGINE_ID NUMERIC, 
	PROPELLENT_ID NUMERIC, 
	OXIDIZER_OR_FUEL VARCHAR(8), 
	 CONSTRAINT ENGINE_PROPELLENT_PK PRIMARY KEY (ENGINE_ID, PROPELLENT_ID, OXIDIZER_OR_FUEL)
  , 
	 CONSTRAINT ENGINE_PROPELLENT_ENGINE_FK FOREIGN KEY (ENGINE_ID)
	  REFERENCES ENGINE (ENGINE_ID) , 
	 CONSTRAINT ENGINE_PROPELLENT_PROP_FK FOREIGN KEY (PROPELLENT_ID)
	  REFERENCES PROPELLENT (PROPELLENT_ID) 
 ) ;


CREATE INDEX ENGINE_PROPELLENT_IDX1 ON ENGINE_PROPELLENT (PROPELLENT_ID) 
;
\copy ENGINE_PROPELLENT from 'c:\space\ENGINE_PROPELLENT.csv' delimiter ',' csv header;


--------------------------------------------------------------------------------
-- ENGINE_MANUFACTURER
--------------------------------------------------------------------------------


CREATE TABLE ENGINE_MANUFACTURER 
 (	ENGINE_ID NUMERIC, 
	MANUFACTURER_ORG_CODE VARCHAR(4000), 
	 CONSTRAINT ENGINE_MANUFACTURER_PK PRIMARY KEY (ENGINE_ID, MANUFACTURER_ORG_CODE)
  , 
	 CONSTRAINT ENGINE_MANUFACTURER_ENGINE_FK FOREIGN KEY (ENGINE_ID)
	  REFERENCES ENGINE (ENGINE_ID) , 
	 CONSTRAINT ENGINE_MANUFACTURER_MANUF_FK FOREIGN KEY (MANUFACTURER_ORG_CODE)
	  REFERENCES ORGANIZATION (ORG_CODE) 
 ) ;


CREATE INDEX ENGINE_MANUFACTURER_IDX1 ON ENGINE_MANUFACTURER (MANUFACTURER_ORG_CODE) 
;
\copy ENGINE_MANUFACTURER from 'c:\space\ENGINE_MANUFACTURER.csv' delimiter ',' csv header;



-- Print intro message.
\echo ------------------------------------------------------------------------
\echo Done.  The space database was successfully installed.
\echo ------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- DONE
--------------------------------------------------------------------------------
