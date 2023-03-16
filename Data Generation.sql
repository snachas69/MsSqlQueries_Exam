USE DiskShop;

GO
DECLARE @StartDate DATE, @EndDate DATE;

SELECT @StartDate = '01/01/1960',
       @EndDate = GETDATE();

DECLARE @MetaClient TABLE 
(
	Id INT,
	FirstName VARCHAR(30),
	LastName VARCHAR(30),
	AddressPart VARCHAR (30),
	City VARCHAR(30),
	BirthDay DATE,
	MarriedStatus BIT,
	Sex BIT,
	Child BIT
);

DECLARE @number INT,
		@FirstName VARCHAR(30), @LastName VARCHAR(30), @Address VARCHAR (100), @City VARCHAR (30), @ContactPhone VARCHAR(10), @ContactMail VARCHAR(30),
		@BirthDay DATE,
		@MarriedStatus BIT, @Sex BIT, @Child BIT ;

SET @number = 100;

INSERT INTO @MetaClient
VALUES(1, 'Степан',	'Степаненко','Бандери',	'Житомир',	
		DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate), 
		CONVERT(BIT, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0))),
		(2, 'Михайло', 'Михайленко', 'Грушевського', 'Київ', 
		DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate), 
		CONVERT(BIT, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0))),
		(3, 'Іван', 'Іваненко', 'Мазепи',	'Львів',
		DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate), 
		CONVERT(BIT, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0))),
		(4, 'Петро', 'Петренко', 'Скоропадського', 'Луцьк',
		DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate), 
		CONVERT(BIT, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0))),
		(5, 'Богдан',	'Богданенко', 'Хмельницького',	'Хмельницьк',
		DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate), 
		CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0))),
		(6, 'Антон', 'Антоненко',	'Сікорського', 'Ужгород',
		DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate), 
		CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0))),
		(7, 'Олександр', 'Олександренко','Українки','Полтава',
		DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate),
		CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0))),
		(8, 'Тарас', 'Тарасенко',	'Шевченка',	'Чернігів',
		DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate), 
		CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0)), CONVERT(bit, ROUND(1*RAND(),0)));

WHILE @number > 0
BEGIN
	SELECT @FirstName =	FirstName FROM @MetaClient WHERE Id = FLOOR(RAND()*(8-1+1)+1);
	SELECT @LastName = LastName	FROM @MetaClient WHERE Id = FLOOR(RAND()*(8-1+1)+1);
	SELECT @Address = AddressPart FROM @MetaClient WHERE Id = FLOOR(RAND()*(8-1+1)+1);
	SELECT @City = City	FROM @MetaClient WHERE Id = FLOOR(RAND()*(8-1+1)+1);
	SELECT @BirthDay = Birthday	FROM @MetaClient WHERE Id = FLOOR(RAND()*(8-1+1)+1);
	SELECT @MarriedStatus =	MarriedStatus FROM @MetaClient WHERE Id = FLOOR(RAND()*(8-1+1)+1);
	SELECT @Sex = Sex FROM @MetaClient WHERE Id = FLOOR(RAND()*(8-1+1)+1);
	SELECT @Child =	Child FROM @MetaClient WHERE Id = FLOOR(RAND()*(8-1+1)+1);

	SET @Address = @Address + ' ' + CAST((FLOOR(RAND()*(100-1+1)+1)) AS VARCHAR(3));
	SET @number -= 1;

	INSERT INTO Client 
	VALUES (@FirstName, @LastName, @Address, @City, @BirthDay, @MarriedStatus, @Sex, @Child);
END;

GO
DECLARE @MetaPhoneList TABLE
(
	Id INT,
	Phone VARCHAR(10)
);

DECLARE @Clients INT, @Phone VARCHAR(10), @IdClient INT;

SET @Clients = (SELECT MAX(Id) FROM Client);

INSERT INTO @MetaPhoneList
VALUES	(1, '073'),
		(2, '075'),
		(3, '096'),
		(4, '095'),
		(5, '098'),
		(6, '063'),
		(7, '067'),
		(8, '068');

WHILE @Clients > 0
BEGIN
	DECLARE @Number INT;
	SET @Number = CAST(FLOOR(RAND() * (10 - 1) + 1) AS INT);
	
	WHILE @Number > 0
	BEGIN
		SELECT @Phone = Phone FROM @MetaPhoneList WHERE Id = FLOOR(RAND() * (8 - 1 + 1) + 1);
		
		SET @Phone += CAST((FLOOR(RAND() * (999 - 100 + 1) + 100)) AS VARCHAR(3)) + 
						CAST((FLOOR(RAND() * (999 - 100 + 1) + 100)) AS VARCHAR(3)) + 
						CAST((FLOOR(RAND() * (9 - 0 + 1) + 0)) AS VARCHAR(1));

		INSERT INTO PhoneList (Phone, idClient)
		VALUES (@Phone, @Clients);

		SET @Number -= 1;
	END;

	SET @Clients -= 1;
END;

GO
DECLARE @MetaMailList TABLE
(
	Id INT,
	Mail VARCHAR(50)
);

DECLARE @Clients INT, @Mail VARCHAR(50), @IdClient INT;

SET @Clients = (SELECT MAX(Id) FROM Client);

INSERT INTO @MetaMailList
VALUES	(1, '@gmail.com'),
		(2, '@icloud.com'),
		(3, '@itstep.org'),
		(4, '@mail.org'),
		(5, '@ukr.net'),
		(6, '@yahoo.net'),
		(7, '@tele.info'),
		(8, '@web.info');

WHILE @Clients > 0
BEGIN
	DECLARE @Number INT;
	SET @Number = CAST(FLOOR(RAND() * (10 - 1) + 1) AS INT);
	WHILE @Number > 0
	BEGIN
		SELECT @Mail = Mail FROM @MetaMailList WHERE ID = FLOOR(RAND() * (8 - 1 + 1) + 1);
		
		SET @Mail = IIF(CAST(FLOOR(RAND() * (255 - 1) + 1) AS INT) % 2 = 0, 'email', 'mail') + CAST(FLOOR(RAND() * (255 - 1) + 1) AS VARCHAR(3)) + @Mail;

		INSERT INTO MailList (Mail, idClient)
		VALUES (@Mail, @Clients);

		SET @Number -= 1;
	END;
	SET @Clients -= 1;
END;

GO
DECLARE @MetaMusic TABLE
(
	Id INT,
	Name VARCHAR(50),
	Genre VARCHAR(50),
	Artist VARCHAR(50),
	Language VARCHAR(50)
);

DECLARE @number INT, @Name VARCHAR(50), @Genre VARCHAR(50), @Artist VARCHAR(50), @Language VARCHAR(50);

SET @number = 40;
INSERT INTO @MetaMusic
VALUES  (1,  'Steps Of The Storm',					'Pop',			'High Fire',				'English'),
		(2,  'Think For A Moment Of Peace',			'Rock',			'Echo Chords',				'Spanish'),
		(3,  'Street',								'Hip-Hop',		'Simple Spark',				'Fhench'),
		(4,  'Memories',							'Metal',		'Lost Aces',				'German'),
		(5,  'Dreams Of The Devil',					'Jazz',			'Adorable Enemies',			'Italian'),
		(6,  'Way Of Heaven',						'Blues',		'Glass Union',				'Ukrainian'),
		(7,  'Tracks Of My Angel',					'Country',		'Flux',						'Polish'),
		(8,  'Living Of My Enemies',				'EDM',			'Spoof',					'Arabic'),
		(9,  'Desired And Angel',					'Latin',		'Gesture',					'Japanese'),
		(10, 'Wicked And Soul',						'R&B',			'Rapture',					'Korean'),
		(11, 'You Knock Me Off My Feet',			'Folk',			'Strife',					'Hindi'),
		(12, 'It`s Time For Rock And Roll',			'World',		'Oasis of Integrity',		'Chinese'),
		(13, 'Get It Together',						'New Age',		'Cipher of Doubt',			'Welsh'),
		(14, 'Babe, I`m Lonely',					'Acoustic',		'Salvo of Rage',			'English'),
		(15, 'Rock My World',						'Pop',			'Figures of One Night',		'Spanish'),
		(16, 'She Thinks I Rock All Night',			'Rock',			'Marvel of Habit',			'Fhench'),
		(17, 'He Hopes I`m Nothing Without You',	'Hip-Hop',		'Season of Obscurity',		'German'),
		(18, 'She Knows You Called For Me',			'Metal',		'Association of Utopia',	'Italian'),
		(19, 'She Hopes I Live On The Wild Side',	'Jazz',			'Theory',					'Ukrainian'),
		(20, 'I Go My Own Way',						'Blues',		'Delirium',					'Polish'),
		(21, 'She Thinks He`s Going To Hell',		'Country',		'Warmth of Velocity',		'Arabic'),
		(23, 'She Knows He`s Rock`N Roll',			'EDM',			'Epoch of Fiction',			'Japanese'),
		(24, 'She Hates You Rock My World',			'Latin',		'Personality of Luck',		'Korean'),
		(25, 'He Thinks He`s Going To Hell',		'R&B',			'Dynamite Sounds',			'Hindi');

WHILE @number > 0
BEGIN
	SELECT @Name = Name	FROM @MetaMusic WHERE Id =  FLOOR(RAND() * (25 - 1 + 1) + 1);
	SELECT @Genre =	Genre FROM @MetaMusic WHERE Id =  FLOOR(RAND() * (25 - 1 + 1) + 1);
	SELECT @Artist = Artist	FROM @MetaMusic WHERE Id =  FLOOR(RAND() * (25 - 1 + 1) + 1);
	SELECT @Language = Language	FROM @MetaMusic WHERE Id =  FLOOR(RAND() * (25 - 1 + 1) + 1);

	INSERT INTO Music
	VALUES (@Name, @Genre, @Artist, @Language);

	SET @number -= 1;
END;

GO
DECLARE @MetaFilm TABLE
(
	Id INT,
	Name VARCHAR(30),
	Genre VARCHAR(30),
	Producer VARCHAR(30),
	MainRole VARCHAR(30),
	AgeLimit INT
);

DECLARE @number INT, @Id INT, @Name VARCHAR(30), @Genre VARCHAR(30), @Producer VARCHAR(30), @MainRole VARCHAR(30), @AgeLimit INT;

SET @number = 40;

INSERT INTO @MetaFilm
VALUES  (1,		'warrior without desire',		'Classic',		'Maximo Wheeler',		'Brynlee Rojas',		6),
		(2,		'parrot of reality',			'Drama',		'Jerry Buck',			'Serena Mcdowell',		12),
		(3,		'criminals without courage',	'Thriller',		'Tyshawn Frost',		'Jazlyn Griffin',		14),
		(4,		'heirs of the ancestors',		'Action',		'Heath Mckinney',		'Urijah Trevino',		16),
		(5,		'creators and owls',			'Comedy',		'Rafael Rich',			'Natalie Shah',			18),
		(6,		'kings and priests',			'Romance',		'Kailey Sellers',		'Nathanael Cordova',	0),
		(7,		'victory of the river',			'Musical',		'Bradyn Mckenzie',		'Ella Landry',			6),
		(8,		'influence of darkness',		'Animation',	'Kael Boyer',			'Carsen Rose',			12),
		(9,		'bound to my school',			'Horror',		'Shamar Love',			'Vaughn Cherry',		14),
		(10,	'bathing in the world',			'Foreign',		'Ryan Gonzalez',		'Isiah Curtis',			16),
		(11,	'dead in dreams',				'Independent',	'Yusuf Horton',			'Alicia Cervantes',		18),
		(12,	'dead in the city',				'Documentary',	'Kassandra Raymond',	'Maximillian Collier',	0),
		(13,	'blood at the river',			'Classic',		'Helen Krause',			'Richard Bautista',		6),
		(14,	'sounds in the city',			'Drama',		'Ally Alvarado',		'Jaylen Barajas',		12),
		(15,	'faith of nightmares',			'Thriller',		'Lorenzo Bishop',		'Caden Mcbride',		14),
		(16,	'meeting in the immortals',		'Action',		'Zaid Newman',			'Jamarcus Garner',		16),
		(17,	'eliminating my family',		'Comedy',		'Deacon Baker',			'Casey Wolfe',			18),
		(18,	'songs of the north',			'Romance',		'Ainsley Hernandez',	'Craig Tapia',			0),
		(19,	'destroying nature',			'Musical',		'Gilbert Mcdowell',		'Kaliyah Harrell',		6),
		(20,	'answering the south',			'Animation',	'Evan Hobbs',			'Danica Bullock',		12),
		(21,	'praised by the south',			'Horror',		'Madden Ewing',			'Deacon Estrada',		14),
		(22,	'the time of empire',			'Foreign',		'Alisa Sanford',		'Jagger Solomon',		16),
		(23,	'dancing in the commander',		'Independent',	'Judith Le',			'Nataly Poole',			18),
		(24,	'mending eternity',				'Documentary',	'Marc Horton',			'Glenn Barnett',		0),
		(25,	'rescue in the dark',			'Classic',		'Giovanni Sanders',		'Belen Chase',			6);

WHILE @number > 0
BEGIN
	SELECT @Name = Name FROM @MetaFilm WHERE Id = FLOOR(RAND() * (25 - 1 + 1) + 1);
	SELECT @Genre = Genre FROM @MetaFilm WHERE Id =	FLOOR(RAND() * (25 - 1 + 1) + 1);
	SELECT @Producer = Producer	FROM @MetaFilm WHERE Id = FLOOR(RAND() * (25 - 1 + 1) + 1);
	SELECT @MainRole = MainRole	FROM @MetaFilm WHERE Id = FLOOR(RAND() * (25 - 1 + 1) + 1);
	SELECT @AgeLimit = AgeLimit	FROM @MetaFilm WHERE Id = FLOOR(RAND() * (25 - 1 + 1) + 1);

	INSERT INTO Film
	VALUES (@Name, @Genre, @Producer, @MainRole, @AgeLimit);

	SET @number -= 1;
END;

GO
DECLARE @MetaDisc TABLE
(
	Id INT,
	Name VARCHAR(50),
	Price DECIMAL(9, 2)
);

DECLARE @Number1 INT, @Number2 INT, @Name VARCHAR(50), @Price DECIMAL(9, 2);

SET @Number1 = 200;
SET @Number2 = 1;
WHILE @Number2 <= 20
BEGIN
	INSERT INTO @MetaDisc
	VALUES  (@Number2, CONCAT('Film', @Number2), RAND() * (50- 5 + 1) + 6);

	SET @Number2 += 1;
END;

SET @Number2 = 20;

WHILE @Number2 <= 40
BEGIN
	INSERT INTO @MetaDisc
	VALUES  (@Number2, CONCAT('Music', @Number2), RAND() * (50 - 5 + 1) + 6);

	SET @Number2 += 1;
END;

WHILE @Number1 > 0
BEGIN
	SELECT @Name = Name	FROM @MetaDisc WHERE Id = FLOOR(RAND()*(40-1+1)+1)
	SELECT @Price = Price FROM @MetaDisc WHERE Id = FLOOR(RAND()*(40-1+1)+1)

	INSERT INTO Disc
	VALUES (@Name, @Price);

	SET @Number1 -=1;
END;

GO
DECLARE @number INT = 100;
	
WHILE @number > 0
BEGIN
	INSERT INTO DiscMusic
	VALUES (
			FLOOR(RAND() * ( 
								(
									SELECT 
									FLOOR(RAND()*(MAX(Id)-1+1)+1) 
									FROM Disc 
									WHERE Name LIKE '%Music%'
								) - 1 + 1) + 1
					),
			FLOOR(RAND() * ( 
								(
									SELECT 
									FLOOR(RAND()*(MAX(Id)-1+1)+1) 
									FROM Music
								) - 1 + 1) + 1
					)
			);

	SET @number -=1;
END;

GO
DECLARE @number INT = 100;
	
WHILE @number > 0
BEGIN
	INSERT INTO DiscFilm
	VALUES (
			FLOOR(RAND() * ( 
								(
									SELECT 
									FLOOR(RAND()*(MAX(Id)-1+1)+1) 
									FROM Disc 
									WHERE Name LIKE '%Film%'
								) - 1 + 1) + 1
					),
			FLOOR(RAND() * ( 
								(
									SELECT 
									FLOOR(RAND()*(MAX(Id)-1+1)+1) 
									FROM Music
								) - 1 + 1) + 1
					)
			);

	SET @number -=1;
END;

GO
DECLARE @StartDate AS DATE;
DECLARE @EndDate AS DATE;

SELECT @StartDate = '01/01/2014',
       @EndDate = DATEADD(DAY, -60, GETDATE());

DECLARE @types TABLE (id INT IDENTITY(1, 1), type VARCHAR(10));

INSERT INTO @types 
VALUES ('Купівля'), ('Оренда');

DECLARE @Number INT = 500, @OperationType VARCHAR(10), @OperationStart DATETIME, @OperationEnd DATETIME, @IdClient INT, @IdDisc INT, @OperationPrice DECIMAL(9, 2);

WHILE @Number > 0
BEGIN
	SET @OperationType = (SELECT type FROM @types WHERE id = FLOOR(RAND() * (2 - 1 + 1) + 1));

    
	SET @OperationStart = DATEADD(DAY, RAND(CHECKSUM(NEWID())) * (1 + DATEDIFF(DAY, @StartDate, @EndDate)), @StartDate);

	DECLARE @RandomDebtor INT = FLOOR(RAND() * (10 - 1 + 1) + 1);

	SET @OperationEnd = IIF
						(
							@OperationType = 'Покупка', 
							NULL,
							IIF(
									@RandomDebtor = FLOOR(RAND() * (10 - 1 + 1) + 1), 
									NULL, 
									DATEADD(DAY, FLOOR(RAND() * (80 - 20 + 1) + 20), @OperationStart)
								)
						);
            

	SET @IdClient = FLOOR(RAND() * ((SELECT MAX(Id) FROM Client) - 1 + 1) + 1);
	SET @IdDisc = FLOOR(RAND() * ((SELECT MAX(Id) FROM Disc) - 1 + 1) + 1);
	SET @OperationPrice = FLOOR(RAND() * (1000 - 50 + 1) + 50);

	INSERT INTO OperationLog
	VALUES (@IdDisc, @IdClient, @OperationType, @OperationStart, @OperationEnd);

	SET @number -= 1;
END;