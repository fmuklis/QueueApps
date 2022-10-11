-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameCetak_listItemStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpname bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT c.jenisStokOpname, ba.namaBarang, a.kodeBatch, a.tglExpired, a.hargaPokok, a.jumlahAwal, a.jumlahStokOpname
			  ,ba.satuanBarang, a.keterangan
		  FROM dbo.farmasiStokOpnameDetail a
			   LEFT JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
					OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
			   LEFT JOIN dbo.farmasiMasterJenisStokOpname c ON a.idJenisStokOpname = c.idJenisStokOpname
		 WHERE a.idStokOpname = @idStokOpname
	  ORDER BY jenisStokOpname DESC, ba.namaBarang
END