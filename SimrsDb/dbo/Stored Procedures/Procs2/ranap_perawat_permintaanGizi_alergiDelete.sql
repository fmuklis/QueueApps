-- =============================================
-- Author:		komar
-- Create date: 22/11/2021
-- Description:	list alergi per pasien
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_permintaanGizi_alergiDelete] 
	-- Add the parameters for the stored procedure here
	@userIdSession int,
	@idPendaftaranPasien int,
	@idAlergiPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE a
	  FROM [dbo].[masterPasienAlergi] a
	       INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPasien = b.idPasien
	 WHERE a.idAlergiPasien = @idAlergiPasien AND b.idPendaftaranPasien = @idPendaftaranPasien;
				   
	SELECT 1 AS responCode, 'Data alergi makanan pasien berhasil dihapus' AS respon;

END