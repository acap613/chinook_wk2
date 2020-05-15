               --2.1 SELECT
select * from employee e ;

select * from employee e where e.lastname = 'King';

select * from employee e where e.firstname = 'Andrew' and reportsto isnull ;
--2.2 ORDER BY
select * from album order by title desc ;

select customer.firstname from customer order by city asc;
--2.3 INSERT
insert into genre (genreid, name) values (29, 'Black Metal'), (30, 'Acid Jazz');

insert into employee (employeeid, lastname, firstname, title, reportsto)
	values (11, 'Stewartson', 'Stewie', 'Cashier', 10), (12, 'Smith', 'Bob', 'Janitor', null);

insert into customer (customerid, firstname, lastname, email)
	values (62, 'Robby', 'Gould', 'rob@theproblem.com'), (63, 'Jerry', 'Mouse', 'jerry@mouse.com');
--2.4 UPDATE
update customer 
	set 
		firstname = 'Robert', lastname = 'Walter'
	where 
		firstname = 'Aaron' and lastname = 'Mitchell';
update artist 	
	set 
		name = 'CCR'
	where
		name = 'Creedence Clearwater Revival';
--2.5 LIKE
select * from invoice where billingaddress like 'T%';
--2.6 BETWEEN
select * from invoice where total between 15 and 20;
select * from employee where hiredate between '2003/01/06' and '2004/01/03';
--2.7 DELETE
delete from customer where firstname = 'Robert' and lastname = 'Walter';

--3.1 FUNCTIONS
create function get_time() returns time as $$
	begin
		return current_time; 
	end; $$
language plpgsql;	
select get_time();

create or replace function getLengthOfMediaType(a integer) 
returns integer as $$
		select length(name)
		from mediatype
		where mediatypeid = a;
$$ language sql;
select getLengthOfMediaType(1);

--3.2 AGG FUNCTIONS
create function avg_inv() returns numeric as $$
	select avg(invoice.total) from invoice;
$$ language sql;
select avg_inv();
 
create function max_price() returns numeric as $$
	select max(track.unitprice) from track;
$$ language sql;
select max_price();

--3.3 USER DEFINED SCALAR
select * from invoiceline;
create function avg_inv_price(
	@invoicelineid INT,
	@unitprice DEC(10,2)
) returns DEC(10,2) as
	begin
		return @quantity * @unitprice;
	end;
	

select avg_price();

--3.4 USER DEFINED TABLE VALUED FUNCTION

select * from employee where birthdate >= '1968-01-01 00:00:00';

--4.1 BASIC STORED
create or replace procedure first_and_last_name()
LANGUAGE plpgsql
		as $$
			begin
				perform firstname, lastname from customer ;
			end;
		$$;
call first_and_last_name();
--4.2 STORED PROCEDURE INPUT PARAMS
create or replace procedure update_info()
language plpgsql
as $$
begin
	update employee 
	set email = 'andy@anderson.com'
	where employeeid = 1;
end;
$$;
call update_info();

create or replace procedure emp_mgmt()
language plpgsql
as $$
begin
	select reportsto
	from employee
	where employeeid = 11;
end;
$$;
call emp_mgmt();

--4.3
create or replace procedure cust_name_comp()
language plpgsql
as $$
begin
	perform reportsto
	from employee
	where employeeid = 11;
end;
$$;
call cust_name_comp();

--5.0 TRANSACTIONS
create or replace function del_invoice(invoice_id int)
returns void as $$
begin 
	delete from invoiceline where invoiceid in ( select invoice.invoiceid from invoice);
	delete from invoice where invoiceid = invoice_id;
end; 
$$ language plpgsql;
alter table invoiceline 
add constraint fk_invoicelineinvoiceid
foreign key (invoiceid) references invoice (invoiceid ) on delete cascade on update cascade;

select del_invoice(9);

--6.0 TRIGGERS
create or replace function triggerTest() returns trigger as $$
	begin 	
		raise 'triggerTest';
	end;
$$ language plpgsql;

create trigger after_insert_emp after insert on employee for each row execute procedure triggerTest();

create trigger after_update_album after update on album for each row execute procedure triggerTest();

create trigger after_delete_cust after delete on customer for each row execute procedure triggerTest();

--7.1 INNER JOIN
select firstname, lastname, invoiceid, from customer c inner join invoice on c.customerid = invoice.customerid;

--7.2 OUTER JOIN
select customer.cutomerid, firstname, lastname, invoiceid, total from customer full outer join invoice on customer.customerid = invoice.customerid;

--7.3 RIGHT JOIN
select name, title, from album right join artist on album.artistid = artist.artistid;

--7.4 CROSS
select name as artist title as album from artist cross join album where artist.artistid = album.artistid order by artist.name asc;

--7.5 SELF 
select A.firstname as firstname, A.lastname as lastname, A.title, B.lastname as reportsto from employee A, employee B
where A.reportsto = B.employeeid;






--create or replace function insert_cust(cust_id int, first_name varchar, last_name, varchar)




	

		