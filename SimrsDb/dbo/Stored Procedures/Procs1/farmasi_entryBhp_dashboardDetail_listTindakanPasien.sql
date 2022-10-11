-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_entryBhp_dashboardDetail_listTindakanPasien]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok tinyint = (SELECT idJenisStok FROM dbo.masterRuangan WHERE idRuangan = @idRuangan);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTindakanPasien, c.idPenjualanDetail, b.namaTarif, b.kelasTarif
		  ,b.nilaiTarif, c.namaBHP, c.tarifBHP, c.jmlTarifBHP, COALESCE(c.petugas, e.namaLengkap) AS petugas
 	  FROM dbo.transaksiTindakanPasien a
		   OUTER APPLY dbo.getInfo_tarif(a.idMasterTarif) b
		   OUTER APPLY dbo.getInfo_bhpTindakan(a.idTindakanPasien) c
		   INNER JOIN dbo.masterRuangan d ON a.idRuangan = d.idRuangan AND d.idJenisStok = @idJenisStok AND d.idPetugasEntryBhp = 2/*Petugas DEPO/TPO*/
		   LEFT JOIN dbo.masterUser e ON a.idUserEntry = e.idUser
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.BHP = 1/*Tindakan Dengan BHP*/
  ORDER BY a.idTindakanPasien;
END