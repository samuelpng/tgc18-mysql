# create parents table

create table parents (
    parent_id int unsigned auto_increment not null primary key,
    name varchar(100) not null,
    contact_no varchar(10) not null,
    occupation varchar(100)
) engine = innodb;

# create addresses table

create table addresses (
    address_id int unsigned auto_increment not null primary key,
    parent_id int unsigned not null,
    block_number varchar(100) not null,
    street_name varchar(100) not null,
    postal_code varchar(100) not null
) engine = innodb;

# alter parent_id to be a fk in addresses
alter table addresses add constraint fk_addresses_parents
    foreign key (parent_id) references parents(parent_id);

#create available_payment_types table
create table available_payment_types (
    payment_types_id int unsigned not null primary key,
    payment_type varchar(255),
    parent_id int unsigned not null
) engine = innodb;

#alter parent_id to be a fk in available_payment_types
alter table available_payment_types add constraint fk_available_payment_types_parents
    foreign key (parent_id) references parents(parent_id);

# create students table 
create table students (
    student_id int unsigned not null primary key,
    parent_id int unsigned not null,
    name varchar(100) not null,
    date_of_birth date not null
) engine = innodb;

#alter parent_id to be a fk in students
alter table students add constraint fk_students_parents
    foreign key (parent_id) references parents(parent_id);

