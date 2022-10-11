-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiBillingHeaderSelectDetailTagihanFarmasiRaNap]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT b.idPenjualanDetail, a.tglJual, cb.namaJenisStok As namaRuangan, c.noResep
		  ,dbo.namaBarangFarmasi(ba.idObatDosis) +' @Rp.'+ Convert(nvarchar(50), Case b.ditagih When 1 Then b.hargaJual Else 0 End) +'/'+ bd.namaSatuanObat As namaObat
		  , b.jumlah
		  ,Case b.ditagih
				When 1
					 Then b.hargaJual
				Else 0 
			End * b.jumlah As harga
	  FROM dbo.farmasiPenjualanHeader a 
		   Inner Join dbo.farmasiPenjualanDetail b On a.idPenjualanHeader = b.idPenjualanHeader
				Inner Join dbo.farmasiMasterObatDetail ba On b.idObatDetail = ba.idObatDetail
				Inner Join dbo.farmasiMasterObatDosis bb On ba.idObatDosis = bb.idObatDosis
				Inner Join dbo.farmasiMasterObat bc On bb.idObat = bc.idObat
				Inner Join dbo.farmasiMasterSatuanObat bd On bc.idSatuanObat = bd.idSatuanObat
		   Inner Join dbo.farmasiResep c On a.idResep = c.idResep
				Inner Join dbo.masterRuangan ca On c.idRuangan = ca.idRuangan
				Inner Join dbo.farmasiMasterObatJenisStok cb On ca.idJenisStok = cb.idJenisStok
	 WHERE a.idStatusPenjualan = 2/*Siap Bayar*/ And c.idPendaftaranPasien = @idPendaftaranPasien
  ORDER BY c.idResep, namaObat
END