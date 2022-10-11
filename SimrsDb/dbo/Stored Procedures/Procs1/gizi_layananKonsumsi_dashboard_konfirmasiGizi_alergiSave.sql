-- =============================================
-- Author:		Komar
-- CREATE date: 23/11/2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[gizi_layananKonsumsi_dashboard_konfirmasiGizi_alergiSave]
	-- Add the parameters for the stored procedure here
	@idUserSession bigint,
	@idPendaftaranPasien int,
	@keteranganDiet varchar(250),
	@jenisDiet varchar(250),
	@idLayananGiziPasien int

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

	 IF(@idLayananGiziPasien <> 0)
		BEGIN
			UPDATE dbo.layananGiziPasien
			   SET jenisDiet = @jenisDiet
				  ,keteranganDiet = @keteranganDiet
			 WHERE idLayananGiziPasien = @idLayananGiziPasien;
		END

	SELECT 'Data diet pasien Berhasil Diupdate' AS respon, 1 AS responCode;
END