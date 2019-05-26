use master;
go

drop database pedido_compra;
go

create database pedido_compra
go

use pedido_compra
go

create table cliente
(id_clie						int				not null		primary key  identity(1,1),
nm_clie							varchar(60)		not null,
doc_clie						varchar(15)		not null,
dtnas_clie						date			not null);
go

create table pagamento
(id_pgto						int				not null		primary key   identity(1,1),
dsc_pgto						varchar(30)		not null);
go

create table pedido
(id_ped							int				not null		primary key   identity(1,1),
pagamento						int				not null		constraint pagamento_id_pgto	references pagamento (id_pgto),
cliente							int				not null		constraint cliente_id_clie		references cliente (id_clie),
dt_ped							date			not null,
tot_ped							numeric(10,2)	not null);
go

create table produto
(id_prod						int				not null		primary key   identity(1,1),
dsc_prod						varchar(40)		not null,
vl_prod							numeric(9,2)	not null);
go

create table item_pedido
(pedido							int				not null		constraint pedido_id_ped	references pedido (id_ped),
produto							int				not null		constraint produto_id_prod	references produto (id_prod),
qtd_item_ped					numeric(7,2)	not null,
vl_item_ped						numeric(7,2)	not null);
go

insert into cliente(nm_clie,doc_clie,dtnas_clie)
values('José Bonifácio',123456789,'2001-01-20'),
	  ('José Augusto',987654321,'1980-05-02'),
	  ('José Aurelio',158893312,'1994-12-06'),
	  ('Moisés Messias',896611885,'1999-11-15'),
	  ('José Inacio',254557884,'2005-08-09');

insert into pagamento(dsc_pgto)
values	('cartão'),
		('dinheiro'),	
		('cheque');

insert into produto(dsc_prod,vl_prod)
values	('Bloco de concreto',450.00),
		('Pneu de caminhão',875.00),
		('Escapamento de caminhão',789.00),
		('Lona de caminhão',785.00),
		('Parafuso de pneu',1000.00),
		('Parabrisa',1200.00),
		('Porta caminhão', 258.00),
		('Retrovisor',1250.00),
		('Motor de caminhão',1.99),
		('Banco de caminhão',30.45);

insert into pedido(pagamento,cliente,dt_ped, tot_ped)
values	(1, 1, '2019-03-03', 12000.00),
		(2, 2, '2019-04-03', 11000.00),
		(3, 3, '2019-05-01', 22000.00),
		(3, 4, '2019-03-03', 13000.00),
		(2, 5, '2019-01-02', 11111.00),
		(1, 4, '2019-03-05', 8000.00),
		(2, 2, '2019-04-04', 600.00),
		(1, 1, '2019-04-13', 44.00);


insert into item_pedido(pedido, produto, qtd_item_ped, vl_item_ped)
values	(1,4,7,14888.00),
		(2,3,18,1222.00),
		(3,5,7,158.00),
		(4,9,7,14888.00),
		(6,10,18,1222.00);
		

/*c*/
select * 
from cliente 
order by nm_clie asc;

/*d*/
select * 
from pagamento 
order by id_pgto desc;

/*e*/
select * 
from pagamento 
where id_pgto = 2;

/*f*/
select * 
from cliente 
where nm_clie like 'M%';

/*g*/
select * 
from pagamento 
where dsc_pgto like '%e%';

/*h*/
select * 
from produto
where vl_prod > 10.00;

--i 
select * 
from pedido
where dt_ped between '2019-02-10' and '2019-05-10';

--j 
select * 
from cliente c 
inner join pedido p on c.id_clie = p.cliente
order by 
		p.id_ped,
		c.nm_clie;

--k
select p.id_ped 'Número', p.dt_ped 'Data do pedido', c.nm_clie 'Nome do cliente', p.pagamento 'Condição de pagamento', p.tot_ped 'Total do pedido' 
from cliente c 
inner join pedido p on c.id_clie = p.cliente
where c.id_clie = 2; 

--l 
select * from item_pedido  i 
inner join produto p on i.produto = p.id_prod
order by p.dsc_prod asc;

--m  
select MAX (tot_ped) 'Valor Máximo do Pedido'
from pedido;

--n
select MIN (tot_ped) 'Valor Minímo do Pedido'
from pedido;

--o
select AVG (tot_ped) 'Valor Médio dos Pedidos'
from pedido;

--p
select id_prod 'Id Produto',dsc_prod 'Descrição do Produto',vl_prod	'Valor do Produto' , id_clie 'Id Cliente'
from produto p join item_pedido i on p.id_prod = i.produto 
			   join pedido pe on i.pedido = pe.id_ped
			   join cliente c on c.id_clie = pe.cliente  
where id_clie = 4
order by id_prod;

--q
select p.dsc_pgto 'Forma de pagamento', c.nm_clie 'Cliente'
from pagamento p	join pedido pe on p.id_pgto = pe.pagamento
					join cliente c on pe.cliente = c.id_clie
where c.id_clie = 1;
--r
select pe.id_ped, pe.dt_ped, c.id_clie, c.nm_clie, pa.dsc_pgto, pr.dsc_prod, pr.vl_prod, pe.tot_ped, it.vl_item_ped
from pedido pe	join cliente c on pe.cliente = c.id_clie
				join pagamento pa on pa.id_pgto = pe.pagamento
				join item_pedido it on it.pedido = pe.id_ped
				join produto pr on pr.id_prod = it.produto
order by 
	c.nm_clie,
	pe.id_ped;

--s
select count(pe.id_ped) 'Total do cliente 3'
from pedido pe join cliente c on c.id_clie = pe.cliente
where c.id_clie = 3;

--t
select sum(vl_item_ped) 'Soma dos valores dos Produtos'
from item_pedido it join produto pr on it.produto = pr.id_prod

--u 
select count(id_clie) 'Quantidade Cliente'
from cliente;

--v
select *
from produto pr 
left join item_pedido it on it.produto = pr.id_prod
left join pedido pe on pe.id_ped = it.pedido;

--w 
select *
from cliente c 
left join pedido pe on pe.cliente = c.id_clie
left join item_pedido it on it.pedido = pe.id_ped;

--x

alter table item_pedido 
add vl_tot_item numeric(14,2);


update item_pedido
set vl_tot_item = (qtd_item_ped) * (vl_item_ped)



--y 
create view cliente_pedido
as select c.id_clie 'Id cliente', c.nm_clie 'Nome', pe.id_ped 'Id pedido', pe.dt_ped 'Data Pedido', pe.tot_ped 'Total pedido'
from cliente c
join pedido pe on c.id_clie = pe.cliente;

select * from cliente_pedido;
--z
use master;
go

drop database pedido_compra;
go
