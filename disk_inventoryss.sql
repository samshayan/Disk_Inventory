/********************************************************************
*	Date		Author		Note
*	10-3-2019	Sam Shayan	script for disk_inventory database
*********************************************************************/

use master;
Go

-- code that checks if a database exists and before it deletes it
if DB_ID('disk_inventoryss') IS NOT NULL
	drop database disk_inventoryss
Go

-- Creating a database name disk_inventoryss (with initials)
CREATE DATABASE disk_inventoryss
GO

--using the disk_inventoryss database
USE disk_inventoryss;
GO

-- Create Genre table
create table Genre (
-- identity for auto-increment 
	genre_id	int	not null	identity primary key,
	genre_desc	nvarchar(255)	not null
);

-- Create Status table
create table Status(
	status_id	int	not null identity primary key,
	status_desc	nvarchar(255) not null
);

-- Create DiskType table
create table DiskType(
	disk_type_id	int not null identity primary key,
	disk_type_desc	nvarchar(255) not null
);

-- Create ArtistType table
create table ArtistType(
	artist_type_id		int not null identity primary key,
	artist_type_desc	nvarchar(255) not null
);

-- Create Borrower table
create table Borrower(
	borrower_id				int not null identity primary key,
	borrower_first_name		nvarchar(100) not null,
	borrower_last_name		nvarchar(100) not null,
	borrower_phone			nvarchar(50)  not null,
);

-- Create Artist table
create table Artist(
	artist_id				int not null identity primary key,
	artist_first_name		nvarchar(100) not null,
	artist_last_name		nvarchar(100) null,
	--artist_type_id is foreign key
	artist_type_id int not null references ArtistType(artist_type_id)
);
-- Create Disk table
create table Disk(
	disk_id			 int not null identity primary key,
	disk_name		 nvarchar(100) not null,
	disk_release_date date not null,
	genre_id		 int not null references Genre(genre_id),
	status_id		 int not null references Status(status_id),
	disk_type_id	 int not null references DiskType(disk_type_id),

);
-- Create diskHasBorrower table
create table diskHasBorrower(
	borrower_id		 int not null references Borrower(borrower_id),
	disk_id			 int not null references Disk(disk_id),
	borrowed_date	 smalldatetime not null,
	borrower_return_date	 smalldatetime null,
	--setting the primary keys
	primary key (borrower_id, disk_id,borrowed_date)
);


-- Create diskHasArtist table
create table diskHasArtist(
--disk_id and artist_id are primary and foreign keys
	disk_id		int	not null references Disk(disk_id),
	artist_id	int not null references Artist(artist_id)

	--primary key (disk_id,artist_id)
);

--creating a unique key and an index based on primary keys,
create unique index PK_diskHasArtist on diskHasArtist(disk_id, artist_id);

--Create login for diskss
-- if the user diskss does not exists
if USER_ID('diskss') is null
	--new sql server login ID
	create login diskss with password = 'MSPress#1',
	-- setting the default database to disk_inventoryss
	default_database = disk_inventoryss;

	--drop login diskss;

--Create user for disk
if USER_ID('diskss') is null
-- creating a database user with same name as login ID
	create user diskss;

--Altering the role so the user only can select data from any table in the database
alter role db_datareader add member diskss;
go