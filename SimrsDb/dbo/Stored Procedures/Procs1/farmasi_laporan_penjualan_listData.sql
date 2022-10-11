-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_laporan_penjualan_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date
	,@periodeAkhir date
	,@idJenisStok int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT dbo.namaBarangFarmasi(b.idObatDosis) As namaObat
		  ,bb.noRM, bb.namaPasien, bb.NamaOperator, bb.jumlah, c.namaSatuanObat
	  FROM dbo.farmasiMasterObat a
		   Inner Join dbo.farmasiMasterObatDosis b On a.idObat = b.idObat
				Inner Join (Select xc.idObatDosis, xb.noRM, xb.namaPasien,  xc.NamaOperator, xc.jumlah
							  From dbo.transaksiPendaftaranPasien xa
								   OUTER APPLY dbo.getInfo_dataPasien(xa.idPasien) xb
								   Inner Join (Select ya.idPendaftaranPasien, yd.idObatDosis, ye.NamaOperator, Sum(yc.jumlah) As jumlah
												 From dbo.farmasiResep ya
													  Inner Join dbo.farmasiPenjualanHeader yb On ya.idResep = yb.idResep
													  Inner Join dbo.farmasiPenjualanDetail yc On yb.idPenjualanHeader = yc.idPenjualanHeader
													  Inner Join dbo.farmasiMasterObatDetail yd On yc.idObatDetail = yd.idObatDetail
													  Inner Join dbo.masterOperator ye On ya.idDokter = ye.idOperator
											    Where Convert(date, yb.tglJual) Between @periodeAwal And @periodeAkhir And yd.idJenisStok = @idJenisStok
											 Group By ya.idPendaftaranPasien, yd.idObatDosis, ye.NamaOperator
											    Union All
											   Select ya.idPendaftaranPasien, yd.idObatDosis, yg.NamaOperator, Sum(yc.jumlah) As jumlah
											     From dbo.transaksiTindakanPasien ya
													  Inner Join dbo.farmasiPenjualanDetail yc On ya.idTindakanPasien = yc.idTindakanPasien
													  Inner Join dbo.farmasiMasterObatDetail yd On yc.idObatDetail = yd.idObatDetail
													  Inner Join dbo.transaksiTindakanPasienDetail ye On ya.idTindakanPasien = ye.idTindakanPasien And ye.idMasterKatagoriTarip = 1/*Jasa Dokter*/
													  Left Join dbo.transaksiTindakanPasienOperator yf On ye.idTindakanPasienDetail = yf.idTindakanPasienDetail
													  Left Join dbo.masterOperator yg On yf.idOperator = yg.idOperator
											    Where Convert(date, ya.tglTindakan) Between @periodeAwal And @periodeAkhir And yd.idJenisStok = @idJenisStok
											 Group By ya.idPendaftaranPasien, yd.idObatDosis, yg.NamaOperator) xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 ) bb On b.idObatDosis = bb.idObatDosis
		   Inner Join dbo.farmasiMasterSatuanObat c On a.idSatuanObat = c.idSatuanObat
  ORDER BY a.namaObat, bb.NamaOperator
END