SELECT *
FROM layoffs;

-- Creating a copy of the raw dataset
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

-- Populating the copied table with the data from the main table
INSERT layoffs_staging
SELECT *
FROM layoffs;


SELECT *
FROM layoffs_staging;


-- REMOVING DUPLICATES FROM THE DATASET
-- Let's start by assigning row numbers to each row of data to identify unique and duplicate rows
-- we will create the row numbers by partitioning by all the columns in the dataset

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


-- Create a duplicate table of layoff_staging with the row number as a column
 
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
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- DELETING THE DUPLICATES

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

SET SQL_SAFE_UPDATES = 1;


-- STANDARDIZING DATA -
-- It involves finding issues within your data and fixing it

-- let's start by ensuring all company, locations, industries, and country names are the same throughout our data (i.e. some are not
-- in their abbreviated forms, etc.)

SELECT company, TRIM(company)
FROM layoffs_staging2;

-- replace the data in the column with the trimmed data
UPDATE layoffs_staging2
SET company = TRIM(company);


-- checking the industry column on the table for issues and standardizing it
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;


-- crypto
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';


-- update the industry column for all crypto currencies to be crypto
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;


SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


-- FORMATTING DATE COLUMN
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


-- NEVER DO THIS ON YOUR ACTUAL RAW DATA TABLE, ALWAYS MAKE A COPY FIRST
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;


-- WORKING WITH NULL AND BLANK VALUES
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
	AND percentage_laid_off IS NULL;


-- Check the Industry column for NULL or blank cells
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
	OR industry = '';
    

-- When dealing with nul r blank cells, always try to populate them by checking the dataset for columns with same or similar information
-- as the row with the blanks. This can sometimes yield rows that do not contain blanks and the information missing may be found in there.
-- Example: In our dataset we have some rows of data with comapny name 'Airbnb' having NULL values in the industry column and other rows 
-- with same company name having no Null values in the industry column. This is helpful in populating the missing industry data

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Let's try to resolve the row with the missing value
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
	AND t2.industry IS NOT NULL;


-- changing all the blank cells to contain NULL values
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Populate the Null values with the actual industry value
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
	AND t2.industry IS NOT NULL;
    

-- REMOVING OR DELETING ROWS OF DATA WHERE THE total_laid_off AND percentage_laid_off IS NULL
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


-- REMOVING A COLUMN OR COLUMNS
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;