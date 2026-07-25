-- EXPLORATORY DATA ANALYSIS
-- We will try to answer some data questions regarding HEIs in Region III or Central Luzon in The Philippines. 

-- How many HEIs are in Central Luzon?
SELECT
	COUNT(inst_name) 
FROM heis_stg
WHERE region = '03 - Central Luzon'; -- There are 259 HEIs in CL


-- Categorize the total count of HEIs in CL based on their types
SELECT
	inst_type,
	COUNT(inst_name)  
FROM heis_stg
WHERE region = '03 - Central Luzon'
GROUP BY inst_type; -- No HEIs are under the "other" category. 

-- Categorize the total count of HEIs in CL based on province and location
	
    -- For province
SELECT
	province,
	COUNT(inst_name) AS Total_HEIs
FROM heis_stg
WHERE region = '03 - Central Luzon'
GROUP BY 
	province
ORDER BY Total_HEIs DESC; -- Bulacan has the highest and Aurora the lowest

	-- For location
SELECT
	province,
    location,
	COUNT(inst_name) AS Total_HEIs
FROM heis_stg
WHERE region = '03 - Central Luzon'
GROUP BY 
	province,
    location
ORDER BY Total_HEIs DESC; -- Cabanatuan City has the highest

-- Number of private schools in Nueva Ecija by location
SELECT
	location,
    COUNT(inst_type) AS Count_Priv
FROM heis_stg
WHERE province = 'Nueva Ecija'
AND inst_type = 'private'
GROUP BY location;

-- Number of HEIs in Nueva Ecija grouped by location and type.
SELECT
	location,
    inst_type,
    COUNT(inst_type) AS Count
FROM heis_stg
WHERE province = 'Nueva Ecija'
GROUP BY
	location, 
    inst_type
ORDER BY location, inst_type ASC; 

-- Number of HEIs grouped by location in Nueva Ecija
SELECT
	location,
    COUNT(inst_type) AS Count
FROM heis_stg
WHERE province = 'Nueva Ecija'
GROUP BY
	location
ORDER BY Count DESC; 

-- Number of HEIs for all locations in Central Luzon, divided by type.
SELECT
	province,
    location,
    inst_type,
	COUNT(inst_name) AS Count
FROM heis_stg
WHERE region = '03 - Central Luzon'
GROUP BY province, location, inst_type
ORDER BY province, location, inst_type DESC;

-- In Central Luzon, count the number of HEIs in cities and municipalities
SELECT
	COUNT(inst_name) AS Count
FROM heis_stg
WHERE location LIKE 'city of%' 
AND region = '03 - Central Luzon';-- 113 HEIs are in cities

SELECT
	COUNT(inst_name) AS Count
FROM heis_stg
WHERE location NOT LIKE 'city of%' 
AND region = '03 - Central Luzon';-- 146 HEIs are in municipalities

-- We can also utilize case statements for this.
SELECT 
    SUM(CASE WHEN location LIKE 'city of%' 
		AND region = '03 - Central Luzon' 
        THEN 1 ELSE 0 END) AS City,
    SUM(CASE WHEN location NOT LIKE 'city of%' 
		AND region = '03 - Central Luzon' 
        THEN 1 ELSE 0 END) AS Municipality
FROM heis_stg;

-- Create a new column for city/municipality distinction
ALTER TABLE heis_stg
ADD COLUMN designation VARCHAR(20);-- Creating a new column

UPDATE heis_stg
SET designation = CASE
	WHEN location LIKE 'city of%' THEN 'City'
    ELSE 'Municipality'
END;
