-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_editDesaKelurahan]
	-- Add the parameters for the stored procedure here
	 @idDesaKelurahan int
	,@namaDesaKelurahan nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (select 1 from [dbo].[masterDesaKelurahan] where [namaDesaKelurahan] = @namaDesaKelurahan AND idDesaKelurahan <> @idDesaKelurahan)
	BEGIN
				SELECT 'Desa '+ @namaDesaKelurahan +' telah terdaftar' as respon, 0 as responCode;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[masterDesaKelurahan]
			SET [namaDesaKelurahan] = @namaDesaKelurahan
			WHERE idDesaKelurahan = @idDesaKelurahan;
			SELECT 'Data berhasil diupdate' as respon, 1 as responCode;
		END
	
END