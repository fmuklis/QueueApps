-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectStatusCreateBillingIGD]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*SELECT idPendaftaranPasien, idBilling, idJenisBayar, tglDaftarPasien, noRM, namaPasien, tglLahirPasien, umur, namaRuangan, namaJenisPendaftaran
		  ,total - (((total - discTunai) * discPersen / 100) + discTunai) As total
	  FROM (SELECT b.idPendaftaranPasien, a.idBilling, a.idJenisBayar, a.tanggalEntry, b.tglDaftarPasien, bb.noRM, bb.namaPasien, bb.tglLahirPasien
				  ,bb.umur, ba.namaRuangan, bc.namaJenisPendaftaran, c.biayaTindakan + IsNull(d.biayaBHP, 0) As total, a.discPersen, a.discTunai
			  FROM dbo.transaksiBillingHeader a
				   Inner Join transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
						Inner Join dbo.masterRuangan ba On b.idRuangan = ba.idRuangan
						Inner Join dbo.dataPasien() bb On b.idPasien = bb.idPasien
						Inner Join dbo.masterJenisPendaftaran bc On b.idJenisPendaftaran = bc.idJenisPendaftaran
				   Inner Join (Select xa.idPendaftaranPasien, xa.idJenisBilling
									 ,Sum(Case xa.ditagih When 1 Then xb.nilai Else 0 End) biayaTindakan
								 From dbo.transaksiTindakanPasien xa
									  Inner Join dbo.transaksiTindakanPasienDetail xb On xa.idTindakanPasien = xb.idTindakanPasien
							 Group By xa.idPendaftaranPasien, xa.idJenisBilling) c On a.idPendaftaranPasien = c.idPendaftaranPasien And a.idJenisBilling = c.idJenisBilling
				   Left Join (Select xa.idPendaftaranPasien, xa.idJenisBilling
									 ,Sum(xd.jumlah * Case xd.ditagih When 1 Then xd.hargaJual Else 0 End) As biayaBHP
								 From dbo.transaksiTindakanPasien xa
									  Left Join dbo.farmasiPenjualanHeader xc On xa.idTindakanPasien = xc.idTindakanPasien
									  Left Join dbo.farmasiPenjualanDetail xd On xc.idPenjualanHeader = xd.idPenjualanHeader
							 Group By xa.idPendaftaranPasien, xa.idJenisBilling) d On a.idPendaftaranPasien = d.idPendaftaranPasien And a.idJenisBilling = d.idJenisBilling
			 WHERE a.idJenisBilling = 5/*Billing Tagihan IGD*/ And (a.idJenisBayar Is Null Or (a.idJenisBayar Is Not Null And Convert(date, a.tglBayar) = Convert(date, GetDate())))) As dataSet
  ORDER BY tanggalEntry*/
END