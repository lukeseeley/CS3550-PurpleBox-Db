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

---------- Insert Stored Procedures --------------------
IF EXISTS (
	SELECT * FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addUser'
	)

	DROP PROCEDURE usp_addUser;

GO

CREATE PROCEDURE usp_addUser

@userID NVarchar(9),
@userFirstName NVarchar(25),
@userLastName NVarchar(50),
@userPassword NVarchar(255),
@userPhoneNumber NVarchar(10),
@userPhoneNumber2 NVarchar(10),
@userType NVarchar(1),
@customerType NVarchar(1)

AS
BEGIN

	BEGIN TRY
	INSERT INTO PbUser
		(userID, userFirstName, userLastName, userPassword,
		userPhoneNumber, userPhoneNumber2,
		userType, customerType, banStatus,
		fees,
		lastUpdatedBy, lastUpdatedDate)
	VALUES
		(@userID, @userFirstName, @userLastName, @userPassword,
		@userPhoneNumber, @userPhoneNumber2,
		@userType, @customerType, 'N', 0.00,
		'LSeeley', GETDATE());

	END TRY
	
	BEGIN CATCH PRINT('INSERT INTO User FAILED') END CATCH;
END

GO

IF EXISTS (
	SELECT * FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addQuestion'
	)

	DROP PROCEDURE usp_addQuestion;

GO

CREATE PROCEDURE usp_addQuestion

@question NVarchar(255)

AS
BEGIN
	BEGIN TRY
	INSERT INTO PbQuestion (question, lastUpdatedBy, lastUpdatedDate)
	VALUES (@question, 'LSeeley', GETDATE());
	END TRY

	BEGIN CATCH PRINT ('INSERT INTO Question FAILED') END CATCH
END

GO

IF EXISTS (
	SELECT * FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addUserQuestion'
	)

	DROP PROCEDURE usp_addUserQuestion;

GO

CREATE PROCEDURE usp_addUserQuestion

@userID NVarchar(9),
@question NVarchar(255),
@Answer NVarchar(255)

AS
BEGIN
	BEGIN TRY
	INSERT INTO PbUserQuestion (pbUser_id, pbQuestion_id, Answer, lastUpdatedBy, lastUpdatedDate)
	VALUES (
		(SELECT pbUser_id FROM PbUser
		WHERE userID = @userID),
		(SELECT pbQuestion_id FROM PbQuestion
		WHERE question = @question),
		@Answer, 'LSeeley', GETDATE()
	);
	END TRY

	BEGIN CATCH PRINT ('INSERT INTO UserQuestion FAILED') END CATCH
END

GO

IF EXISTS (
	SELECT * FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addMovie'
	)

	DROP PROCEDURE usp_addMovie;

GO

CREATE PROCEDURE usp_addMovie

@Title NVarchar(100),
@movieID NVarchar(10)


AS
BEGIN
	BEGIN TRY
	INSERT INTO PbMovie (Title, movieID, lastUpdatedBy, lastUpdatedDate)
	VALUES (@Title, @movieID, 'LSeeley', GETDATE())
	END TRY

	BEGIN CATCH PRINT('INSERT INTO Movie FAILED') END CATCH
END

GO

IF EXISTS (
	SELECT * FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addMovieItem'
	)

	DROP PROCEDURE usp_addMovieItem;

GO

CREATE PROCEDURE usp_addMovieItem

@movieID NVarchar(10), 
@copyNumber int,
@movieType NVarchar(1)

AS
BEGIN
	BEGIN TRY
	INSERT INTO	PbMovieItem (pbMovie_id, copyNumber, movieType, lastUpdatedBy, lastUpdatedDate)
	VALUES (
		(SELECT pbMovie_id FROM PbMovie
		WHERE movieID = @movieID),
		@copyNumber, @movieType, 'LSeeley', GETDATE()
	);
	END TRY

	BEGIN CATCH PRINT ('INSERT INTO MovieItem FAILED') END CATCH
END

GO

IF EXISTS (
	SELECT * FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addActor'
	)

	DROP PROCEDURE usp_addActor;

GO

CREATE PROCEDURE usp_addActor

@actorFirstName NVarchar(25),
@actorLastName NVarchar(50)

AS
BEGIN
	BEGIN TRY
	INSERT INTO PbActor (actorFirstName, actorLastName, lastUpdatedBy, lastUpdatedDate)
	VALUES (@actorFirstName, @actorLastName, 'LSeeley', GETDATE());
	END TRY

	BEGIN CATCH PRINT('INSERT INTO Actor FAILED') END CATCH
END

GO

IF EXISTS (
	SELECT * FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addMovieActor'
	)

	DROP PROCEDURE usp_addMovieActor;

GO

CREATE PROCEDURE usp_addMovieActor

@actorFirstName NVarchar(25),
@actorLastName NVarchar(50),
@movieID NVarchar(10)

AS
BEGIN
	BEGIN TRY
	INSERT INTO PbMovieActor (pbActor_id, pbMovie_id, lastUpdatedBy, lastUpdatedDate)
	VALUES (
		(SELECT pbActor_id FROM PbActor
		WHERE actorFirstName = @actorFirstName
		AND actorLastName = @actorLastName),
		(SELECT pbMovie_id FROM PbMovie
		WHERE movieID = @movieID),
		'LSeeley',	GETDATE()
	);
	END TRY

	BEGIN CATCH PRINT('INSERT INTO MovieActor FAILED') END CATCH
END

GO

IF EXISTS (
	SELECT * FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addDirector'
	)

	DROP PROCEDURE usp_addDirector;

GO

CREATE PROCEDURE usp_addDirector

@directorFirstName NVarchar(25),
@directorLastName NVarchar(50)

AS
BEGIN
	BEGIN TRY
	INSERT INTO PbDirector (directorFirstName, directorLastName, lastUpdatedBy, lastUpdatedDate)
	VALUES (@directorFirstName, @directorLastName, 'LSeeley', GETDATE());
	END TRY

	BEGIN CATCH PRINT('INSERT INTO Director FAILED') END CATCH
END

GO

IF EXISTS (
	SELECT * FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addMovieDirector'
	)

	DROP PROCEDURE usp_addMovieDirector;

GO

CREATE PROCEDURE usp_addMovieDirector

@directorFirstName NVarchar(25),
@directorLastName NVarchar(50),
@movieID NVarchar(10)

AS
BEGIN
	BEGIN TRY
	INSERT INTO PbMovieDirector (pbDirector_id, pbMovie_id, lastUpdatedBy, lastUpdatedDate)
	VALUES (
		(SELECT pbDirector_id FROM PbDirector
		WHERE directorFirstName = @directorFirstName
		AND directorLastName = @directorLastName),
		(SELECT pbMovie_id FROM PbMovie
		WHERE movieID = @movieID),
		'LSeeley',	GETDATE()
	);
	END TRY

	BEGIN CATCH PRINT('INSERT INTO MovieDirector FAILED') END CATCH
END

GO

IF EXISTS (
	SELECT * FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addGenre'
	)

	DROP PROCEDURE usp_addGenre;

GO

CREATE PROCEDURE usp_addGenre

@genre NVarchar(25),
@genreDescription NVarchar(255)

AS
BEGIN
	BEGIN TRY
	INSERT INTO PbGenre (genre, genreDescription, lastUpdatedBy, lastUpdatedDate)
	VALUES (@genre, @genreDescription, 'LSeeley',	GETDATE());
	END TRY

	BEGIN CATCH PRINT('INSERT INTO Genre FAILED') END CATCH
END

GO

CREATE PROCEDURE usp_addMovieGenre

@genre NVarchar(25),
@movieID NVarchar(10)

AS
BEGIN
	BEGIN TRY
	INSERT INTO PbMovieGenre (pbGenre_id, pbMovie_id, lastUpdatedBy, lastUpdatedDate)
	VALUES (
		(SELECT pbGenre_id FROM PbGenre
		WHERE genre = @genre), 
		(SELECT pbMovie_id FROM PbMovie
		WHERE movieID = @movieID),
		'LSeeley', GETDATE()
	);
	END TRY

	BEGIN CATCH PRINT('INSERT INTO MovieGenre FAILED') END CATCH
END

GO

IF EXISTS (
	SELECT * FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addKeyword'
	)

	DROP PROCEDURE usp_addKeyword;

GO

CREATE PROCEDURE usp_addKeyword

@keyword NVarchar(255)

AS
BEGIN
	BEGIN TRY
	INSERT INTO PbKeyword (keyword, lastUpdatedBy, lastUpdatedDate)
	VALUES (@keyword, 'LSeeley', GETDATE());
	END TRY

	BEGIN CATCH PRINT('INSERT INTO Keyword FAILED') END CATCH
END

GO

CREATE PROCEDURE usp_addMovieKeyword

@keyword NVarchar(25),
@movieID NVarchar(10)

AS
BEGIN
	BEGIN TRY
	INSERT INTO PbMovieKeyword (pbKeyword_id, pbMovie_id, lastUpdatedBy, lastUpdatedDate)
	VALUES (
		(SELECT pbKeyword_id FROM PbKeyword
		WHERE keyword = @keyword), 
		(SELECT pbMovie_id FROM PbMovie
		WHERE movieID = @movieID),
		'LSeeley', GETDATE()
	);
	END TRY

	BEGIN CATCH PRINT('INSERT INTO MovieKeyword FAILED') END CATCH
END

GO

---------- Insert Into Tables --------------------
------ Insert Users
EXECUTE usp_addUser @userID = 'PB0000001', @userFirstName = 'Drew', @userLastName = 'Weidman', @userPassword = 'SQLRules', 
@userPhoneNumber = '8016267025', @userPhoneNumber2 = NULL, @userType = 'A', @customerType = 'P';
EXECUTE usp_addUser @userID = 'PB0000021', @userFirstName = 'Spencer', @userLastName = 'Hilton', @userPassword = 'CSRocks!', 
@userPhoneNumber = '8016266098', @userPhoneNumber2 = '8016265500', @userType = 'N', @customerType = 'P';
EXECUTE usp_addUser @userID = 'PB0000027', @userFirstName = 'Josh', @userLastName = 'Jensen', @userPassword = 'AndroidIsKing', 
@userPhoneNumber = '8016266323', @userPhoneNumber2 = '8016266000', @userType = 'N', @customerType = 'S';
EXECUTE usp_addUser @userID = 'PB0000101', @userFirstName = 'Waldo', @userLastName = 'Wildcat', @userPassword = 'GoWildcats!', 
@userPhoneNumber = '8016266001', @userPhoneNumber2 = '8016268080', @userType = 'N', @customerType = 'S';
EXECUTE usp_addUser @userID = 'PB0000002', @userFirstName = 'Luke', @userLastName = 'Seeley', @userPassword = 'iPhoneisBetter', 
@userPhoneNumber = '8017917712', @userPhoneNumber2 = NULL, @userType = 'A', @customerType = 'P';
EXECUTE usp_addUser @userID = 'PB0009001', @userFirstName = 'Meme', @userLastName = 'Lord', @userPassword = 'INeverGrowUp', 
@userPhoneNumber = '8016668181', @userPhoneNumber2 = '8018008153', @userType = 'A', @customerType = 'S';

SELECT *
FROM PbUser;

------ Insert Questions
EXECUTE usp_addQuestion @question = 'What was the hometown of your Mother';
EXECUTE usp_addQuestion @question = 'Who is your favorite Professor';
EXECUTE usp_addQuestion @question = 'What was the name of your first pet';
EXECUTE usp_addQuestion @question = 'What was the name of your first girlfriend/boyfriend';
EXECUTE usp_addQuestion @question = 'What city were you born in';
EXECUTE usp_addQuestion @question = 'Who was your first kiss';

SELECT *
FROM PbQuestion;

------ Insert UserQuestions
EXECUTE usp_addUserQuestion @userID = 'PB0000001', @question = 'What was the hometown of your Mother', @Answer = 'Seattle';
EXECUTE usp_addUserQuestion @userID = 'PB0000001', @question = 'Who is your favorite Professor', @Answer = 'Josh Jensen';
EXECUTE usp_addUserQuestion @userID = 'PB0000021', @question = 'What was the name of your first pet', @Answer = 'Buddy';
EXECUTE usp_addUserQuestion @userID = 'PB0000021', @question = 'What was the name of your first girlfriend/boyfriend', @Answer = 'Vivian';
EXECUTE usp_addUserQuestion @userID = 'PB0000027', @question = 'What city were you born in', @Answer = 'Las Vegas';
EXECUTE usp_addUserQuestion @userID = 'PB0000027', @question = 'Who was your first kiss', @Answer = 'Rachel';
EXECUTE usp_addUserQuestion @userID = 'PB0000101', @question = 'What was the hometown of your Mother', @Answer = 'Ogden';
EXECUTE usp_addUserQuestion @userID = 'PB0000101', @question = 'Who was your first kiss', @Answer = 'Thundercat';
EXECUTE usp_addUserQuestion @userID = 'PB0000002', @question = 'What was the name of your first girlfriend/boyfriend', @Answer = 'Kate';
EXECUTE usp_addUserQuestion @userID = 'PB0000002', @question = 'What was the name of your first pet', @Answer = 'Moxxie';
EXECUTE usp_addUserQuestion @userID = 'PB0009001', @question = 'What was the name of your first pet', @Answer = 'Genji';
EXECUTE usp_addUserQuestion @userID = 'PB0009001', @question = 'What was the name of your first girlfriend/boyfriend', @Answer = 'Rachel Amber';

SELECT *
FROM PbUserQuestion;

------ Insert Movies
EXECUTE usp_addMovie @Title = 'True Grit', @movieID = 'TRGRT';
EXECUTE usp_addMovie @Title = 'The Sons of Katie Elder', @movieID = 'SonKElder';
EXECUTE usp_addMovie @Title = 'The Avengers', @movieID = 'Avngrs';
EXECUTE usp_addMovie @Title = 'Greatest Showman', @movieID = 'GrtstShwmn';
EXECUTE usp_addMovie @Title = 'X-Men', @movieID = 'XMEN';
EXECUTE usp_addMovie @Title = 'Incredibles 2', @movieID = 'Incrdbles2';
EXECUTE usp_addMovie @Title = 'Deadpool', @movieID = 'Deadpl';
EXECUTE usp_addMovie @Title = 'Star Wars: Episode IV – New Hope', @movieID = 'StrWrsIVNH';

SELECT *
FROM PbMovie;

------ Insert MovieItems
EXECUTE usp_addMovieItem @movieID = 'TRGRT', @copyNumber = '1', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'TRGRT', @copyNumber = '1', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'TRGRT', @copyNumber = '2', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'TRGRT', @copyNumber = '2', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'SonKElder', @copyNumber = '1', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'SonKElder', @copyNumber = '1', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'SonKElder', @copyNumber = '2', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'SonKElder', @copyNumber = '2', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'Avngrs', @copyNumber = '1', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'Avngrs', @copyNumber = '1', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'Avngrs', @copyNumber = '2', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'Avngrs', @copyNumber = '2', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'GrtstShwmn', @copyNumber = '1', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'GrtstShwmn', @copyNumber = '1', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'GrtstShwmn', @copyNumber = '2', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'GrtstShwmn', @copyNumber = '2', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'XMEN', @copyNumber = '1', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'XMEN', @copyNumber = '1', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'XMEN', @copyNumber = '2', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'XMEN', @copyNumber = '2', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'Incrdbles2', @copyNumber = '1', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'Incrdbles2', @copyNumber = '1', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'Incrdbles2', @copyNumber = '2', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'Incrdbles2', @copyNumber = '2', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'Deadpl', @copyNumber = '1', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'Deadpl', @copyNumber = '1', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'Deadpl', @copyNumber = '2', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'Deadpl', @copyNumber = '2', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'StrWrsIVNH', @copyNumber = '1', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'StrWrsIVNH', @copyNumber = '1', @movieType = 'B';
EXECUTE usp_addMovieItem @movieID = 'StrWrsIVNH', @copyNumber = '2', @movieType = 'D';
EXECUTE usp_addMovieItem @movieID = 'StrWrsIVNH', @copyNumber = '2', @movieType = 'B';

SELECT *
FROM PbMovieItem;

------ Insert Actors
EXECUTE usp_addActor @actorFirstName = 'Carrie', @actorLastName = 'Fisher';
EXECUTE usp_addActor @actorFirstName = 'Chris', @actorLastName = 'Evans';
EXECUTE usp_addActor @actorFirstName = 'Craig T', @actorLastName = 'Nelson';
EXECUTE usp_addActor @actorFirstName = 'Dean', @actorLastName = 'Martin';
EXECUTE usp_addActor @actorFirstName = 'Glen', @actorLastName = 'Campbell';
EXECUTE usp_addActor @actorFirstName = 'Holly', @actorLastName = 'Hunter';
EXECUTE usp_addActor @actorFirstName = 'Hugh', @actorLastName = 'Jackman';
EXECUTE usp_addActor @actorFirstName = 'John', @actorLastName = 'Wayne';
EXECUTE usp_addActor @actorFirstName = 'Mark', @actorLastName = 'Hamill';
EXECUTE usp_addActor @actorFirstName = 'Michelle', @actorLastName = 'Williams';
EXECUTE usp_addActor @actorFirstName = 'Morena', @actorLastName = 'Baccarin';
EXECUTE usp_addActor @actorFirstName = 'Patrick', @actorLastName = 'Stewart';
EXECUTE usp_addActor @actorFirstName = 'Robert', @actorLastName = 'Downey Jr';
EXECUTE usp_addActor @actorFirstName = 'Ryan', @actorLastName = 'Reynolds';

SELECT *
FROM PbActor;

------ Insert MovieActors
EXECUTE usp_addMovieActor @actorFirstName = 'John', @actorLastName = 'Wayne', @movieID = 'TRGRT';
EXECUTE usp_addMovieActor @actorFirstName = 'Glen', @actorLastName = 'Campbell', @movieID = 'TRGRT';
EXECUTE usp_addMovieActor @actorFirstName = 'John', @actorLastName = 'Wayne', @movieID = 'SonKElder';
EXECUTE usp_addMovieActor @actorFirstName = 'Dean', @actorLastName = 'Martin', @movieID = 'SonKElder';
EXECUTE usp_addMovieActor @actorFirstName = 'Robert', @actorLastName = 'Downey Jr', @movieID = 'Avngrs';
EXECUTE usp_addMovieActor @actorFirstName = 'Chris', @actorLastName = 'Evans', @movieID = 'Avngrs';
EXECUTE usp_addMovieActor @actorFirstName = 'Hugh', @actorLastName = 'Jackman', @movieID = 'GrtstShwmn';
EXECUTE usp_addMovieActor @actorFirstName = 'Michelle', @actorLastName = 'Williams', @movieID = 'GrtstShwmn';
EXECUTE usp_addMovieActor @actorFirstName = 'Patrick', @actorLastName = 'Stewart', @movieID = 'XMEN';
EXECUTE usp_addMovieActor @actorFirstName = 'Hugh', @actorLastName = 'Jackman', @movieID = 'XMEN';
EXECUTE usp_addMovieActor @actorFirstName = 'Craig T', @actorLastName = 'Nelson', @movieID = 'Incrdbles2';
EXECUTE usp_addMovieActor @actorFirstName = 'Holly', @actorLastName = 'Hunter', @movieID = 'Incrdbles2';
EXECUTE usp_addMovieActor @actorFirstName = 'Ryan', @actorLastName = 'Reynolds', @movieID = 'Deadpl';
EXECUTE usp_addMovieActor @actorFirstName = 'Morena', @actorLastName = 'Baccarin', @movieID = 'Deadpl';
EXECUTE usp_addMovieActor @actorFirstName = 'Mark', @actorLastName = 'Hamill', @movieID = 'StrWrsIVNH';
EXECUTE usp_addMovieActor @actorFirstName = 'Carrie', @actorLastName = 'Fisher', @movieID = 'StrWrsIVNH';

SELECT *
FROM PbMovieActor;

------ Insert Directors
EXECUTE usp_addDirector @directorFirstName = 'Brad', @directorLastName = 'Bird';
EXECUTE usp_addDirector @directorFirstName = 'Bryan', @directorLastName = 'Singer';
EXECUTE usp_addDirector @directorFirstName = 'George', @directorLastName = 'Lucas';
EXECUTE usp_addDirector @directorFirstName = 'Henry', @directorLastName = 'Hathaway';
EXECUTE usp_addDirector @directorFirstName = 'Joss', @directorLastName = 'Whedon';
EXECUTE usp_addDirector @directorFirstName = 'Michael', @directorLastName = 'Gracey';
EXECUTE usp_addDirector @directorFirstName = 'Tim', @directorLastName = 'Miller';

SELECT *
FROM PbDirector;

------ Insert Directors
EXECUTE usp_addMovieDirector @directorFirstName = 'Henry', @directorLastName = 'Hathaway', @movieID = 'TRGRT';
EXECUTE usp_addMovieDirector @directorFirstName = 'Henry', @directorLastName = 'Hathaway', @movieID = 'SonKElder';
EXECUTE usp_addMovieDirector @directorFirstName = 'Joss', @directorLastName = 'Whedon', @movieID = 'Avngrs';
EXECUTE usp_addMovieDirector @directorFirstName = 'Michael', @directorLastName = 'Gracey', @movieID = 'GrtstShwmn';
EXECUTE usp_addMovieDirector @directorFirstName = 'Bryan', @directorLastName = 'Singer', @movieID = 'XMEN';
EXECUTE usp_addMovieDirector @directorFirstName = 'Brad', @directorLastName = 'Bird', @movieID = 'Incrdbles2';
EXECUTE usp_addMovieDirector @directorFirstName = 'Tim', @directorLastName = 'Miller', @movieID = 'Deadpl';
EXECUTE usp_addMovieDirector @directorFirstName = 'George', @directorLastName = 'Lucas', @movieID = 'StrWrsIVNH';

SELECT *
FROM PbMovieDirector;

------ Insert Genres
EXECUTE usp_addGenre @genre = 'Action', @genreDescription = 'Scenes of combat and usage of weapons';
EXECUTE usp_addGenre @genre = 'Adventure', @genreDescription = 'Themes of exploration and discovery';
EXECUTE usp_addGenre @genre = 'Animation', @genreDescription = 'Hand drawn or Computer generated images sequenced in an often exagerated visual style';
EXECUTE usp_addGenre @genre = 'Biography', @genreDescription = 'Non-fiction piece based on the life of still living or diseased individual or group';
EXECUTE usp_addGenre @genre = 'Comedy', @genreDescription = 'Themes of entertainment and jokes in satirical or slapstick styles';
EXECUTE usp_addGenre @genre = 'Drama', @genreDescription = 'Themes of complex relationships and interactions between individuals and their personal lives';
EXECUTE usp_addGenre @genre = 'Fantasy', @genreDescription = 'Fiction based on fantastical universes with magic and powerful creatures';
EXECUTE usp_addGenre @genre = 'Musical', @genreDescription = 'A movie focused on the usage of lyrical presentation to advanced plot and other story elements';
EXECUTE usp_addGenre @genre = 'Sci-Fi', @genreDescription = 'Fiction based on the future with elements of advanced technology, aliens, and often exploration of the universe';
EXECUTE usp_addGenre @genre = 'Western', @genreDescription = 'Set in the "Western" era of US history, during the period of the westward expansion and gold rush';

SELECT *
FROM PbGenre;

------ Insert MovieGenres
EXECUTE usp_addMovieGenre @genre = 'Adventure', @movieID = 'TRGRT';
EXECUTE usp_addMovieGenre @genre = 'Drama', @movieID = 'TRGRT';
EXECUTE usp_addMovieGenre @genre = 'Western', @movieID = 'TRGRT';
EXECUTE usp_addMovieGenre @genre = 'Western', @movieID = 'SonKElder';
EXECUTE usp_addMovieGenre @genre = 'Adventure', @movieID = 'Avngrs';
EXECUTE usp_addMovieGenre @genre = 'Action', @movieID = 'Avngrs';
EXECUTE usp_addMovieGenre @genre = 'Sci-Fi', @movieID = 'Avngrs';
EXECUTE usp_addMovieGenre @genre = 'Biography', @movieID = 'GrtstShwmn';
EXECUTE usp_addMovieGenre @genre = 'Drama', @movieID = 'GrtstShwmn';
EXECUTE usp_addMovieGenre @genre = 'Musical', @movieID = 'GrtstShwmn';
EXECUTE usp_addMovieGenre @genre = 'Adventure', @movieID = 'XMEN';
EXECUTE usp_addMovieGenre @genre = 'Action', @movieID = 'XMEN';
EXECUTE usp_addMovieGenre @genre = 'Sci-fi', @movieID = 'XMEN';
EXECUTE usp_addMovieGenre @genre = 'Adventure', @movieID = 'Incrdbles2';
EXECUTE usp_addMovieGenre @genre = 'Action', @movieID = 'Incrdbles2';
EXECUTE usp_addMovieGenre @genre = 'Animation', @movieID = 'Incrdbles2';
EXECUTE usp_addMovieGenre @genre = 'Action', @movieID = 'Deadpl';
EXECUTE usp_addMovieGenre @genre = 'Adventure', @movieID = 'Deadpl';
EXECUTE usp_addMovieGenre @genre = 'Comedy', @movieID = 'Deadpl';
EXECUTE usp_addMovieGenre @genre = 'Action', @movieID = 'StrWrsIVNH';
EXECUTE usp_addMovieGenre @genre = 'Adventure', @movieID = 'StrWrsIVNH';
EXECUTE usp_addMovieGenre @genre = 'Fantasy', @movieID = 'StrWrsIVNH';

SELECT *
FROM PbMovieGenre;

------ Insert Keywords
EXECUTE usp_addKeyword @keyword = 'Rooster Cogburn';
EXECUTE usp_addKeyword @keyword = 'US Marshal';
EXECUTE usp_addKeyword @keyword = 'Oscar Award Winner';
EXECUTE usp_addKeyword @keyword = 'Gun Fighter';
EXECUTE usp_addKeyword @keyword = 'Family';
EXECUTE usp_addKeyword @keyword = 'Captain America';
EXECUTE usp_addKeyword @keyword = 'Iron Man';
EXECUTE usp_addKeyword @keyword = 'Thor';
EXECUTE usp_addKeyword @keyword = 'Circus';
EXECUTE usp_addKeyword @keyword = 'Barnum';
EXECUTE usp_addKeyword @keyword = 'Singing';
EXECUTE usp_addKeyword @keyword = 'Million Dreams';
EXECUTE usp_addKeyword @keyword = 'Wolverine';
EXECUTE usp_addKeyword @keyword = 'Mutants';
EXECUTE usp_addKeyword @keyword = 'Elastigirl';
EXECUTE usp_addKeyword @keyword = 'Dash';
EXECUTE usp_addKeyword @keyword = 'Jack Jack';
EXECUTE usp_addKeyword @keyword = 'Mercinary';
EXECUTE usp_addKeyword @keyword = 'Morbid';
EXECUTE usp_addKeyword @keyword = 'healing  power';
EXECUTE usp_addKeyword @keyword = 'Jedi Knight';
EXECUTE usp_addKeyword @keyword = 'Darth Vader';
EXECUTE usp_addKeyword @keyword = 'Yoda';

SELECT *
FROM PbKeyword;

------ Insert MovieKeywords
EXECUTE usp_addMovieKeyword @movieID = 'TRGRT', @keyword = 'Rooster Cogburn';
EXECUTE usp_addMovieKeyword @movieID = 'TRGRT', @keyword = 'US Marshal';
EXECUTE usp_addMovieKeyword @movieID = 'TRGRT', @keyword = 'Oscar Award Winner';
EXECUTE usp_addMovieKeyword @movieID = 'SonKElder', @keyword = 'Gun Fighter';
EXECUTE usp_addMovieKeyword @movieID = 'SonKElder', @keyword = 'Family';
EXECUTE usp_addMovieKeyword @movieID = 'Avngrs', @keyword = 'Captain America';
EXECUTE usp_addMovieKeyword @movieID = 'Avngrs', @keyword = 'Iron Man';
EXECUTE usp_addMovieKeyword @movieID = 'Avngrs', @keyword = 'Thor';
EXECUTE usp_addMovieKeyword @movieID = 'GrtstShwmn', @keyword = 'Circus';
EXECUTE usp_addMovieKeyword @movieID = 'GrtstShwmn', @keyword = 'Barnum';
EXECUTE usp_addMovieKeyword @movieID = 'GrtstShwmn', @keyword = 'Singing';
EXECUTE usp_addMovieKeyword @movieID = 'GrtstShwmn', @keyword = 'Million Dreams';
EXECUTE usp_addMovieKeyword @movieID = 'XMEN', @keyword = 'Wolverine';
EXECUTE usp_addMovieKeyword @movieID = 'XMEN', @keyword = 'Mutants';
EXECUTE usp_addMovieKeyword @movieID = 'Incrdbles2', @keyword = 'Elastigirl';
EXECUTE usp_addMovieKeyword @movieID = 'Incrdbles2', @keyword = 'Dash';
EXECUTE usp_addMovieKeyword @movieID = 'Incrdbles2', @keyword = 'Jack Jack';
EXECUTE usp_addMovieKeyword @movieID = 'Deadpl', @keyword = 'Mercinary';
EXECUTE usp_addMovieKeyword @movieID = 'Deadpl', @keyword = 'Morbid';
EXECUTE usp_addMovieKeyword @movieID = 'Deadpl', @keyword = 'healing  power';
EXECUTE usp_addMovieKeyword @movieID = 'StrWrsIVNH', @keyword = 'Jedi Knight';
EXECUTE usp_addMovieKeyword @movieID = 'StrWrsIVNH', @keyword = 'Darth Vader';
EXECUTE usp_addMovieKeyword @movieID = 'StrWrsIVNH', @keyword = 'Yoda';

SELECT *
FROM PbMovieKeyword;