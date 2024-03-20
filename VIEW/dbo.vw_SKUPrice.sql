/*
dbo.vw_SKUPrice.sql
*/

create or alter view dbo.vw_SKUPrice
as
select 
	s.*,
	dbo.udf_GetSKUPrice (s.ID) as PricePerOne
from dbo.SKU as s;
