/*
dbo.usp_MakeFamilyPurchase.sql
*/

create or alter procedure dbo.usp_MakeFamilyPurchase (
	@FamilySurName varchar(255)
	)
as
if not exists (
	select 1
	from dbo.Family as f
	where f.SurName = @FamilySurName 
)
begin
	raiserror ('Семья отсутвует в списке!', 1, 1)
end
else
begin
	update f
	set f.BudgetValue = f.BudgetValue - e.Expenses
	from dbo.Family as f
		inner join (
			select 
				b.ID_Family,
				sum(b.Value) as Expenses
			from dbo.Basket as b
			group by b.ID_Family
		) as e on e.ID_Family = f.ID
	where f.SurName = @FamilySurName;
end;