CREATE procedure [dbo].[masterTarip_SelectByID]
	@idMasterTarif int
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT   a.idMasterTarifDetail,a.idMasterKatagoriTarip,a.idMasterTarip,a.tarip
			,ba.namaMasterPelayanan,bb.namaKelas,bc.namaJenisTarif,bd.namaSatuanTarif
			,SUM(a.tarip) JumlahTarip
	FROM masterTaripDetail a 
			Inner Join [dbo].[masterTarip] b on b.idMasterTarif = a.idMasterTarip
				Inner Join dbo.masterPelayanan ba On b.idMasterPelayanan=ba.idMasterPelayanan
				Inner Join dbo.masterKelas bb On b.idKelas=bb.idKelas
				Inner Join dbo.masterJenisTarif bc On b.idJenisTarif=bc.idJenisTarif
				Inner Join dbo.masterSatuanTarif bd On b.idSatuanTarif=bd.idSatuanTarif
			Inner Join [dbo].[masterTarifKatagori] c on a.idMasterKatagoriTarip = c.idMasterKatagoriTarip
	WHERE b.idMasterTarif = @idMasterTarif
	GROUP BY a.idMasterTarifDetail,a.idMasterTarip,a.idMasterKatagoriTarip,a.tarip
			,b.idMasterTarif,b.namaTarif,b.keterangan,b.idMasterPelayanan,b.idKelas,b.idJenisTarif,b.idSatuanTarif,b.idPeriodeTarip
			,ba.namaMasterPelayanan,bb.namaKelas,bc.namaJenisTarif,bd.namaSatuanTarif
			,c.idMasterKatagoriTarip,c.namaMasterKatagoriTarif,c.namaMasterKatagoriInProgram,c.idMasterKatagoriJenis
	ORDER BY ba.namaMasterPelayanan,b.namaTarif,bc.namaJenisTarif,bb.namaKelas
END