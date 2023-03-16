USE DiskShop;

GO
CREATE VIEW NotTouchedDiscs
AS
	SELECT * FROM Disc
	EXCEPT
	SELECT
		Disc.*
	FROM OperationLog
		 INNER JOIN Disc
				ON OperationLog.idDisc = Disc.ID;



