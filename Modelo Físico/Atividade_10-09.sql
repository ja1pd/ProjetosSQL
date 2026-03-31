use classicmodels;

select * from payments;

select * from customers;

start transaction;

delete from payments;

update customers set city = 'Santa Luzia' where customernumber = 103;

rollback;

commit;