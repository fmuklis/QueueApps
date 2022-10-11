-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiPenjualanHeaderSelectByIdResep]
	-- Add the parameters for the stored procedure here
	@idResep int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idPenjualanDetail, a.idPenjualanHeader, a.tglJual, a.tglEntry, a.idStatusPenjualan, ce.namaSatuanObat
		  ,ca.idRacikan, b.jumlah, b.hargaJual As hargaJualSatuan, b.jumlah * b.hargaJual As Harga
		  ,Case
				When ca.idRacikan = 0
					 Then 'Non Racikan'
				Else 'Racikan'
			End As jenisObat
		  ,dbo.namaBarangFarmasi(ca.idObatDosis) As namaObat
		  ,Convert(nvarchar(10), ca.kaliKonsumsi) +' X '+ ca.jumlahKonsumsi +' '+ cg.namaTakaran +' '+ cf.namaResepWaktu As aturanPakai
	  FROM dbo.farmasiPenjualanHeader a 
		   Inner Join dbo.farmasiPenjualanDetail b On a.idPenjualanHeader = b.idPenjualanHeader
		   Inner Join dbo.farmasiResep c On a.idResep = c.idResep
				Inner Join dbo.farmasiResepDetail ca On b.idResepDetail = ca.idResepDetail And c.idResep = ca.idResep
				Inner Join dbo.farmasiResepTakaran cb On ca.idTakaran = cb.idTakaran
				Inner Join dbo.farmasiMasterObatDosis cc On ca.idObatDosis = cc.idObatDosis
				Inner Join dbo.farmasiMasterObat cd On cc.idObat = cd.idObat
				Inner Join dbo.farmasiMasterSatuanObat ce On cd.idSatuanObat = ce.idSatuanObat
				Left Join dbo.farmasiResepWaktu cf On ca.idResepWaktu = cf.idResepWaktu
				LEft Join dbo.farmasiResepTakaran cg On ca.idTakaran = cg.idTakaran
	 WHERE a.idResep = @idResep
END