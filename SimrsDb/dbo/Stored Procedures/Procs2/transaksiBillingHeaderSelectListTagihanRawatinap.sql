-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[transaksiBillingHeaderSelectListTagihanRawatinap]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*SELECT idPendaftaranPasien, idBilling, idJenisBayar, tglDaftarPasien, noRM, namaPasien, tglLahirPasien, umur, namaRuangan, idStatusPendaftaran 
		  ,jenisKelamin, namaPenanggungJawabPasien, total - (((total - discTunai) * discPersen / 100) + discTunai) As total
	  FROM (SELECT b.idPendaftaranPasien, a.idBilling, a.idJenisBayar, b.tglDaftarPasien, ba.noRM, ba.namaPasien, ba.tglLahirPasien, ba.umur, bb.namaRuangan
				  ,b.idStatusPendaftaran, ba.jenisKelamin, b.namaPenanggungJawabPasien, a.discPersen, a.discTunai, a.tglBuat
				  ,c.nilai + IsNull(d.tarifKamar, 0) + IsNull(e.tarifFarmasi, 0) As total
			  FROM dbo.transaksiBillingHeader a
				   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
						Inner Join dbo.dataPasien() ba On b.idPasien = ba.idPasien
						Inner Join dbo.masterRuangan bb On b.idRuangan = bb.idRuangan
				   Left Join (Select xa.idPendaftaranPasien, xa.idJenisBilling, Sum(Case xa.ditagih When 1 Then xb.nilai Else 0 End) As nilai
								 From dbo.transaksiTindakanPasien xa
									  Inner Join dbo.transaksiTindakanPasienDetail xb On xa.idTindakanPasien = xb.idTindakanPasien
							 Group By xa.idPendaftaranPasien, xa.idJenisBilling) c On a.idPendaftaranPasien = c.idPendaftaranPasien And a.idJenisBilling = c.idJenisBilling
				   Left Join (Select xa.idPendaftaranPasien
									 ,Sum(Case xa.ditagih When 1 Then xa.biayaInap Else 0 End) As tarifKamar
								 From dbo.transaksiPendaftaranPasienDetail xa
							 Group By xa.idPendaftaranPasien) d On a.idPendaftaranPasien = d.idPendaftaranPasien 
				   Left Join (Select Sum(xb.jumlah * Case xb.ditagih When 1 Then xb.hargaJual Else 0 End) As tarifFarmasi, xc.idPendaftaranPasien
								From dbo.farmasiPenjualanHeader xa 
									 Inner Join  dbo.farmasiPenjualanDetail xb On xa.idPenjualanHeader = xb.idPenjualanHeader
									 Inner Join dbo.farmasiResep xc On xa.idResep = xc.idResep
							Group By xc.idPendaftaranPasien) e On a.idPendaftaranPasien = e.idPendaftaranPasien
			 WHERE (a.tglBayar Is Null Or Convert(date, a.tglBayar) = Convert(date, GetDate())) And a.idJenisBilling = 6/*Billing Tagihan Rawat Inap*/) As dataSet
  ORDER BY tglBuat*/
END