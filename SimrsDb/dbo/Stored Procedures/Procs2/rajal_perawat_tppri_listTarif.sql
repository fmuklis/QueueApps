-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].rajal_perawat_tppri_listTarif
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarif, c.namaTarif, a.Keterangan, c.BHP, c.satuanTarif
		  ,c.flagQty
	  FROM dbo.masterTarip a
		   INNER JOIN dbo.masterRuanganPelayanan b ON a.idMasterPelayanan = b.idMasterPelayanan
		   OUTER APPLY dbo.getInfo_tarif(a.idMasterTarif) c
	 WHERE a.idKelas = 99/*Non Kelas*/ AND b.idRuangan = @idRuangan
  ORDER BY c.namaTarif
END