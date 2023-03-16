USE DiskShop;

GO
CREATE PROCEDURE SP_RaiseOrLowerDiscount
	@IdClient INT,
	@Level INT
AS
	DECLARE @DiscountLevels TABLE (DiscountLevel INT, Value INT);
	INSERT INTO @DiscountLevels
	VALUES (1, 0),
		   (2, 5),
		   (3, 15),
		   (4, 20);

	INSERT INTO PersonalDiscount
	VALUES (
				GETDATE(), 
				NULL, 
				(SELECT Value FROM @DiscountLevels WHERE @Level = DiscountLevel), 
				@IdClient
		   );