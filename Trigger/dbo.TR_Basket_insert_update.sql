/*
dbo.TR_Basket_insert_update.sql
*/

-- Триггер, который рассчитывает скидку в случае покупки семьей одного товара больше два или более раз
create or alter trigger dbo.tr_Basket_insert on dbo.Basket
after insert
as
declare 
	@ID_Basket int = (select b.ID from dbo.Basket as b inner join inserted as i on b.ID = i.ID),
	@ID_Family int = (select b.ID_Family from dbo.Basket as b inner join inserted as i on b.ID = i.ID),
	@ID_SKU int = (select b.ID_SKU from dbo.Basket as b inner join inserted as i on b.ID = i.ID);

if 2 <= (
	select
		count (1)
	from dbo.Basket b
	where 
		b.ID_SKU = @ID_SKU and
		b.ID_Family = @ID_Family
	group by 
		b.ID_SKU,
		b.ID_Family)
begin
	update b
	set DiscountValue = b.Value * 0.05
	from dbo.Basket as b
	where b.ID = @ID_Basket;
end;

 
