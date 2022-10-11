-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiBillingHeaderSelectForCetakTagihanRaNap]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT b.tglTindakan, bc.Alias, bb.namaTarifHeader As namaTarif, a.tglBayar, c.namaLengkap, Sum(bf.nilai) As Tarif
	  FROM dbo.transaksiBillingHeader a
	 	   Inner Join dbo.transaksiTindakanPasien b On a.idJenisBilling = b.idJenisBilling And a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.masterTarip ba On b.idMasterTarif = ba.idMasterTarif
				Inner Join dbo.masterTarifHeader bb On ba.idMasterTarifHeader = bb.idMasterTarifHeader
				Inner Join dbo.masterRuangan bc On b.idRuangan = bc.idRuangan
				Inner Join dbo.transaksiTindakanPasienDetail bf On b.idTindakanPasien = bf.idTindakanPasien
				Left Join dbo.transaksiTindakanPasienOperator bg On b.idTindakanPasien = bg.idTindakanPasien And bg.idMasterKatagoriTarip = 1
					Left Join dbo.masterOperator bh On bg.idOperator = bh.idOperator			
		   Inner Join dbo.masterUser c On a.idUserBayar = c.idUser
	 WHERE a.idBilling = @idBilling
  GROUP BY bb.namaTarifHeader, bc.namaRuangan, bc.Alias, b.tglTindakan, bh.NamaOperator, a.tglBayar, c.namaLengkap
     UNION
	SELECT a.tglKeluarPasien, 'IRI' As SortNameRuangan, 'Biaya Kamar '+ bb.namaKelas +' @ '+ Convert(nvarchar(50), Sum(b.lamaInap)) +' Hari' As namaTarifHeader, c.tglBayar, ca.namaLengkap, Sum(b.biayaInap) As Tarif
	  FROM dbo.transaksiPendaftaranPasien a
		   Inner Join dbo.transaksiPendaftaranPasienDetail b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.masterTarifKamar ba On b.idMasterTarifKamar = ba.idMasterTarifKamar
				Inner Join dbo.masterKelas bb On ba.idKelas = bb.idKelas
		   Inner Join dbo.transaksiBillingHeader c On a.idPendaftaranPasien = c.idPendaftaranPasien And c.idJenisBilling = 6/*Billing Tagihan Rawat Inap*/
				Inner Join dbo.masterUser ca On c.idUserBayar = ca.idUser
	 WHERE c.idBilling = @idBilling
  GROUP BY a.tglKeluarPasien, bb.namaKelas, c.tglBayar, ca.namaLengkap
END