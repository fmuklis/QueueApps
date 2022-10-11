-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_editNegara]
	-- Add the parameters for the stored procedure here
	 @idNegara int
	,@namaNegara nvarchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (select 1 from [dbo].[masterNegara] where [namaNegara] = @namaNegara AND [idNegara] <> @idNegara)
			BEGIN
				SELECT 'Negara '+ @namaNegara +' telah terdaftar' as respon, 0 as responCode;
			END
	ELSE
		BEGIN
			UPDATE [dbo].[masterNegara]
			SET [namaNegara] = @namaNegara
			WHERE [idNegara] = @idNegara;
			SELECT 'Data berhasil diupdate' as respon, 1 as responCode;
		END
	
END