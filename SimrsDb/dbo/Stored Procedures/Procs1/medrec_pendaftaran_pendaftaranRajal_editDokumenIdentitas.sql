-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_editDokumenIdentitas]
	-- Add the parameters for the stored procedure here
	 @idDokumenIdentitas int
	,@namaDokumenIdentitas nvarchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (select 1 from [dbo].[masterDokumenIdentitas] where [namaDokumenIdentitas] = @namaDokumenIdentitas AND [idDokumenIdentitas] <> @idDokumenIdentitas)
	BEGIN
				SELECT 'Dokumen '+ @namaDokumenIdentitas +' telah terdaftar' as respon, 0 as responCode;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[masterDokumenIdentitas]
				SET [namaDokumenIdentitas] = @namaDokumenIdentitas
			WHERE [idDokumenIdentitas] = @idDokumenIdentitas;
			SELECT 'Data berhasil diupdate' as respon, 1 as responCode;
		END
	
END