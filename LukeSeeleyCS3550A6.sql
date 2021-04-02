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
	ADD CONSTRAINT AK_PbMovieItem_pbMovieItemID
	UNIQUE(pbMovie_id, copyNumber, movieType);

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
	ADD CONSTRAINT AK_PbDirector_directorName
	UNIQUE(directorFirstName, directorLastName);

ALTER TABLE PbActor
	ADD CONSTRAINT AK_PbActor_actorName
	UNIQUE(actorFirstName, actorLastName);

---------- Check Constraints --------------------
ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_userID
	CHECK (userID LIKE 'PB[0-9][0-9][0-9][0-9][0-9][0-9][0-9]' );

ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_userPhoneNumber
	CHECK (userPhoneNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_UserType
	CHECK (userType = 'A' OR userType = 'N'); --A is for admin N is for non admin

ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_customerType
	CHECK (customerType = 'P' OR customerType = 'S'); --P is for premium S is for standard

ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_banStatus
	CHECK (banStatus = 'B' OR banStatus = 'N'); --Banned or Not banned

ALTER TABLE PbMovieRental
	ADD CONSTRAINT CK_PbMovieRental_dueDate
	CHECK (DATEDIFF(day, dueDate, rentalDate) = 3);

ALTER TABLE PbMovieItem
	ADD CONSTRAINT CK_PbMovieItem_movieType
	CHECK (movieType = 'D' OR movieType = 'B');

ALTER TABLE PbMovieReservation 
	ADD CONSTRAINT CK_PbMovieReservation_reservationStatus
	CHECK (reservationStatus = 'P' OR reservationStatus = 'C');

---------- Insert Into Tables --------------------
------ Insert Users
INSERT INTO PbUser 
(
	userID, userFirstName, userLastName, userPassword,
	userPhoneNumber, userPhoneNumber2,
	userType, customerType, banStatus,
	fees,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'PB0000001',
	'Drew',
	'Weidman',
	'SQLRules',
	'8016267025',
	NULL,
	'A',
	'P',
	'N',
	0.00,
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUser 
(
	userID, userFirstName, userLastName, userPassword,
	userPhoneNumber, userPhoneNumber2,
	userType, customerType, banStatus,
	fees,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'PB0000021',
	'Spencer',
	'Hilton',
	'CSRocks!',
	'8016266098',
	'8016265500',
	'N',
	'P',
	'N',
	0.00,
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUser 
(
	userID, userFirstName, userLastName, userPassword,
	userPhoneNumber, userPhoneNumber2,
	userType, customerType, banStatus,
	fees,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'PB0000027',
	'Josh',
	'Jensen',
	'AndroidIsKing',
	'8016266323',
	'8016266000',
	'N',
	'S',
	'N',
	0.00,
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUser 
(
	userID, userFirstName, userLastName, userPassword,
	userPhoneNumber, userPhoneNumber2,
	userType, customerType, banStatus,
	fees,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'PB0000101',
	'Waldo',
	'Wildcat',
	'GoWildcats!',
	'8016266001',
	'8016268080',
	'N',
	'S',
	'N',
	0.00,
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUser 
(
	userID, userFirstName, userLastName, userPassword,
	userPhoneNumber, userPhoneNumber2,
	userType, customerType, banStatus,
	fees,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'PB0000002',
	'Luke',
	'Seeley',
	'iPhoneisBetter',
	'8017917712',
	NULL,
	'A',
	'P',
	'N',
	0.00,
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUser 
(
	userID, userFirstName, userLastName, userPassword,
	userPhoneNumber, userPhoneNumber2,
	userType, customerType, banStatus,
	fees,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'PB0009001',
	'Meme',
	'Lord',
	'INeverGrowUp',
	'8016668181',
	'8018008153',
	'A',
	'S',
	'B',
	0.00,
	'LSeeley',
	GETDATE()
);

SELECT *
FROM PbUser;

------ Insert Questions
INSERT INTO PbQuestion
(
	question,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'What was the hometown of your Mother',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbQuestion
(
	question,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Who is your favorite Professor',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbQuestion
(
	question,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'What was the name of your first pet',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbQuestion
(
	question,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'What was the name of your first girlfriend/boyfriend',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbQuestion
(
	question,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'What city were you born in',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbQuestion
(
	question,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Who was your first kiss',
	'LSeeley',
	GETDATE()
);

SELECT *
FROM PbQuestion;

------ Insert UserQuestions

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0000001'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'What was the hometown of your Mother'),
	'Seattle',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0000001'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is your favorite Professor'),
	'Josh Jensen',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0000021'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'What was the name of your first pet'),
	'Buddy',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0000021'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'What was the name of your first girlfriend/boyfriend'),
	'Vivian',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0000027'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'What city were you born in'),
	'Las Vegas',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0000027'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who was your first kiss'),
	'Rachel',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0000101'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'What was the hometown of your Mother'),
	'Ogden',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0000101'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who was your first kiss'),
	'Thundercat',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0000002'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'What was the name of your first girlfriend/boyfriend'),
	'Kate',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0000002'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'What was the name of your first pet'),
	'Moxxie',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0009001'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'What was the name of your first pet'),
	'Genji',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbUserQuestion
(
	pbUser_id, pbQuestion_id,
	Answer,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbUser_id FROM PbUser
	WHERE userID = 'PB0009001'),
	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'What was the name of your first girlfriend/boyfriend'),
	'Rachel Amber',
	'LSeeley',
	GETDATE()
);

SELECT *
FROM PbUserQuestion;

------ Insert Movies
INSERT INTO PbMovie
(
	Title, movieID,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'True Grit',
	'TRGRT',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovie
(
	Title, movieID,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'The Sons of Katie Elder',
	'SonKElder',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovie
(
	Title, movieID,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'The Avengers',
	'Avngrs',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovie
(
	Title, movieID,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Greatest Showman',
	'GrtstShwmn',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovie
(
	Title, movieID,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'X-Men',
	'XMEN',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovie
(
	Title, movieID,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Incredibles 2',
	'Incrdbles2',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovie
(
	Title, movieID,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Deadpool',
	'Deadpl',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovie
(
	Title, movieID,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Star Wars: Episode IV – New Hope',
	'StrWrsIVNH',
	'LSeeley',
	GETDATE()
);

SELECT *
FROM PbMovie;

------ Insert MovieItems
INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'1',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'2',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'1',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'2',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'SonKElder'),
	'1',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'SonKElder'),
	'2',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'SonKElder'),
	'1',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'SonKElder'),
	'2',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'1',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'2',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'1',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'2',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'1',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'2',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'1',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'2',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'1',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'2',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'1',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'2',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'1',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'2',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'1',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'2',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'1',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'2',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'1',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'2',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'1',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'2',
	'D',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'1',
	'B',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber, movieType,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'2',
	'B',
	'LSeeley',
	GETDATE()
);




SELECT *
FROM PbMovieItem;

------ Insert Actors
INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Carrie',
	'Fisher',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Chris',
	'Evans',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Craig T',
	'Nelson',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Dean',
	'Martin',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Glen',
	'Campbell',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Holly',
	'Hunter',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Hugh',
	'Jackman',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'John',
	'Wayne',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Mark',
	'Hamill',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Michelle',
	'Williams',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Morena',
	'Baccarin',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Patrick',
	'Stewart',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Robert',
	'Downey Jr',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbActor
(
	actorFirstName, actorLastName,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Ryan',
	'Reynolds',
	'LSeeley',
	GETDATE()
);

SELECT *
FROM PbActor;

------ Insert MovieActors
INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'John'
	AND actorLastName = 'Wayne'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Glen'
	AND actorLastName = 'Campbell'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'John'
	AND actorLastName = 'Wayne'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'SonKElder'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Dean'
	AND actorLastName = 'Martin'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'SonKElder'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Robert'
	AND actorLastName = 'Downey Jr'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Chris'
	AND actorLastName = 'Evans'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Hugh'
	AND actorLastName = 'Jackman'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Michelle'
	AND actorLastName = 'Williams'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Patrick '
	AND actorLastName = 'Stewart'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Hugh '
	AND actorLastName = 'Jackman'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Craig T '
	AND actorLastName = 'Nelson'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Holly '
	AND actorLastName = 'Hunter'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Ryan '
	AND actorLastName = 'Reynolds'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Morena '
	AND actorLastName = 'Baccarin'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Mark '
	AND actorLastName = 'Hamill'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbActor_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Carrie '
	AND actorLastName = 'Fisher'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'LSeeley',
	GETDATE()
);

SELECT *
FROM PbMovieActor;

------ Insert Directors
INSERT INTO PbDirector
(
		directorFirstName, directorLastName,
		lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Brad',
	'Bird',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbDirector
(
		directorFirstName, directorLastName,
		lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Bryan',
	'Singer',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbDirector
(
		directorFirstName, directorLastName,
		lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'George',
	'Lucas',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbDirector
(
		directorFirstName, directorLastName,
		lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Henry',
	'Hathaway',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbDirector
(
		directorFirstName, directorLastName,
		lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Joss',
	'Whedon',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbDirector
(
		directorFirstName, directorLastName,
		lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Michael',
	'Gracey',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbDirector
(
		directorFirstName, directorLastName,
		lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Tim',
	'Miller',
	'LSeeley',
	GETDATE()
);

SELECT *
FROM PbDirector;


------ Insert Directors
INSERT INTO PbMovieDirector
(
	pbDirector_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Henry'
	AND directorLastName = 'Hathaway'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieDirector
(
	pbDirector_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Henry'
	AND directorLastName = 'Hathaway'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'SonKElder'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieDirector
(
	pbDirector_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Joss '
	AND directorLastName = 'Whedon'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieDirector
(
	pbDirector_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Michael '
	AND directorLastName = 'Gracey'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieDirector
(
	pbDirector_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Bryan '
	AND directorLastName = 'Singer'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieDirector
(
	pbDirector_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Brad '
	AND directorLastName = 'Bird'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieDirector
(
	pbDirector_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Tim '
	AND directorLastName = 'Miller'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieDirector
(
	pbDirector_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'George '
	AND directorLastName = 'Lucas'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'LSeeley',
	GETDATE()
);

SELECT *
FROM PbMovieDirector;

------ Insert Genres

INSERT INTO PbGenre
(
	genre, genreDescription,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Action',
	'Scenes of combat and usage of weapons',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbGenre
(
	genre, genreDescription,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Adventure',
	'Themes of exploration and discovery',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbGenre
(
	genre, genreDescription,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Animation',
	'Hand drawn or Computer generated images sequenced in an often exagerated visual style',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbGenre
(
	genre, genreDescription,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Biography',
	'Non-fiction piece based on the life of still living or diseased individual or group',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbGenre
(
	genre, genreDescription,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Comedy',
	'Themes of entertainment and jokes in satirical or slapstick styles',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbGenre
(
	genre, genreDescription,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Drama',
	'Themes of complex relationships and interactions between individuals and their personal lives',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbGenre
(
	genre, genreDescription,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Fantasy',
	'Fiction based on fantastical universes with magic and powerful creatures',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbGenre
(
	genre, genreDescription,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Musical',
	'A movie focused on the usage of lyrical presentation to advanced plot and other story elements',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbGenre
(
	genre, genreDescription,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Sci-Fi',
	'Fiction based on the future with elements of advanced technology, aliens, and often exploration of the universe',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbGenre
(
	genre, genreDescription,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Western',
	'Set in the "Western" era of US history, during the period of the westward expansion and gold rush',
	'LSeeley',
	GETDATE()
);

SELECT *
FROM PbGenre;

------ Insert MovieGenres

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Drama'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Western'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Western'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'SonKElder'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Action'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Sci-Fi'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Biography'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Drama'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Musical'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Action'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Sci-fi'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Action'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Animation'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Action'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Comedy'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Action'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbGenre_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Fantasy'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'LSeeley',
	GETDATE()
);


SELECT *
FROM PbMovieGenre;

------ Insert Keywords
INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Barnum',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Captain America',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Circus',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Darth Vader',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Dash',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Elastigirl',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Family',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Gun Fighter',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'healing power',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Iron Man',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Jack Jack',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Jedi Knight',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Mercenary',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Million Dreams',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Morbid',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Mutants',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Oscar Award Winner',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Rooster Cogburn',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Singing',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Thor',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'US Marshal',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Wolverine',
	'LSeeley',
	GETDATE()
);

INSERT INTO PbKeyword
(
	keyword,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	'Yoda',
	'LSeeley',
	GETDATE()
);

SELECT *
FROM PbKeyword;

------ Insert MovieKeywords
INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Rooster Cogburn'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'US Marshal'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Oscar Award Winner'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'TRGRT'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Gun Fighter'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'SonKElder'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Family'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'SonKElder'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Captain America'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Iron Man'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Thor'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Avngrs'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Circus'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Barnum'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Singing'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Million Dreams'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'GrtstShwmn'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Wolverine'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'LSeeley',
	GETDATE()
);


INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Mutants'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'XMEN'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Elastigirl'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Dash'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Jack Jack'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Incrdbles2'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Mercenary'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Morbid'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'healing power'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'Deadpl'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Jedi Knight'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Darth Vader'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'LSeeley',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id, pbMovie_id,
	lastUpdatedBy, lastUpdatedDate
)
VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE keyword = 'Yoda'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieID = 'StrWrsIVNH'),
	'LSeeley',
	GETDATE()
);

SELECT *
FROM PbMovieKeyword;