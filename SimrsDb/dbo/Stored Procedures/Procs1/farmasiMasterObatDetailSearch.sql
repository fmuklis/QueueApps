-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatDetailSearch]
	-- Add the parameters for the stored procedure here
	@idJenisPenjaminInduk int
	,@idRuangan int
	,@search nvarchar(50)

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisStok int = (Select idJenisStok From dbo.masterRuangan Where idRuangan = @idRuangan);

	SET NOCOUNT ON;
    DECLARE @where NVARCHAR(MAX) = Case
										When @search Is Not Null
											 Then 'WHERE namaObat like '''+'%'+@search+'%'' Or namaJenisObat like '''+'%'+@search+'%'' Or kodeObat like '''+'%'+@search+'%'''
										Else ''
									End

    -- Insert statements for procedure here
	EXEC('SELECT a.idObatDetail, dbo.namaBarangFarmasi(a.idObatDosis) As namaObat, a.kodeBatch, a.tglExpired, a.stok, bb.namaJenisPenjaminInduk
				,a.idJenisStok, c.namaJenisStok, bd.namaSatuanObat
			FROM dbo.farmasiMasterObatDetail a
				 Inner Join dbo.farmasiMasterObatDosis b On a.idObatDosis = b.idObatDosis
						Inner Join dbo.farmasiMasterObat ba On b.idObat = ba.idObat
						Left Join dbo.masterJenisPenjaminPembayaranPasienInduk bb On ba.idJenisPenjaminInduk = bb.idJenisPenjaminInduk
						Left Join dbo.farmasiMasterObatJenis bc On ba.idJenisOBat = bc.idJenisOBat
						Left Join dbo.farmasiMasterSatuanObat bd On ba.idSatuanObat = bd.idSatuanObat
				 Inner Join dbo.farmasiMasterObatJenisStok c On a.idJenisStok = c.idJenisStok '+ @where +'
		ORDER BY ba.namaObat, a.tglExpired');
END