
# Data Cleaning in SQL (Layoffs Dataset)

This project demonstrates fundamental SQL data cleaning techniques using a real-world layoffs dataset. The goal is to transform raw data into a clean, standardized dataset suitable for exploratory data analysis and visualization.

Throughout the project, SQL is used to identify and remove duplicate records, standardize inconsistent values, format data types, handle missing values, and remove unnecessary records and columns. This project is ideal for beginners who want to practice essential data cleaning skills.


## Objectives

1. #### Create a working copy of the Dataset 
- This done to preserve he original data by creating a staging table for cleaning

2. #### Identify and Remove Duplicate Records
- Identify duplicate rows using window functions.
- Delete duplicate records from the table while preserving unique observations

3. #### Standardize Dataset
- Clean inconsistent text values
- Remove unnecessary white space
- Standardize all text coulmns to keep the same format
- Convert dates into the proper SQL DATE format

4. #### Handle Missing Values
- Identify NULL and blank values.
- Populate missing values where possible using existing data.
- Remove records that contain insufficient information.

5. #### Prepare the Dataset for Analysis
- Remove temporary columns created during cleaning.
- Produce a final cleaned dataset ready for analysis.

## Project Structure

1. #### Database Preparation
The project begins by creating a staging table from the original layoffs dataset. This ensures that the raw data remains unchanged throughout the cleaning process.

#### Tasks Performed
    - Create a copy of the original table (layoffs_staging1)
    - Populate the staging table with raw data.
-

2. #### Removing Duplicate Records
Duplicate records were identified using the ROW_NUMBER() window function by partitioning across all relevant columns.

#### Steps
    - Assign row numbers to each record
    - Store the results in a second staging table (layoffs_staging2)
    - Delete rows where the assigned row number is greater than one
This approach ensures that only unique records remain in the dataset.

3. #### Standardizing Data
Several inconsistencies were identified and corrected to improve data quality.

#### Cleaning Process
    - Removed leading and trailing spaces from all text columns
    - Standardized cryptocurrency industry names to Crypto
    - Removed trailing periods from country names (e.g., "United States.")
    - Converted text dates into SQL DATE format using STR_TO_DATE()
    - Modified the date column to the DATE data type

These changes ensure consistency across the dataset.

4. #### Handling Missing Values
The dataset contained both blank strings and NULL values.

#### Steps Performed
    - Identified blank and NULL values
    - Converted blank strings into NULL values
    - Filled missing industry values by matching records with the same company
    - Removed records where both total_laid_off and percentage_laid_off were missing because they contained insufficient information
-

5. #### Final Cleanup
After cleaning was completed:

    - Removed the temporary row_num column used for duplicate detection
    - Verified the final cleaned dataset

The resulting table is ready for exploratory data analysis or visualization.
## Learning Outcomes
Through this project, I gained hands-on experience with:

- Creating staging tables for safe data cleaning
- Using window functions to detect duplicate records
- Cleaning inconsistent categorical values
- Converting text into proper date formats
- Handling NULL and blank values effectively
- Using self joins to populate missing information
- Preparing raw datasets for further analysis
## Conclusion
This project serves as an introduction to practical SQL data cleaning techniques used by data analysts. By following a structured cleaning workflow, the dataset was transformed from raw, inconsistent data into a reliable dataset suitable for analysis.
## Data Cleaning Workflow

1. Create a staging table
2. Copy the original dataset
3. Identify duplicate records
4. Remove duplicate rows
5. Standardize text values
6. Convert date formats
7. Handle missing values
8. Remove incomplete records
9. Drop temporary columns
10. Validate the cleaned dataset


## Tech Stack and SQL Techniques Used

**Server:** MySQL

This project demonstrates the use of several important SQL concepts, including:
- Common Table Expressions (CTEs)
- Window Functions (ROW_NUMBER())
- PARTITION BY
- TRIM()
- STR_TO_DATE()
- ALTER TABLE
- UPDATE
- DELETE
- Self Joins
- Handling NULL values
- Data standardization
## How to Use
1. Clone this repository.
2. Import the layoffs dataset into MySQL.
3. Run the SQL script in order.
4. Review each cleaning step to understand the transformations.
5. Use the cleaned dataset for exploratory data analysis or visualization projects.
## Author

- [@Raahat23]

