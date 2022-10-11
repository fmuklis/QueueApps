-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_laporan_kendaliStok_listBarangFarmasi]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT b.idObatDosis, c.namaBarang
	  FROM dbo.farmasiJurnalStok a
		   INNER JOIN dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
		   OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) c
	 WHERE CAST(a.tanggalEntry AS date) BETWEEN @periodeAwal AND @periodeAkhir
  ORDER BY c.namaBarang
END