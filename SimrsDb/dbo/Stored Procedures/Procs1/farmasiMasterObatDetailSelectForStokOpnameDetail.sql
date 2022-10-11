-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatDetailSelectForStokOpnameDetail]
	-- Add the parameters for the stored procedure here
	@idObatDosis int
	,@idUser int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisStok int = (Select b.idJenisStok From dbo.masterUser a
							   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan And a.idUser = @idUser);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT e.idObatDosis, b.namaJenisPenjaminInduk, a.kodeObat, c.namaJenisObat, d.namaSatuanObat, a.kronis
		  ,dbo.namaBarangFarmasi(e.idObatDosis) As namaObat
		  ,(Select Max(xa.hargaPokok) From dbo.farmasiMasterObatDetail xa Where e.idObatDosis = xa.idObatDosis) As hargaPokok
	  FROM dbo.farmasiMasterObat a
		   Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk b On a.idJenisPenjaminInduk = b.idJenisPenjaminInduk
		   Inner Join dbo.farmasiMasterObatJenis c On a.idJenisObat = c.idJenisObat
		   Inner Join dbo.farmasiMasterSatuanObat d On a.idSatuanObat = d.idSatuanObat
		   Inner Join dbo.farmasiMasterObatDosis e On a.idObat = e.idObat
	 WHERE e.idObatDosis = @idObatDosis
END