

select * 
from P1.dbo.HousingNashivile

-- Convert date time to only date, coz of its disturbing

alter table dbo.HousingNashivile
add SaleDateconverted date;

update HousingNashivile
set SaleDateconverted = convert(Date, SaleDate);

--update HousingNashivile
--set SaleDate = (convert(date, SaleDate))

select SaleDate, SaleDateconverted
from P1.dbo.HousingNashivile

--- Populate property adress
select a.ParcelID, a.PropertyAddress as PropertyAddress_a, 
b.ParcelID, b.PropertyAddress as PropertyAddress_b
from P1.dbo.HousingNashivile a
--where PropertyAddress is null
--order by ParcelID
join P1.dbo.HousingNashivile b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)   --or can said isnull(a.PropertyAddress, 'No Adress')
from P1.dbo.HousingNashivile a
--where PropertyAddress is null
--order by ParcelID
join P1.dbo.HousingNashivile b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null


--Spliting the columns data without specific deliminater or value
select * --PropertyAddress
from P1.dbo.HousingNashivile

select 
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as PropertyAddress1,    --substring tooks 3 segments column,starting, ending locations, -1 to avoid comma
substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as PropertyAddress2  ---- charindex tooks 2 segments starting and column
from P1.dbo.HousingNashivile

alter table P1.dbo.HousingNashivile
add PropertyAddress1 varchar(255)

update HousingNashivile
set PropertyAddress1 = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table HousingNashivile
add PropertyAddress2 varchar(255)

update  HousingNashivile
set PropertyAddress2 = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))
 


--Spliting the columns data with specific deliminater or value...for much better views

select OwnerAddress,

--PARSENAME(OwnerAddress, 1) --- same because parsename is only working with period not comma
PARSENAME(replace(OwnerAddress, ',', '.'), 3) as OwnerAddressSplit,  --- its working like backward so reverse the numbers
PARSENAME(replace(OwnerAddress, ',', '.'), 2) as OwnerCitySplit,
PARSENAME(replace(OwnerAddress, ',', '.'), 1) as OwnerStateSplit
from P1.dbo.HousingNashivile

alter table P1.dbo.HousingNashivile
add OwnerAddressSplit varchar(255)

update P1.dbo.HousingNashivile
set OwnerAddressSplit = PARSENAME(replace(OwnerAddress, ',', '.'), 3)

select * --PropertyAddress
from P1.dbo.HousingNashivile

drop table P1.dbo.HousingNashivile

alter table P1.dbo.HousingNashivile
add OwnerCitySplit varchar(255)

update P1.dbo.HousingNashivile
set OwnerCitySplit = PARSENAME(replace(OwnerAddress, ',', '.'), 2)

alter table P1.dbo.HousingNashivile
add OwnerStateSplit varchar(255)

update P1.dbo.HousingNashivile
set OwnerStateSplit = PARSENAME(replace(OwnerAddress, ',', '.'), 1)

/*
select * --PropertyAddress
from dbo.BackupHousingNashhiv

alter table P1.dbo.HousingNashivile
add OwnerAddressBckup varchar(255)

insert into P1.dbo.HousingNashivile(OwnerAddress)
select OwnerAddress
from dbo.BackupHousingNashhiv
*/


-- Cahnge  Y and N to Yes No for hthe 'Sold as vacant column"
select distinct (SoldAsVacant), count (SoldAsVacant)
from P1.dbo.HousingNashivile
group by SoldAsVacant --decs 
order by 2

select SoldAsVacant,
	case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		Else SoldAsVacant
		End
from P1.dbo.HousingNashivile

update P1.dbo.HousingNashivile
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		Else SoldAsVacant
		End

---Remove Duplicates

with RowNumCTE as (
select *, 
	ROW_NUMBER() over( partition by
							ParcelID,
							PropertyAddress,
							SalePrice,
							SaleDate,LegalReference
							order by UniqueID							
							) RowNumb
from P1.dbo.HousingNashivile
)
select *
from RowNumCTE
where RowNumb > 1
order by PropertyAddress

delete 
from RowNumCTE
where RowNumb > 1
--order by PropertyAddress

--select distinct (NewRowNumb)
--from P1.dbo.HousingNashivile
----order by

-- Delete unused columns
alter table P1.dbo.HousingNashivile
drop column OwnerAdress, TaxDistrict, PropertyAddress

alter table P1.dbo.HousingNashivile
drop column SaleDate


