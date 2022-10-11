-- =============================================
-- Author:		komar
-- Create date: 22/11/2021
-- Description:	list alergi per pasien
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_permintaanGizi_alergiList] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idAlergiPasien, a.alergiPasien 
	  FROM dbo.masterPasienAlergi a
			JOIN transaksiPendaftaranPasien b ON a.idPasien = b.idPasien
	 WHERE b.idPendaftaranPasien = @idPendaftaranPasien
END