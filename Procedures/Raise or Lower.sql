USE DiskShop;

GO
CREATE PROCEDURE SP_RaiseOrLower
	@Type VARCHAR(5),
	@RaiseOrLower BIT,
	@Amount INT
AS
	IF LOWER(@Type) = 'music'
		BEGIN
			UPDATE Disc
			SET Disc.Price = Disc.Price * IIF(@RaiseOrLower = 1, 1, -1) + (Disc.Price * @Amount) / 100
			FROM Disc
				 INNER JOIN DiscMusic
				        ON Disc.ID = DiscMusic.idDisc
		END;
	ELSE
		BEGIN
			UPDATE Disc
			SET Disc.Price = Disc.Price * IIF(@RaiseOrLower = 1, 1, -1) + (Disc.Price * @Amount) / 100
			FROM Disc
				 INNER JOIN DiscFilm
				        ON Disc.ID = DiscFilm.idDisc
		END;