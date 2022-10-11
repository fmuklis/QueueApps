-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_editKabupaten]
	-- Add the parameters for the stored procedure here
	 @idKabupaten int
	,@namaKabupaten nvarchar(50)
	,@idProvinsi int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (select 1 from [dbo].[masterKabupaten] where [namaKabupaten] = @namaKabupaten AND [idKabupaten] <> @idKabupaten)
		BEGIN
				SELECT 'Kabupaten '+ @namaKabupaten +' telah terdaftar' as respon, 0 as responCode;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[masterKabupaten]
			SET [namaKabupaten] = @namaKabupaten
				,[idProvinsi] = @idProvinsi
			WHERE [idKabupaten] = @idKabupaten;
			SELECT 'Data berhasil diupdate' as respon, 1 as responCode;
		END
	
END