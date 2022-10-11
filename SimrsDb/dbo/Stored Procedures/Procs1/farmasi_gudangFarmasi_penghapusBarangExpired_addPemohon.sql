-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpired_addPemohon]
	-- Add the parameters for the stored procedure here
	@pemohon varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiMasterPetugas WHERE namaPetugasFarmasi = @pemohon)
		BEGIN
			SELECT 'Data Pemohon Sudah Ada' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[farmasiMasterPetugas]
					   ([namaPetugasFarmasi])
				 VALUES
					   (@pemohon)
			SELECT 'Data Pemohon Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END