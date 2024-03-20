/*
CreateStructure.sql
*/
-- Проверка, существуе ли уже схема под которой я буду работать
if not exists (select 1 from sys.schemas as s where s.name = 'dbo')
begin
	exec ('create schema dbo');
end;

ALTER DATABASE <database_name> CHARACTER SET utf8 COLLATE utf8_general_ci;

alter database dbo character set utf8 collate utf8_general_ci;
-- Проверка на существование, а затем создание необходимой нам таблицы наименований продуктов
if object_id ('dbo.SKU') is null
begin
	create table dbo.SKU (
		ID int not null identity(1,1),
		Code varchar(64),
		Name varchar(256) not null,
		constraint PK_SKU primary key (ID),
		constraint UK_SKU_Code unique (Code)
	)
end;

-- Триггер, который будет генерировать код товара по правилу: s + ID товара
create or alter trigger dbo.tr_SKU_insert on dbo.SKU
after insert
as
begin
	declare @LastID varchar(64) = (select max (ID) from dbo.SKU);
	
	update dbo.SKU
	set Code = concat ('s', cast(@LastID as varchar))
	where ID = @LastID
end;

-- Проверка на существование, а затем создание таблицы семьи, которая совершает покупки
if object_id ('dbo.Family') is null
begin
	create table dbo.Family (
		ID int not null identity (1, 1),
		SurName varchar(64) not null,
		BudgetValue int,
		constraint PK_Family primary key (ID)
	)
end;

-- Проверка на существование, а затем создание таблицы, описывающую корзину с заказом
if object_id ('dbo.Basket') is null
begin
	create table dbo.Basket (
		ID int not null identity (1, 1),
		ID_SKU int not null,
		ID_Family int not null,
		Quantity int not null,
		Value int not null,
		PurchaseDate date not null constraint DF_Basket_PurchaseDate default getdate(),
		DiscountValue int,
		constraint PK_Basket primary key (ID),
		constraint FK_Basket_ID_SKU_SKU foreign key (ID_SKU) references dbo.SKU (ID),
		constraint FK_Basket_ID_Family_Family foreign key (ID_Family) references dbo.Family (ID),
		constraint CK_Basket_Quantity check (Quantity >= 0),
		constraint CK_Basket_Value check (Value >= 0)
	)
end;

-- Тестовые данные для таблицы dbo.SKU
insert into dbo.SKU (Name)
values ('Товар1');

insert into dbo.SKU (Name)
values ('Товар2');

insert into dbo.SKU (Name)
values ('Товар3');

-- Тестовые данные для таблицы dbo.Family
insert into dbo.Family (SurName, BudgetValue)
values ('Ивановы', 126430);

insert into dbo.Family (SurName, BudgetValue)
values ('Петровы', 301921);

insert into dbo.Family (SurName, BudgetValue)
values ('Гавриловы', 3129);

-- Тестовые данные для таблицы dbo.Basket
insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values (1, 1, 21, 210, 0);

insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values (1, 1, 10, 90, 4.5);

insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values (1, 1, 30, 600, 30);

insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values (1, 2, 5, 50, 0);

insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values (2, 2, 1, 100, 0);

insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values (3, 2, 10, 5000, 0);

insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values (1, 3, 50, 720, 0);

insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values (1, 3, 50, 720, 36);

insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values (2, 3, 1, 150, 0);

insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values (2, 3, 1, 150, 7.5);

insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values (3, 3, 6, 720, 0);

insert into dbo.Basket (ID_SKU, ID_Family, Quantity, Value)
values (3, 1, 1, 100);
