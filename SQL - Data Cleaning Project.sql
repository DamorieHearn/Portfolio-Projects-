-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data 
-- 3. Null Values or Blank values 
-- 4. Remove Any Columns 

-- How to create a duplicate table of the raw data

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 1. How to Remove Duplicates

-- Identify duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- How to identify duplicates from a specific company in table
-- when you run this the row number won't appear because you didn't ask for it

SELECT *
FROM layoffs_staging
WHERE company = 'Casper'; 

-- 1.) How to remove duplicates from a table

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;


-- How to create a duplicate table to get the duplicate rows onto

CREATE TABLE `layoffs_staging2` (
	`company` text, 
    `location` text, 
    `industry` text, 
    `total_laid_off` int DEFAULT NULL, 
    `percentage_laid_off` text, 
    `date` text, 
    `stage` text, 
    `country` text, 
    `funds_raised_millions` int DEFAULT NULL,
    `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1; 

-- How to insert data from one table into the new table
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1; 

SELECT *
FROM layoffs_staging2; 

-- 2.) Standardizing Data

-- How to remove extra spaces  in a column using TRIM

SELECT company, TRIM(company)
FROM layoffs_staging2;

-- How to update a table once you standardize the data in it

UPDATE layoffs_staging2
SET company = TRIM(company);

-- run the update statement and then run the select statement again to check
-- if updates have been made to the column in the output


-- How to update a column so every row in it has the same data

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- run the select statement again to make sure all of the data 
-- in the column is now exactly the same

SELECT DISTINCT industry
FROM layoffs_staging2;

-- How to remove extra characters from a row/column 

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- How to update the table for time series data analyst later on using the date column
-- the date column being originally a text column isn't good if you want to time series stuff
-- How to turn a text column to a date column
-- First, make sure column is in the date format

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Second turn text column in date column

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3.) Null Values and Blank Values

-- How to turn data into NULL values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

-- How to change Blanks to Nulls

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

-- How to see if blank is populated

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Airbnb';

-- How to update the blank space with new data

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2;
    
-- How to remove columns and rows 

-- How to remove rows

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL; 

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL; 

SELECT *
FROM layoffs_staging2; 

-- no longer need row_num column
-- How to remove columns

ALTER TABLE layoffs_staging2
DROP COLUMN row_num; 



















