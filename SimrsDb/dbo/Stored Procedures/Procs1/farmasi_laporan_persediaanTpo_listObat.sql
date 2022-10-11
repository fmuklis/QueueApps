-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_laporan_persediaanTpo_listObat]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisStok int = (Select idJenisStok From dbo.masterRuangan Where idRuangan = @idRuangan);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT b.idObatDosis, ba.namaObat
	  FROM dbo.farmasiJurnalStok a
		   INNER JOIN dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
				OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
	 WHERE CAST(a.tanggalEntry AS date) BETWEEN @periodeAwal AND @periodeAkhir AND b.idJenisStok = @idJenisStok
  ORDER BY namaObat
END