-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiResepSelectForRiwayatFarmasi] 
	-- Add the parameters for the stored procedure here
	@idResep int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPendaftaranPasien int = (Select idPendaftaranPasien From dbo.farmasiResep Where idResep = @idResep);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idResep, tglResep, noResep, NamaOperator, dbo.namaBarangFarmasi(bb.idObatDosis) As namaObat, Sum(ba.jumlah) As jumlah, be.namaSatuanObat
	  FROM dbo.farmasiResep a
		   Inner Join dbo.farmasiPenjualanHeader b On a.idResep = b.idResep
				Inner Join dbo.farmasiPenjualanDetail ba On b.idPenjualanHeader = ba.idPenjualanHeader
				Inner Join dbo.farmasiMasterObatDetail bb On ba.idObatDetail = bb.idObatDetail
				Inner Join dbo.farmasiMasterObatDosis bc On bb.idObatDosis = bc.idObatDosis
				Inner Join dbo.farmasiMasterObat bd On bc.idObat = bd.idObat
				Inner Join dbo.farmasiMasterSatuanObat be On bd.idSatuanObat = be.idSatuanObat
		   Inner Join dbo.masterOperator c On a.idDokter = c.idOperator
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien And a.idResep <> @idResep
  GROUP BY a.idResep, tglResep, noResep, NamaOperator, bb.idObatDosis, be.namaSatuanObat
  ORDER BY tglResep, a.idResep;
END