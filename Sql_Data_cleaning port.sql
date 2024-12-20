/* 
cleaning data in sql queries
*/

select *
from PortfolioProject.dbo.Nashvillehousing

 ----------------------------------------------------------------------------------------------
--Standardize date format

select SaleDateConverted , convert(Date,SaleDate)
from PortfolioProject.dbo.Nashvillehousing

ALTER TABLE Nashvillehousing
add SaleDateConverted Date;

update Nashvillehousing
set SaleDateConverted = convert(Date,SaleDate)

---------------------------------------------------------------------------------------
--populate property address data

select *
from PortfolioProject.dbo.Nashvillehousing
where PropertyAddress is not null

select *
from PortfolioProject.dbo.Nashvillehousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.Nashvillehousing a
join PortfolioProject.dbo.Nashvillehousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 update a
 set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProject.dbo.Nashvillehousing a
join PortfolioProject.dbo.Nashvillehousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 --------------------------------------------------------------------------

 -- breaking out address into individual columns(address, city, state)

 select PropertyAddress
from PortfolioProject.dbo.Nashvillehousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
from PortfolioProject.dbo.Nashvillehousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.Nashvillehousing

ALTER TABLE Nashvillehousing
add PropertySplitAddress nvarchar(255);

update Nashvillehousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE Nashvillehousing
add PropertySplitCity nvarchar(255);

update Nashvillehousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select *
from PortfolioProject.dbo.Nashvillehousing

select OwnerAddress
from PortfolioProject.dbo.Nashvillehousing

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
 from PortfolioProject.dbo.Nashvillehousing

 ALTER TABLE Nashvillehousing
add OwnerSplitAddress nvarchar(255);

update Nashvillehousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Nashvillehousing
add OwnerSplitCity nvarchar(255);

update Nashvillehousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Nashvillehousing
add OwnerSplitState nvarchar(255);

update Nashvillehousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select *
from PortfolioProject.dbo.Nashvillehousing

-----------------------------------------------------------------------------------------------------
-- change Y and N to yes and no in "sold as vacant" field

select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.Nashvillehousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 ELSE SoldAsVacant
	 END
from PortfolioProject.dbo.Nashvillehousing

update Nashvillehousing
SET SoldAsVacant =  CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 ELSE SoldAsVacant
	 END

------------------------------------------------------------------------------

-- Remove duplicates

select *,
     ROW_NUMBER() OVER(
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				  UniqueID
				  )row_num
from PortfolioProject.dbo.Nashvillehousing
order by ParcelID

WITH RowNumCTE as(
select *,
     ROW_NUMBER() OVER(
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				  UniqueID
				  )row_num
from PortfolioProject.dbo.Nashvillehousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num >1
order by PropertyAddress

WITH RowNumCTE as(
select *,
     ROW_NUMBER() OVER(
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				  UniqueID
				  )row_num
from PortfolioProject.dbo.Nashvillehousing
--order by ParcelID
)
delete
from RowNumCTE
where row_num >1
--order by PropertyAddress

----------------------------------------------------------------------------------------------

-- delete unused columns

select *
from PortfolioProject.dbo.Nashvillehousing

ALTER TABLE PortfolioProject.dbo.Nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.Nashvillehousing
DROP COLUMN SaleDate






 
