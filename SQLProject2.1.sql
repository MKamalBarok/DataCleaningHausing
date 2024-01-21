select*
from SQLTutorial..DataPerumahan

--melihat  date
select SaleDateConvert, CONVERT(Date, SaleDate)
from SQLTutorial..DataPerumahan

Update SQLTutorial..DataPerumahan
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE SQLTutorial..DataPerumahan
ADD SaleDateConvert Date;

update SQLTutorial..DataPerumahan
SET SaleDateConvert = CONVERT(Date, SaleDate)

-- melihat prperty Addres
-- ternyata ada yang null
select PropertyAddress
from SQLTutorial..DataPerumahan
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from SQLTutorial..DataPerumahan a
Join SQLTutorial..DataPerumahan b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from SQLTutorial..DataPerumahan a
Join SQLTutorial..DataPerumahan b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

--memisahkan Property addres
select PropertyAddress,
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1),
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))
from SQLTutorial..DataPerumahan

ALTER TABLE SQLTutorial..DataPerumahan
ADD Address nvarchar(250);

update  SQLTutorial..DataPerumahan
set Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE SQLTutorial..DataPerumahan
ADD PropertyCity nvarchar(250);

update  SQLTutorial..DataPerumahan
set PropertyCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))

--memisahkan owner addres
select OwnerAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),3) as OwnerAddress1,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) as OwnerCity2,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) as OwnerState3
from SQLTutorial..DataPerumahan

ALTER TABLE SQLTutorial..DataPerumahan
ADD OwnerAddress1 nvarchar(250);

update SQLTutorial..DataPerumahan
set OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE SQLTutorial..DataPerumahan
ADD OwnerCity2 nvarchar(250);

update SQLTutorial..DataPerumahan
set OwnerCity2 = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE SQLTutorial..DataPerumahan
ADD OwnerState3 nvarchar(250);

update SQLTutorial..DataPerumahan
set OwnerState3 = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--melihat data SoldAsVacant

select SoldAsVacant,
case
	when SoldAsVacant = 'N' then 'No'
	when SoldAsVacant = 'Y' then 'Yes'
	else SoldAsVacant
end
from SQLTutorial..DataPerumahan
group by SoldAsVacant

-- menghapus dubpicat
--menggunakan CTE

WITH RowNumCTe AS(
select*,
	ROW_NUMBER() over (Partition by 
	ParcelID,
	SaleDate,
	SalePrice,
	LegalReference order by UniqueID) row_num
from SQLTutorial..DataPerumahan
)
select*
from RowNumCTe
--where row_num > 1
order by SaleDate

--HAPUS COLOM
SELECT*
from SQLTutorial..DataPerumahan

ALTER TABLE SQLTutorial..DataPerumahan
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict

SELECT [UniqueID ],ParcelID, SalePrice,Address,PropertyCity,OwnerName,OwnerAddress1,OwnerCity2,OwnerState3
from SQLTutorial..DataPerumahan
