USE DiskShop;

GO
CREATE VIEW Debtors
AS
	SELECT
		Client.ID,
		Client.FirstName + ' ' + Client.LastName AS Name,
		CAST(DATEADD(Month, 1, OperationLog.OperationDateTimeStart) AS DATE) AS 'In debt from',
		CAST(GETDATE() AS DATE) AS 'to'
	FROM OperationLog
		 INNER JOIN Client
			   ON OperationLog.idClient = Client.ID
	WHERE 1=1
		  AND DATEDIFF(Month, OperationDateTimeStart, GETDATE()) > 1
		  AND OperationLog.OperationDateTimeEnd IS NULL
		  AND OperationLog.OperationType = 'Оренда';