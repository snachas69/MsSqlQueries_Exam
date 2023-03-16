USE DiskShop;

GO
CREATE TRIGGER TG_OperationLog 
ON OperationLog AFTER INSERT
AS
	DECLARE @Income DECIMAL (9, 2), @idClient INT, @idDisc INT, @OperationType VARCHAR(10), @DiscountValue INT;
	DECLARE @DiscountValues TABLE (DiscountLevel INT, ForIncomeStart DECIMAL(9, 2), ForIncomeEnd DECIMAL(9, 2), Value INT);

	DECLARE Pmt_Cursor CURSOR FOR
	SELECT idClient, idDisc, OperationType FROM inserted

	INSERT INTO @DiscountValues
	VALUES (1, 0, 5000, 0),
		   (2, 5000, 15000, 5),
		   (3, 30000, 50000, 15),
		   (4, 50000, NULL, 20);
	
	OPEN Pmt_Cursor;

	FETCH NEXT FROM Pmt_Cursor INTO @idClient, @idDisc, @OperationType;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT
			@Income = OperationPrice
		FROM OperationLog
		WHERE idClient = @idClient;

		SELECT
			@DiscountValue = Value
		FROM @DiscountValues
		WHERE 1=1
			  AND ForIncomeStart >= @Income 
			  AND (ForIncomeEnd <= @Income OR ForIncomeEnd IS NULL);
		
		IF @DiscountValue != (
								 SELECT
									MAX('Row number')
								 FROM
									  (
										SELECT ROW_NUMBER() OVER() AS 'Row number' 
										FROM PersonalDiscount 
										WHERE idClient = @idClient
									  ) AS Subquery
							)
		BEGIN
			UPDATE PersonalDiscount
			SET EndDateTime = GETDATE()
			WHERE idClient = @idClient
				  AND EndDateTime IS NULL;

			IF (SELECT DATEDIFF(MONTH, OperationDateTimeEnd, GETDATE()) FROM OperationLog WHERE idClient = @idClient AND OperationDateTimeEnd IS NULL) > 2
			BEGIN
				SELECT
					@DiscountValue = (SELECT Value FROM @DiscountValues AS Subquery WHERE Query.DiscountLevel - 1 = Subquery.DiscountLevel)
				FROM @DiscountValues AS Query
				WHERE Value = @DiscountValue;
			END;

			INSERT INTO PersonalDiscount
			VALUES (GETDATE(), NULL, @DiscountValue, @idClient);
			
		END;
		FETCH NEXT FROM Pmt_Cursor INTO @idClient, @idDisc, @OperationType;
	END;

	CLOSE Pmt_Cursor;
	DEALLOCATE Pmt_Cursor;

	