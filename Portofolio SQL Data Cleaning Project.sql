/* Cleaning Data in SQL Queries */
 
CREATE DATABASE CleaningDataSQLPortofolioProject
 
/* Populate Property Adress data */
 
SELECT [PropertyAddress]
FROM [dbo].[Nashville Housing Data for Data Cleaning]
WHERE PropertyAddress IS NULL
 
 
SELECT a.parcelid,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [dbo].[Nashville Housing Data for Data Cleaning] a
JOIN
[dbo].[Nashville Housing Data for Data Cleaning] b
ON a.ParcelID=b.ParcelID AND a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress is null
 
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [dbo].[Nashville Housing Data for Data Cleaning] a
JOIN
[dbo].[Nashville Housing Data for Data Cleaning] b
ON a.ParcelID=b.ParcelID AND a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress is null
 
/* Breaking out Address Into Indivdual Columns (Address,City,State) */
 
SELECT PARSENAME(REPLACE([OwnerAddress],',','.'),3),
PARSENAME(REPLACE([OwnerAddress],',','.'),2),
PARSENAME(REPLACE([OwnerAddress],',','.'),1)
FROM [dbo].[Nashville Housing Data for Data Cleaning]
 
ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
ADD OwnerSplitAdress NVARCHAR(255)
 
UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitAdress= PARSENAME(REPLACE([OwnerAddress],',','.'),3)
 
ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
ADD OwnerSplitCity NVARCHAR(255)
 
UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitCity= PARSENAME(REPLACE([OwnerAddress],',','.'),2)
 
ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
ADD OwnerSplitState NVARCHAR(255)
 
UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitState= PARSENAME(REPLACE([OwnerAddress],',','.'),1)
 
/* Change Y and N to Yes and No in "Sold as vacant" field */
 
SELECT distinct([SoldAsVacant])
FROM [dbo].[Nashville Housing Data for Data Cleaning]
GROUP BY [SoldAsVacant]
order by 2
 
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
   WHEN SoldAsVacant = 'N' THEN 'No'
   ELSE SoldAsVacant
   END
FROM[dbo].[Nashville Housing Data for Data Cleaning]
 
UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
   WHEN SoldAsVacant = 'N' THEN 'No'
   ELSE SoldAsVacant
   END
 
/* Remove Duplicates  */
 
WITH RowNumCTE AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY ParcelID,PropertyAddress,[SalePrice],[SaleDate],[LegalReference] ORDER BY [UniqueID]) row_num
FROM [dbo].[Nashville Housing Data for Data Cleaning]
)
DELETE
FROM RowNumCTE
WHERE row_num>1
ORDER BY PropertyAddress
 
 
/* Delete Unused Columns  */
 
 
SELECT *
FROM [dbo].[Nashville Housing Data for Data Cleaning]
 
ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAdress, TaxDistrict, PropertyAdress 