USE DiskShop;

GO
CREATE VIEW QuartalIncome
AS
	WITH CTE_Statistics
	AS
	(
		SELECT
			YEAR(OperationLog.OperationDateTimeStart) AS Year, 
			(

				CASE
					WHEN MONTH(OperationLog.OperationDateTimeStart) IN (1, 2, 3) THEN '1  вартал'
					WHEN MONTH(OperationLog.OperationDateTimeStart) IN (4, 5, 6) THEN '2  вартал'
					WHEN MONTH(OperationLog.OperationDateTimeStart) IN (7, 8, 9) THEN '3  вартал'
					WHEN MONTH(OperationLog.OperationDateTimeStart) IN (10, 11, 12) THEN '4  вартал'
				END
			) AS Quartal, 
			OperationPrice AS Income
		FROM OperationLog
	)

	SELECT
		Year AS '–≥к',
		[1  вартал],
		[2  вартал],
		[3  вартал],
		[4  вартал]
	FROM CTE_Statistics
	PIVOT
	(
		SUM(Income)
		FOR Quartal IN ([1  вартал],[2  вартал],[3  вартал],[4  вартал])
	) AS Pivot_Quartal;