USE DiskShop;

GO
CREATE VIEW PostDomen
AS
	WITH CTE_Subquery1
	AS
	(
		SELECT DISTINCT
			Client.ID,
			Client.FirstName + ' ' + Client.LastName AS Name
		FROM Client
			 INNER JOIN PhoneList
				ON PhoneList.idClient = Client.ID
			 INNER JOIN Debtors
				ON Client.ID != Debtors.ID
		WHERE (PhoneList.Phone LIKE '068%' 
			   OR PhoneList.Phone LIKE '067%'
			   OR PhoneList.Phone LIKE '096%'
			   OR PhoneList.Phone LIKE '097%'
			   OR PhoneList.Phone LIKE '098%')
			  AND (MONTH(Client.BirthDay) = 3 AND DAY(Client.BirthDay) > 20
				   OR MONTH(Client.BirthDay) = 4 AND DAY(Client.BirthDay) < 19)
	),
	CTE_Subquery2_1
	AS
	(
		SELECT DISTINCT
			CTE_Subquery1.*,
			Film.Genre AS FavouriteFilmGanre,
			COUNT(Film.Genre) OVER(PARTITION BY CTE_Subquery1.ID, Film.Genre) AS FilmGenreOccurences
		FROM CTE_Subquery1
			 INNER JOIN OperationLog 
				ON OperationLog.idClient = CTE_Subquery1.ID
			 INNER JOIN Disc
				ON OperationLog.idDisc = Disc.ID
			INNER JOIN DiscFilm
				ON DiscFilm.idDisc = Disc.ID
			INNER JOIN Film
				ON Film.ID = DiscFilm.idFilm

	),
	CTE_Subquery3_1
	AS
	(
		SELECT
			*
		FROM
		(
			SELECT
				ID,
				Name,
				FavouriteFilmGanre,
				FilmGenreOccurences,
				MAX(FilmGenreOccurences) OVER(PARTITION BY ID) AS MaxFilmGanreOcuurance
			FROM CTE_Subquery2_1
		) subquery
		WHERE FavouriteFilmGanre = MaxFilmGanreOcuurance
	),
	CTE_Subquery2_2
	AS
	(
		SELECT DISTINCT
			CTE_Subquery1.*,
			Music.Genre AS FavouriteMusicGanre,
			COUNT(Music.Genre) OVER(PARTITION BY CTE_Subquery1.ID, Music.Genre) AS GenreMusicOccurences
		FROM CTE_Subquery1
			 INNER JOIN OperationLog 
				ON OperationLog.idClient = CTE_Subquery1.ID
			 INNER JOIN Disc
				ON OperationLog.idDisc = Disc.ID
			INNER JOIN DiscMusic
				ON DiscMusic.idDisc = Disc.ID
			INNER JOIN Music
				ON Music.ID = DiscMusic.idMusic

	),
	CTE_Subquery3_2
	AS
	(
		SELECT
			*
		FROM
		(
			SELECT
				ID,
				Name,
				FavouriteMusicGanre,
				GenreMusicOccurences,
				MAX(GenreMusicOccurences) OVER(PARTITION BY ID) AS MaxMusicOcuurance
			FROM CTE_Subquery2_2
		) subquery
		WHERE GenreMusicOccurences = MaxMusicOcuurance
	)

	SELECT
		CTE_Subquery3_1.ID,
		CTE_Subquery3_1.Name,
		SUBSTRING (MailList.Mail, CHARINDEX( '@', MailList.Mail) + 1, LEN(MailList.Mail)) AS Domain
	FROM CTE_Subquery3_2
	     INNER JOIN CTE_Subquery3_1
			ON CTE_Subquery3_1.ID = CTE_Subquery3_2.ID
		 INNER JOIN MailList
			ON CTE_Subquery3_1.ID = MailList.idClient
	WHERE CTE_Subquery3_2.FavouriteMusicGanre = 'Rock' 
		  AND CTE_Subquery3_1.FavouriteFilmGanre = 'Action'