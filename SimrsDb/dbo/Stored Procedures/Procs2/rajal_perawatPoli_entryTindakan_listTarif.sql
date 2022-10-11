-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_listTarif]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarif, c.namaTarifHeader As namaTarif, a.Keterangan, c.BHP, d.namaSatuanTarif
		  ,Case
				When a.idSatuanTarif = 4
					 Then 0
				Else 1
			End As flagQty
	  FROM dbo.masterTarip a
		   Inner Join dbo.masterRuanganPelayanan b On a.idMasterPelayanan = b.idMasterPelayanan
		   Inner Join dbo.masterTarifHeader c On a.idMasterTarifHeader = c.idMasterTarifHeader
		   Inner Join dbo.masterSatuanTarif d On a.idSatuanTarif = d.idSatuanTarif
	 WHERE a.idKelas = 99/*Non Kelas*/ And b.idRuangan = @idRuangan
  ORDER BY c.namaTarifHeader
END