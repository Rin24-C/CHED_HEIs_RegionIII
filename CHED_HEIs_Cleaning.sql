-- DATA CLEANING: CHED HEI LIST
SELECT * FROM heis_list;

SELECT
	*
FROM heis_list
WHERE PROVINCE = 'Nueva Ecija';

SELECT
	PROVINCE,
    `INSTITUTION TYPE`,
    COUNT(`INSTITUTION TYPE`) AS total_num
FROM heis_list
WHERE PROVINCE = 'Nueva Ecija'
GROUP BY PROVINCE,  `INSTITUTION TYPE`;

-- Create staging table and insert values
CREATE TABLE heis_stg
LIKE heis_list;

INSERT heis_stg
SELECT * 
FROM heis_list;

-- Check for duplicates
WITH duplicate_check AS (
	SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY `Region`, `INSTITUTION NAME`, `INSTITUTION TYPE`, 
	`PROVINCE`, `MUNICIPALITY/CITY`, `WEBSITE ADDRESS`, `FAX/TELEPHONE NO.`) AS row_num
FROM heis_stg)
SELECT *
FROM duplicate_check
WHERE row_num > 1;  -- There are no duplicated data.

-- Change column names for efficiency
ALTER TABLE heis_stg
RENAME COLUMN `REGION` TO region,
RENAME COLUMN `INSTITUTION NAME` TO inst_name,
RENAME COLUMN `INSTITUTION TYPE` TO inst_type,
RENAME COLUMN `PROVINCE` TO province, 
RENAME COLUMN `MUNICIPALITY/CITY` TO location,
RENAME COLUMN `WEBSITE ADDRESS` TO website,
RENAME COLUMN `FAX/TELEPHONE NO.` TO contact;

