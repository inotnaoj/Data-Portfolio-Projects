--In this project we will focus on data cleaning with SQL queries
--Skills used: CASTS, JOINS, ALTER TABLE, UPDATE, SUBSTRING, CHARINDEX(POSITION IN PGADMIN4), 
--Skills used: CTE, PARSNAME(SPLIT_PART IN PGADMIN4)
SELECT * FROM housingdf


-- Standarize Date Format
SELECT "SaleDate", CAST("SaleDate" AS date) AS ConvertedDate FROM housingdf

ALTER TABLE housingdf
ADD SaleDateConverted Date;

UPDATE housingdf
SET SaleDateConverted = CAST("SaleDate" AS date)

SELECT SaleDateConverted FROM housingdf

----------------------------------------------------------------------------
--Populate Property Address data (dealing with null values)
--SELECT * FROM housingdf
--WHERE "PropertyAddress" IS null
--ORDER BY "ParcelID" WE WILL USE ParcelID to fill PropertyAddress nulls

SELECT a."ParcelID", a."PropertyAddress", b."ParcelID", b."PropertyAddress", COALESCE(a."PropertyAddress", b."PropertyAddress")
FROM housingdf a
JOIN housingdf b
	ON a."ParcelID" = b."ParcelID"
	AND a."UniqueID " <> b."UniqueID "
WHERE a."PropertyAddress" IS null

UPDATE housingdf
SET "PropertyAddress" = COALESCE(housingdf."PropertyAddress", b."PropertyAddress")
FROM housingdf AS b
WHERE housingdf."ParcelID" = b."ParcelID"
	AND housingdf."UniqueID " <> b."UniqueID "
	AND housingdf."PropertyAddress" IS null;

SELECT * FROM housingdf
WHERE "PropertyAddress" IS null

----------------------------------------------------------------------------
-- Breaking out PropertyAddress into Individual Columns (Address, City, State)
SELECT "PropertyAddress"
FROM housingdf
--WHERE "PropertyAddress" IS null
--ORDER BY "ParcelID"

SELECT
SUBSTRING("PropertyAddress", 1, POSITION(',' IN "PropertyAddress")-1)  AS Address
, SUBSTRING("PropertyAddress", POSITION(',' IN "PropertyAddress") +1, LENGTH("PropertyAddress") - POSITION(',' IN "PropertyAddress")) AS City
FROM housingdf

ALTER TABLE housingdf
ADD PropertySplitAddress varchar(255);

UPDATE housingdf
SET PropertySplitAddress = SUBSTRING("PropertyAddress", 1, POSITION(',' IN "PropertyAddress")-1) 

ALTER TABLE housingdf
ADD PropertySplitCity varchar(255);

UPDATE housingdf
SET PropertySplitCity = SUBSTRING("PropertyAddress", POSITION(',' IN "PropertyAddress") +1, LENGTH("PropertyAddress") - POSITION(',' IN "PropertyAddress"))

SELECT * FROM housingdf

---Let's do the same with 'OwnerAddress'

SELECT 
	SPLIT_PART("OwnerAddress", ',', 1) AS Adress, 
	SPLIT_PART("OwnerAddress", ',', 2) AS City,
	SPLIT_PART("OwnerAddress", ',', 3) AS State
FROM housingdf

ALTER TABLE housingdf
ADD OwnerSplitAddress varchar(255);

UPDATE housingdf
SET OwnerSplitAddress = SPLIT_PART("OwnerAddress", ',', 1) 

ALTER TABLE housingdf
ADD OwnerSplitCity varchar(255);

UPDATE housingdf
SET OwnerSplitCity = SPLIT_PART("OwnerAddress", ',', 2) 

ALTER TABLE housingdf
ADD OwnerSplitState varchar(255);

UPDATE housingdf
SET OwnerSplitState = SPLIT_PART("OwnerAddress", ',', 3) 

----------------------------------------------------------------------------
-- Change Yes and No to Y and N in 'Sold as Vacant' field
SELECT 
	REPLACE(REPLACE("SoldAsVacant", 'Yes', 'Y'), 'No', 'N')
FROM housingdf

ALTER TABLE housingdf
ADD SoldAsVacantCodified varchar(255)

UPDATE housingdf
SET SoldAsVacantCodified = REPLACE(REPLACE("SoldAsVacant", 'Yes', 'Y'), 'No', 'N')

----------------------------------------------------------------------------
--Remove Duplicates
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY 
		"ParcelID",
		"PropertyAddress",
		"SalePrice",
		"SaleDate",
		"LegalReference"
ORDER BY "UniqueID "
) row_num
FROM housingdf
--ORDER BY "ParcelID"
)

DELETE
FROM RowNumCTE
WHERE row_num >1
--ORDER BY "PropertyAddress"

----------------------------------------------------------------------------
--Delete Unused Columns
ALTER TABLE housingdf
DROP COLUMN "PropertyAddress",
DROP COLUMN "OwnerAddress",
DROP COLUMN "SaleDate",
DROP COLUMN "ownerplitaddress",
DROP COLUMN "TaxDistrict";

SELECT * FROM housingdf
