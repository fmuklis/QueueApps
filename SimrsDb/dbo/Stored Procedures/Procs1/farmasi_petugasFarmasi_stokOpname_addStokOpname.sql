-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpname_addStokOpname]
	-- Add the parameters for the stored procedure here
	 @idPeriodeStokOpname int,
    @idPetugas int,
    @tanggalStokOpname date,
    @idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok tinyint = (SELECT b.idJenisStok FROM dbo.masterUser a
										   INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan
									 WHERE a.idUser = @idUserEntry);

	DECLARE @idStokOpname bigint = (SELECT idStokOpname FROM dbo.farmasiStokOpname
									 WHERE idPeriodeStokOpname = @idPeriodeStokOpname AND idPetugas = @idPetugas
										   AND idStatusStokOpname = 1/*Proses Entry*/ AND idJenisStok = @idJenisStok);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @idJenisStok IS NULL
		BEGIN
			SELECT 'Akun Anda Belum Memiliki Lokasi Depo / TPO, Hubungi IT' AS respon, 0 AS responCode;
			RETURN;
		END

	IF @idStokOpname IS NULL
		BEGIN
			INSERT INTO [dbo].[farmasiStokOpname]
					   ([idJenisStok]
					   ,[idPeriodeStokOpname]
					   ,[idPetugas]
					   ,[tanggalStokOpname]
					   ,[idUserEntry])
				 VALUES
					   (@idJenisStok
					   ,@idPeriodeStokOpname
					   ,@idPetugas
					   ,@tanggalStokOpname
					   ,@idUserEntry);

			SET @idStokOpname = SCOPE_IDENTITY();
		END

	SELECT 'Data Stok Opname Ditemukan' AS respon, @idStokOpname AS idStokOpname, 1 AS responCode;
END