-- PurpleBoxDVD create Script
-- CS 3550
-- Luke Seeley

USE MASTER;
GO 
----- Drop PurpleBoxDVD database if it exists
IF EXISTS (SELECT * FROM sys.sysdatabases WHERE NAME = 'PurpleBoxDVD')
	DROP DATABASE PurpleBoxDVD;

----- Create PurpleBoxDVD database
CREATE DATABASE [PurpleBoxDVD]
ON PRIMARY
(NAME = N'PurpleBoxDVD', 
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\PurpleBoxDVD.mdf',
SIZE = 5MB,
FILEGROWTH = 1MB)
LOG ON 
(NAME = PurpleBoxDVD_Log,
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\PurpleBoxDVDLOG.ldf',
SIZE = 2MB,
FILEGROWTH = 1MB);

GO
----- Attach to the new PurpleBoxDVD database
USE PurpleBoxDVD;

---------- Create All Tables --------------------
CREATE TABLE PbUser 
(
	pbUser_id int IDENTITY(1,1) NOT NULL,
	userID NVarchar(9) NOT NULL,
	userFirstName NVarchar(25) NOT NULL,
	userLastName NVarchar(50) NOT NULL,
	userPassword NVarchar(255) NOT NULL,
	userPhoneNumber NVarchar(10) NOT NULL,
	userPhoneNumber2 NVarchar(10),
	userType NVarchar(1) NOT NULL,
	customerType NVarchar(1) NOT NULL,
	banStatus NVarchar(1) NOT NULL,
	fees money NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbQuestion
(
	pbQuestion_id int IDENTITY(1,1) NOT NULL,
	question NVarchar(255) NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbUserQuestion
(
	pbUser_id int NOT NULL,
	pbQuestion_id int NOT NULL,
	Answer NVarchar(255),
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbMovie
(
	pbMovie_id int IDENTITY(1,1) NOT NULL,
	movieID NVarchar(10) NOT NULL,
	Title Nvarchar(100) NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbMovieItem
(
	pbMovieItem_id int IDENTITY(1,1) NOT NULL,
	pbMovie_id int NOT NULL,
	copyNumber int NOT NULL,
	movieType NVarchar(1) NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbMovieRental
(
	pbUser_id int NOT NULL,
	pbMovieItem_id int NOT NULL,
	rentalDate dateTime NOT NULL,
	returnDate dateTime,
	dueDate dateTime NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbMovieReservation
(
	pbMovie_id int NOT NULL,
	pbUser_id int NOT NULL,
	reservationDate dateTime NOT NULL,
	movieType Nvarchar(1) NOT NULL,
	reservationStatus Nvarchar(1) NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbGenre
(
	pbGenre_id int IDENTITY(1,1) NOT NULL,
	genre NVarchar(25) NOT NULL,
	genreDescription NVarchar(255) NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbMovieGenre
(
	pbMovie_id int NOT NULL,
	pbGenre_id int NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbKeyword
(
	pbKeyword_id int IDENTITY(1,1) NOT NULL,
	keyword NVarchar(25) NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbMovieKeyword
(
	pbMovie_id int NOT NULL,
	pbKeyword_id int NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbDirector
(
	pbDirector_id int IDENTITY(1,1) NOT NULL,
	directorFirstName NVarchar(25) NOT NULL,
	directorLastName NVarchar(50) NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbMovieDirector
(
	pbMovie_id int NOT NULL,
	pbDirector_id int NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbActor
(
	pbActor_id int IDENTITY(1,1) NOT NULL,
	actorFirstName NVarchar(25) NOT NULL,
	actorLastName NVarchar(50) NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

CREATE TABLE PbMovieActor
(
	pbMovie_id int NOT NULL,
	pbActor_id int NOT NULL,
	lastUpdatedBy NVarchar(25) NOT NULL,
	lastUpdatedDate dateTime NOT NULL
);

--------- SET PK, FK, and AK -------------------
------ Create PK's

ALTER TABLE PbUser
	ADD CONSTRAINT PK_PbUser
	PRIMARY KEY CLUSTERED (pbUser_id);

ALTER TABLE PbQuestion
	ADD CONSTRAINT PK_PbQuestion
	PRIMARY KEY CLUSTERED (pbQuestion_id);

ALTER TABLE PbUserQuestion
	ADD CONSTRAINT PK_PbUserQuestion
	PRIMARY KEY CLUSTERED (pbUser_id, pbQuestion_id);

ALTER TABLE PbMovie
	ADD CONSTRAINT PK_PbMovie
	PRIMARY KEY CLUSTERED (pbMovie_id);

ALTER TABLE PbMovieItem
	ADD CONSTRAINT PK_MovieItem
	PRIMARY KEY CLUSTERED (pbMovieItem_id);

ALTER TABLE PbMovieRental
	ADD CONSTRAINT PK_MovieRental
	PRIMARY KEY CLUSTERED (pbUser_id, pbMovieItem_id, rentalDate);

ALTER TABLE PbMovieReservation
	ADD CONSTRAINT PK_MovieReservation
	PRIMARY KEY CLUSTERED (pbUser_id, pbMovie_id, reservationDate, movieType);

ALTER TABLE PbGenre
	ADD CONSTRAINT PK_Genre
	PRIMARY KEY CLUSTERED (pbGenre_id);

ALTER TABLE PbMovieGenre
	ADD CONSTRAINT PK_MovieGenre
	PRIMARY KEY CLUSTERED (pbGenre_id, pbMovie_id);

ALTER TABLE PbKeyword
	ADD CONSTRAINT PK_Keyword
	PRIMARY KEY CLUSTERED (pbKeyword_id);

ALTER TABLE PbMovieKeyword
	ADD CONSTRAINT PK_MovieKeyword
	PRIMARY KEY CLUSTERED (pbKeyword_id, pbMovie_id);

ALTER TABLE PbDirector
	ADD CONSTRAINT PK_Director
	PRIMARY KEY CLUSTERED (pbDirector_id);

ALTER TABLE PbMovieDirector
	ADD CONSTRAINT PK_MovieDirector
	PRIMARY KEY CLUSTERED (pbDirector_id, pbMovie_id);

ALTER TABLE PbActor
	ADD CONSTRAINT PK_Actor
	PRIMARY KEY CLUSTERED (pbActor_id);

ALTER TABLE PbMovieActor
	ADD CONSTRAINT PK_MovieActor
	PRIMARY KEY CLUSTERED (pbActor_id, pbMovie_id);

------ Create FK's
ALTER TABLE PbUserQuestion
	ADD CONSTRAINT FK_PbUserQuestion_pbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);

ALTER TABLE PbUserQuestion
	ADD CONSTRAINT FK_PbUserQuestion_pbQuestion_id
	FOREIGN KEY (pbQuestion_id) REFERENCES PbQuestion(pbQuestion_id);

ALTER TABLE PbMovieItem
	ADD CONSTRAINT FK_PbMovieItem_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieRental
	ADD CONSTRAINT FK_PbMovieRental_pbMovieItem_id
	FOREIGN KEY (pbMovieItem_id) REFERENCES PbMovieItem(pbMovieItem_id);

ALTER TABLE PbMovieRental
	ADD CONSTRAINT FK_PbMovieRental_pbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);

ALTER TABLE PbMovieReservation
	ADD CONSTRAINT FK_PbMovieReservation_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieReservation
	ADD CONSTRAINT FK_PbMovieReservation_pbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);

ALTER TABLE PbMovieGenre
	ADD CONSTRAINT FK_PbMovieGenre_pbGenre_id
	FOREIGN KEY (pbGenre_id) REFERENCES PbGenre(pbGenre_id);

ALTER TABLE PbMovieGenre
	ADD CONSTRAINT FK_PbMovieGenre_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieKeyword
	ADD CONSTRAINT FK_PbMovieKeyword_pbKeyword_id
	FOREIGN KEY (pbKeyword_id) REFERENCES PbKeyword(pbKeyword_id);

ALTER TABLE PbMovieKeyword
	ADD CONSTRAINT FK_PbMovieKeyword_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieDirector
	ADD CONSTRAINT FK_PbMovieDirector_pbDirector_id
	FOREIGN KEY (pbDirector_id) REFERENCES PbDirector(pbDirector_id);

ALTER TABLE PbMovieDirector
	ADD CONSTRAINT FK_PbMovieDirector_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieActor
	ADD CONSTRAINT FK_PbMovieActor_pbActor_id
	FOREIGN KEY (pbActor_id) REFERENCES PbActor(pbActor_id);

ALTER TABLE PbMovieActor
	ADD CONSTRAINT FK_PbMovieActor_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

------ Create AK's
ALTER TABLE PbUser
	ADD CONSTRAINT AK_PbUser_userID
	UNIQUE(userID);

ALTER TABLE PbQuestion
	ADD CONSTRAINT AK_PbQuestion_pbQuestion_id
	UNIQUE(pbQuestion_id);

ALTER TABLE PbMovieItem
	ADD CONSTRAINT AK_PbMovieItem_pbMovie_id
	UNIQUE(pbMovie_id);

ALTER TABLE PbMovieItem
	ADD CONSTRAINT AK_PbMovieItem_copyNumber
	UNIQUE(copyNumber);

ALTER TABLE PbMovieItem
	ADD CONSTRAINT AK_PbMovieItem_movieType
	UNIQUE(movieType);

ALTER TABLE PbMovie
	ADD CONSTRAINT AK_PbMovie_movieID
	UNIQUE(movieID);

ALTER TABLE PbGenre
	ADD CONSTRAINT AK_PbGenre_genre
	UNIQUE(genre);

ALTER TABLE PbKeyword
	ADD CONSTRAINT AK_PbKeyword_keyword
	UNIQUE(keyword);

ALTER TABLE PbDirector
	ADD CONSTRAINT AK_PbDirector_directorFirstName
	UNIQUE(directorFirstName);

ALTER TABLE PbDirector
	ADD CONSTRAINT AK_PbDirector_directorLastName
	UNIQUE(directorLastName);

ALTER TABLE PbActor
	ADD CONSTRAINT AK_PbActor_actorFirstName
	UNIQUE(actorFirstName);

ALTER TABLE PbActor
	ADD CONSTRAINT AK_PbActor_actorLastName
	UNIQUE(actorLastName);