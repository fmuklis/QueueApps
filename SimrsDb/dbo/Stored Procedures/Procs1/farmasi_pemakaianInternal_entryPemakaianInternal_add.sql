-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_pemakaianInternal_entryPemakaianInternal_add]
	-- Add the parameters for the stored procedure here
	@tanggalPermintaan date,
	@idBagian int,
	@pemohon varchar(50),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok tinyint = (SELECT b.idJenisStok FROM dbo.masterUser a
										   INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan 
									 WHERE idUser = @idUserEntry);

	DECLARE @idPemakaianInternal bigint = (SELECT idPemakaianInternal
											 FROM dbo.farmasiPemakaianInternal WHERE idJenisStok = @idJenisStok
												  AND tanggalPermintaan = @tanggalPermintaan AND pemohon = @pemohon
												  AND idBagian = @idBagian AND idStatusPemakaianInternal = 1/*Proses Entry*/)

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @idPemakaianInternal IS NULL
		BEGIN
			INSERT INTO [dbo].[farmasiPemakaianInternal]
					   ([idJenisStok]
					   ,[tanggalPermintaan]
					   ,[idBagian]
					   ,[pemohon]
					   ,[idUserEntry])
				 VALUES
					   (@idJenisStok
					   ,@tanggalPermintaan
					   ,@idBagian
					   ,@pemohon
					   ,@idUserEntry);

			SELECT 'Data Pemakaian Internal Berhasil Disimpan' AS respon, 1 AS responCode, SCOPE_IDENTITY() AS idPemakaianInternal;
		END
	ELSE
		BEGIN
			SELECT 'Data Pemakaian Internal Ditemukan' AS respon, 1 AS responCode, @idPemakaianInternal AS idPemakaianInternal;
		END
END