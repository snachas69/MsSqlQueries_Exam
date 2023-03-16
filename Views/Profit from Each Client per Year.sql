USE DiskShop;

GO
CREATE VIEW ProfitFromEachClientPerYear
AS
	SELECT
		YEAR(OperationLog.OperationDateTimeStart) AS Year,
		Costumer.FirstName + ' ' + Costumer.LastName AS Name,
		(
			SELECT
				OperationPrice
			FROM OperationLog
			WHERE OperationLog.idClient = Costumer.ID AND OperationLog.OperationType = '������'
		) AS FilmPurchace,
		(
			SELECT
				OperationPrice
			FROM OperationLog
			WHERE OperationLog.idClient = Costumer.ID AND OperationLog.OperationType = '������'
		) AS FilmRent,
		(
			SELECT
				OperationPrice
			FROM OperationLog
			WHERE OperationLog.idClient = Costumer.ID AND OperationLog.OperationType = '������'
		) AS MusicPurchace,
		(
			SELECT
				OperationPrice
			FROM OperationLog
			WHERE OperationLog.idClient = Costumer.ID AND OperationLog.OperationType = '������'
		) AS MusicRent
	FROM OperationLog
		 INNER JOIN Client AS Costumer
			ON OperationLog.idClient = Costumer.ID
	GROUP BY YEAR(OperationLog.OperationDateTimeStart),
			 Costumer.FirstName + ' ' + Costumer.LastName,
			 Costumer.ID