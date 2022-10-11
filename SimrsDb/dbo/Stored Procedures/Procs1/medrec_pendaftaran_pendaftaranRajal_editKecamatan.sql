-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_editKecamatan]
	-- Add the parameters for the stored procedure here
	 @idKecamatan int
	,@namaKecamatan nvarchar(50)
	,@idKabupaten int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 from [dbo].[masterKecamatan] where [idKecamatan] = @idKecamatan)
		BEGIN
			UPDATE [dbo].[masterKecamatan]
			SET [namaKecamatan] = @namaKecamatan
				,[idKabupaten] = @idKabupaten
			WHERE [idKecamatan] = @idKecamatan;
			SELECT 'Data Berhasil Diubah' as respon, 1 as responCode;
		END
	ELSE
		BEGIN
			SELECT 'Maaf Data Tidak Ditemukan' as respon, 0 as responCode;
		END
END