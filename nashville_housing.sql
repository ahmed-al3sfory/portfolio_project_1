--alook at the data
select * from nashville_housing
------------------------------------------------------------------------------------------------------
--change the date type
alter table nashville_housing  alter column SaleDate date
------------------------------------------------------------------------------------------------------
--populate property address
select* from nashville_housing where PropertyAddress in (select PropertyAddress
from nashville_housing
group by PropertyAddress
having COUNT (propertyaddress) >1 )
order by PropertyAddress

select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress
from nashville_housing a join nashville_housing b
on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where b.PropertyAddress is null

--fix property address 
update a set a.propertyaddress=ISNULL(a.propertyaddress,b.PropertyAddress)
from nashville_housing a join nashville_housing b
on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
--to check
select * from nashville_housing
where PropertyAddress is null

------------------------------------------------------------------------------------------------------
--breaking out address into(address,city)
select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(propertyaddress))
from nashville_housing

alter table nashville_housing
add  address nvarchar(255)
, city nvarchar(255)

update nashville_housing set address =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) ,
city=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(propertyaddress))

ALTER TABLE nashville_housing
DROP COLUMN PropertyAddress

select * from nashville_housing
------------------------------------------------------------------------------------------------------

--populate the owneraddress
select
parsename(replace (owneraddress,',','.'),1),
parsename(replace (owneraddress,',','.'),2),
parsename(replace (owneraddress,',','.'),3)
from nashville_housing

alter table nashville_housing
add  owner_state nvarchar(255)
, owner_city nvarchar(255)
,owner_street nvarchar(255)

update nashville_housing set owner_state =parsename(replace (owneraddress,',','.'),1)
 ,owner_city=parsename(replace (owneraddress,',','.'),2),
 owner_street=parsename(replace (owneraddress,',','.'),3)

 select * from nashville_housing

 ALTER TABLE nashville_housing
DROP COLUMN ownerAddress

------------------------------------------------------------------------------------------------------
--change Y and N into Yes and No in SoldAsVacant
select  distinct soldasvacant ,count(soldasvacant)
from nashville_housing
group by SoldAsVacant

select SoldAsVacant
,case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldAsVacant
end
from nashville_housing

update nashville_housing  set SoldAsVacant=
case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldAsVacant
end

------------------------------------------------------------------------------------------------------
