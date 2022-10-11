-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE gizi_layananKonsumsi_dashboard_konfirmasiGizi
	-- Add the parameters for the stored procedure here
	@idUserSession bigint,
	@idPendaftaranPasien int,
	@keteranganDiet varchar(250),
	@jenisDiet varchar(250),
	@alergiMakanan varchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*Update data diet*/
	UPDATE dbo.transaksiPendaftaranPasien
	   SET jenisDiet = @jenisDiet
		  ,keteranganDiet = @keteranganDiet
	 WHERE idPendaftaranPasien = @idPendaftaranPasien;

	 /*Add data alergi makanan*/
	 IF LEN(@alergiMakanan) >= 3
		BEGIN
			 INSERT INTO [dbo].[masterPasienAlergi]
						([idPasien]
						,[idJenisAlergi]
						,[alergiPasien]
						,[idUserEntry])
				  SELECT a.idPasien
						,2/*Alergi Makanan*/
						,@alergiMakanan
						,@idUserSession
					FROM dbo.transaksiPendaftaranPasien a
						 LEFT JOIN dbo.masterPasienAlergi b ON a.idPasien = b.idPasien AND alergiPasien = @alergiMakanan
				   WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.idAlergiPasien IS NULL;
		END

	SELECT 'Data diet pasien Berhasil Diupdate' AS respon, 1 AS responCode;
END