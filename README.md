World Layoffs SQL Project




Overview




This project analyzes global layoff trends using SQL. It focuses on cleaning, aggregating, and transforming raw data from layoffs across industries and companies to derive insights.




Technologies



SQL (MySQL): For data manipulation and analysis.
GitHub: Version control and collaboration.




Database Schema



Column Name	Description
company	Company name
industry	Industry category
country	Country of layoffs
layoff_date	Date of layoffs
layoffs	Number of employees laid off




Installation and Setup


Clone the repository:

Set up the MySQL database:

Create a new database in MySQL.
Run the provided SQL scripts to set up the necessary tables and insert data.


Import the data into the layoffs_staging2 table.

Load the project scripts and run the necessary queries.



Key SQL Queries



1. Find all companies with missing or blank industry data:

2.  Update missing industry data using a JOIN:

3.   Find the total layoffs by industry:

   



