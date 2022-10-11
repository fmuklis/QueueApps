-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhp_addStokOpname]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@idPeriodeStokOpname int,
    @idPetugas int,
    @tanggalStokOpname date,
    @idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idStokOpname bigint = (SELECT idStokOpname FROM dbo.farmasiStokOpname
									 WHERE idPeriodeStokOpname = @idPeriodeStokOpname AND idRuangan = @idRuangan
										   AND idStatusStokOpname = 1/*Proses Entry*/);

	SET NOCOUNT ON;

    -- Insert statements for procedure here

	IF @idStokOpname IS NULL
		BEGIN
			INSERT INTO [dbo].[farmasiStokOpname]
					   ([idRuangan]
					   ,[idPeriodeStokOpname]
					   ,[idPetugas]
					   ,[tanggalStokOpname]
					   ,[idUserEntry])
				 VALUES
					   (@idRuangan
					   ,@idPeriodeStokOpname
					   ,@idPetugas
					   ,@tanggalStokOpname
					   ,@idUserEntry);

			SELECT 'Data Stok Opname BHP Berhasil Ditambah' AS respon, SCOPE_IDENTITY() AS idStokOpname, 1 AS responCode;
		END
	ELSE
		BEGIN
			SELECT 'Data Stok Opname BHP Ditemukan' AS respon, @idStokOpname AS idStokOpname, 1 AS responCode;
		END
END