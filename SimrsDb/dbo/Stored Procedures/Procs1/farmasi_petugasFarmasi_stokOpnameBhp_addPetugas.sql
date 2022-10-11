-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhp_addPetugas]
	-- Add the parameters for the stored procedure here
	@namaPetugasFarmasi varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMasterPetugas WHERE namaPetugasFarmasi = @namaPetugasFarmasi)
		BEGIN
			SELECT 'Petugas '+ @namaPetugasFarmasi +' Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[farmasiMasterPetugas]
					   ([namaPetugasFarmasi])
				 VALUES
					   (@namaPetugasFarmasi);

			SELECT 'Data Petugas Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END