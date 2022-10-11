-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_permintaanGizi_alergiSave]
	-- Add the parameters for the stored procedure here
	@idUserSession bigint,
	@idPendaftaranPasien int,
	@keteranganDiet varchar(250),
	@jenisDiet varchar(250)

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

	SELECT 'Data diet pasien Berhasil Diupdate' AS respon, 1 AS responCode;
END