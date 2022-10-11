-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_selectUgd]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarif ,c.namaTarifHeader As namaTarif, a.Keterangan, d.namaSatuanTarif
		  ,b.idRuangan, c.BHP
		  ,CASE
			WHEN a.idSatuanTarif = 4
				THEN 0
			ELSE 1
		   END AS flagQty
	  FROM dbo.masterTarip a
		   Inner Join dbo.masterRuanganPelayanan b On a.idMasterPelayanan = b.idMasterPelayanan
		   Inner Join dbo.masterTarifHeader c On a.idMasterTarifHeader = c.idMasterTarifHeader
		   Inner Join dbo.masterSatuanTarif d On a.idSatuanTarif = d.idSatuanTarif
	 WHERE a.idKelas = 99/*Non Kelas*/ And b.idRuangan = 1/*IGD*/
  ORDER BY c.namaTarifHeader
END