create database swimming_coach

use swimming_coach

# create parents table

create table parents (
    parent_id int unsigned auto_increment not null primary key,
    name varchar(100) not null,
    contact_no varchar(10) not null,
    occupation varchar(100)
) engine = innodb;

# insert into parents

insert into parents (name, contact_no, occupation)
    values ("Tan Ah Liang", "99999999", "Truck driver");

--- insert multiple parents 
insert into parents (name, contact_no, occupation) values
    ("Mary Sue", "11111111", "Doctor"),
    ("Tan Ah Kow", "22222222", "Programmer");


# create location table 
create table locations (
    location_id mediumint unsigned auto_increment primary key,
    name varchar(100) not null,
    address varchar (255) not null
) engine =  innodb;

# insert location 
insert into locations (name, address) 
    values ("Yishun Swimming Complex", "Yishun Ave 4");

# create addresses table (2 methods for table with foreign key)

 -- method 1
create table addresses (
    address_id int unsigned auto_increment not null primary key,
    parent_id int unsigned not null,
    block_number varchar(100) not null,
    street_name varchar(100) not null,
    postal_code varchar(100) not null
) engine = innodb;

-- add in fk relationship to parents table
# alter table <table name> add constraint
alter table addresses add constraint fk_addresses_parents
    foreign key (parent_id) references parents(parent_id)
-- addresses.parent_id will refer to parents.parent_id


#create available_payment_types table
create table available_payment_types (
    payment_types_id int unsigned not null primary key,
    payment_type varchar(255),
    parent_id int unsigned not null
) engine = innodb;

#alter parent_id to be a fk in available_payment_types
alter table available_payment_types add constraint fk_available_payment_types_parents
    foreign key (parent_id) references parents(parent_id);

-- method 2 create fk when creating table
# create students table 
create table students (
    student_id int unsigned auto_increment primary key,
    name varchar(100) not null,
    date_of_birth date not null,
    parent_id int unsigned not null,
    foreign key (parent_id) references parents(parent_id)
) engine = innodb;

# insert new students

insert into students (name, date_of_birth, parent_id)
    values ('Cindy Tan', '2020-06-11', 3);

# create sessions table
create table sessions (
    session_id int unsigned auto_increment primary key,
    datetime datetime not null,
    location_id mediumint unsigned not null,
    foreign key (location_id) references locations(location_id)
  )  engine = innodb;