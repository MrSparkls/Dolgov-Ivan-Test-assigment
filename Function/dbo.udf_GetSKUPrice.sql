/*
dbo.udf_GetSKUPrice.sql 
*/

create or alter function dbo.udf_GetSKUPrice (
	@ID_SKU int
)
returns decimal(18, 2)
as
begin
	declare @Price decimal(18, 2) = (
		select cast((sum(b.Value)/sum(b.Quantity)) as decimal(18, 2)) as Price
		from dbo.Basket as b
		where b.ID_SKU = @ID_SKU
		group by b.ID_SKU)
	
	return @Price;
end;
