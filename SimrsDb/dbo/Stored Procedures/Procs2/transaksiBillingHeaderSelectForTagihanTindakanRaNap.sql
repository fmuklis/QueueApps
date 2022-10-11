-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiBillingHeaderSelectForTagihanTindakanRaNap]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT bc.namaRuangan, bb.namaTarifHeader As namaTarif, b.tglTindakan, bh.NamaOperator, a.tglBayar, c.namaLengkap, Sum(bf.nilai) As Tarif
	  FROM dbo.transaksiBillingHeader a
	 	   Inner Join dbo.transaksiTindakanPasien b On a.idJenisBilling = b.idJenisBilling And a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.masterTarip ba On b.idMasterTarif = ba.idMasterTarif
				Inner Join dbo.masterTarifHeader bb On ba.idMasterTarifHeader = bb.idMasterTarifHeader
				Inner Join dbo.masterRuangan bc On b.idRuangan = bc.idRuangan
				Inner Join dbo.transaksiTindakanPasienDetail bf On b.idTindakanPasien = bf.idTindakanPasien
				Left Join dbo.transaksiTindakanPasienOperator bg On b.idTindakanPasien = bg.idTindakanPasien And bg.idMasterKatagoriTarip = 1
					Left Join dbo.masterOperator bh On bg.idOperator = bh.idOperator			
		   Left Join dbo.masterUser c On a.idUserBayar = c.idUser
				/*Inner Join (Select * From dbo.dataPasien()) ca On c.idPasien = ca.idPasien
				Inner join dbo.masterRuangan cb on c.idRuangan = cb.idRuangan*/
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien And a.idJenisBilling = 6/*Billing RaNap*/
  GROUP BY bb.namaTarifHeader, bc.namaRuangan, b.tglTindakan, bh.NamaOperator, a.tglBayar, c.namaLengkap
     UNION
	SELECT 'Instalasi Rawat Inap' As namaRuangan, 'Biaya Kamar '+ bb.namaKelas +' @ '+ Convert(nvarchar(50), Sum(b.lamaInap)) +' Hari' As namaTarif, a.tglKeluarPasien As tglTindakan, '' As NamaOperator, c.tglBayar, ca.namaLengkap, Sum(b.biayaInap) As Tarif
	  FROM dbo.transaksiPendaftaranPasien a
		   Inner Join dbo.transaksiPendaftaranPasienDetail b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.masterTarifKamar ba On b.idMasterTarifKamar = ba.idMasterTarifKamar
				Inner Join dbo.masterKelas bb On ba.idKelas = bb.idKelas
		   Inner Join dbo.transaksiBillingHeader c On a.idPendaftaranPasien = c.idPendaftaranPasien And c.idJenisBilling = 6/*Billing Tagihan Rawat Inap*/
				Inner Join dbo.masterUser ca On c.idUserBayar = ca.idUser
	 WHERE c.idPendaftaranPasien = @idPendaftaranPasien
  GROUP BY a.tglKeluarPasien, bb.namaKelas, c.tglBayar, ca.namaLengkap
END