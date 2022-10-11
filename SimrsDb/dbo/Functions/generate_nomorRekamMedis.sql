-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_nomorRekamMedis] 
(
)
RETURNS varchar(10)
AS
BEGIN
	
	/*Make Variable*/
	DECLARE @result varchar(10)
		   ,@counter int = 78632
		   ,@currentDate date = GETDATE();

	/*Make Table Variable*/
	DECLARE @listKodePasien table(kodePasien int);

	/*Collect Last Medrec Code*/
	INSERT INTO @listKodePasien
			   (kodePasien)
		 SELECT TOP 200 
				CAST(kodePasien AS int)
		   FROM dbo.masterPasien
		  WHERE CAST(entryDate AS date) BETWEEN DATEADD(DAY, -1, @currentDate) AND @currentDate
				AND CAST(kodePasien AS int) >= @counter  
	   ORDER BY kodePasien DESC;

	/*GET Minimum Medrec Code*/
	IF EXISTS(SELECT TOP 1 1 FROM @listKodePasien)
		BEGIN
			SELECT @counter = MIN(kodePasien) FROM @listKodePasien;
		END
	
	WHILE EXISTS(SELECT 1 FROM @listKodePasien WHERE kodePasien = @counter)
		BEGIN
			SET @counter += 1;
		END
	
	SET @result = RIGHT('000000'+ CAST(@counter AS varchar(6)), 6);

	WHILE EXISTS(SELECT 1 FROM dbo.masterPasien WHERE kodePasien = @result)
		BEGIN
			SET @counter += 1;
			SET @result = RIGHT('000000'+ CAST(@counter AS varchar(6)), 6);
		END

	RETURN RIGHT('000000'+ CAST(@counter AS varchar(10)), 6)
END