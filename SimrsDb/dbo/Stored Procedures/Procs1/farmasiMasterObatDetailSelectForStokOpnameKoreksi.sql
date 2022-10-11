-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatDetailSelectForStokOpnameKoreksi]
	-- Add the parameters for the stored procedure here
	@idObatDetail int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idObatDetail, a.idObatDosis, bb.namaJenisPenjaminInduk, ba.kodeObat, bc.namaJenisObat, bd.namaSatuanObat, ba.kronis
		  ,dbo.namaBarangFarmasi(a.idObatDosis) As namaObat, a.kodeBatch, a.tglExpired, a.hargaPokok, a.stok
	  FROM dbo.farmasiMasterObatDetail a
		   Inner Join dbo.farmasiMasterObatDosis b On a.idObatDosis = b.idObatDosis
				Inner Join dbo.farmasiMasterObat ba On b.idObat = ba.idObat
				Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk bb On ba.idJenisPenjaminInduk = bb.idJenisPenjaminInduk
				Inner Join dbo.farmasiMasterObatJenis bc On ba.idJenisObat = bc.idJenisObat
				Inner Join dbo.farmasiMasterSatuanObat bd On ba.idSatuanObat = bd.idSatuanObat
	 WHERE a.idObatDetail = @idObatDetail
END