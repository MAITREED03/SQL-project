-- DATA CLEANING


-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens
SELECT * 
FROM layoffs;


-- now when we are data cleaning we usually follow a few steps
-- 1. remove duplicates
-- 2. standardize the data
-- 3. null values or blank values
-- 4. remove any columns


CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;


SELECT * , 
ROW_NUMBER() OVER(
PARTITION BY  company, industry , total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoffs_staging ;


WITH duplicate_cte AS 
(
SELECT * , 
ROW_NUMBER() OVER(
PARTITION BY  company, location, 
industry , total_laid_off, percentage_laid_off, 'date',stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1 ;

SELECT *
FROM layoffs_staging
WHERE company ='Casper' ;

CREATE TABLE `layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
`row_num` INT
);

SELECT *
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT * , 
ROW_NUMBER() OVER(
PARTITION BY  company, location, 
industry , total_laid_off, percentage_laid_off, 'date',stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE
FROM layoffs_staging2
WHERE row_num >= 2;

SELECT *
FROM layoffs_staging2;



-- standardizing data


SELECT company , TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET industry = 'crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging2;


SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


ALTER  TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;


-- 3. null values or blank values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry ='' ;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = "Bally's interactive";

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''
OR TRIM(industry) = '';

UPDATE layoffs_staging2
SET industry = 'Unknown'
WHERE industry IS NULL
OR industry = ''
OR TRIM(industry) = '';






SELECT t1.industry AS t1_industry, t2.industry AS t2_industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND (t2.industry IS NOT NULL AND t2.industry != '');

SELECT t1.industry AS t1_industry, t2.industry AS t2_industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND (t2.industry IS NULL OR t2.industry = '');






UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND (t2.industry IS NOT NULL AND t2.industry != '');


-- 4. remove any columns

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


