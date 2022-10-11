CREATE PROCEDURE [dbo].[masterTaripSelectByidMasterTarifHeader]
	@idMasterTarifHeader int
AS
BEGIN

	SET NOCOUNT ON;

	SELECT g.idMasterTarifDetail, g.idMasterKatagoriTarip, g.idMasterTarip, g.tarip, g.tarip As JumlahTarip
		  ,b.idMasterPelayanan, b.namaMasterPelayanan, c.namaKelas, d.namaJenisTarif, e.namaSatuanTarif
		  ,c.*, f.namaTarifHeader, a.idJenisTarif, a.idSatuanTarif
	  FROM [dbo].[masterTarip] a
		   Inner Join dbo.masterPelayanan b On a.idMasterPelayanan = b.idMasterPelayanan
		   Inner Join dbo.masterKelas c On a.idKelas = c.idKelas
		   Inner Join dbo.masterJenisTarif d On a.idJenisTarif = d.idJenisTarif
		   Inner Join dbo.masterSatuanTarif e On a.idSatuanTarif = e.idSatuanTarif
		   Inner Join dbo.masterTarifHeader f On a.idMasterTarifHeader = f.idMasterTarifHeader
		   Inner Join dbo.masterTaripDetail g On a.idMasterTarif = g.idMasterTarip
				Inner Join [dbo].[masterTarifKatagori] ga on g.idMasterKatagoriTarip = ga.idMasterKatagoriTarip
	 WHERE a.idMasterTarifHeader = @idMasterTarifHeader
 ORDER BY b.namaMasterPelayanan, f.namaTarifHeader, d.namaJenisTarif, c.namaKelas
END