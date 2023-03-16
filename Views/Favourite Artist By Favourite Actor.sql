USE DiskShop;

GO
CREATE VIEW FavouriteArtistByFavouriteActor
AS
	WITH CTE_Subquery1
	AS
	(
		SELECT DISTINCT
				Client.ID,
				Client.FirstName + ' ' + Client.LastName AS FullName,
				Film.MainRole AS FavouriteActor,
				COUNT(Film.MainRole) OVER(PARTITION BY Client.ID, Film.MainRole) AS ActorOccurrences
		FROM OperationLog
				INNER JOIN Client
					ON OperationLog.idClient = Client.ID
				INNER JOIN Disc
					ON OperationLog.idDisc = Disc.ID
				INNER JOIN DiscFilm
					ON DiscFilm.idDisc = Disc.ID
				INNER JOIN Film
					ON DiscFilm.idFilm = Film.ID
		WHERE 1=1
			  AND Client.Sex = 1
			  AND Client.Child = 1
			  AND Client.MarrigeStatus = 0
	),
	CTE_NotMarriedMenWithKids
	AS
	(
		SELECT
			*
		FROM
		(
			SELECT
				ID,
				FullName,
				FavouriteActor,
				ActorOccurrences,
				MAX(ActorOccurrences) OVER(PARTITION BY ID) AS MaxOcuurance
			FROM CTE_Subquery1
		) subquery
		WHERE ActorOccurrences = MaxOcuurance
	),
	CTE_Subquery2
	AS
	(
		SELECT DISTINCT
			Clients.ID,
			Clients.FullName,
			Music.Artist AS FavoriteArtist,
			COUNT(Music.Artist) OVER(PARTITION BY Clients.ID, Music.Artist) AS ArtistOccurences
		FROM CTE_NotMarriedMenWithKids AS Clients
			 INNER JOIN OperationLog
					ON Clients.ID = OperationLog.idClient
			 INNER JOIN Disc
					ON OperationLog.idDisc = Disc.ID
			 INNER JOIN DiscMusic
					ON DiscMusic.idDisc = Disc.ID
			 INNER JOIN Music
					ON DiscMusic.idMusic = Music.ID
		WHERE FavouriteActor = 'Rafael Rich'
	)

	SELECT
		ID,
		FullName,
		FavoriteArtist
	FROM
	(
		SELECT
			ID,
			FullName,
			FavoriteArtist,
			ArtistOccurences,
			MAX(ArtistOccurences) OVER(PARTITION BY ID) AS MaxOcuurance
		FROM CTE_Subquery2
	) subquery
	WHERE ArtistOccurences = MaxOcuurance;
	