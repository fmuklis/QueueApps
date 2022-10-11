-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Penjualan E-Resep
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_pemakaianInternal_entryPemakaianInternalDetail_listStokFarmasi]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@search varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok tinyint = (SELECT idJenisStok FROM dbo.masterRuangan WHERE idRuangan = @idRuangan);

	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT TOP 100 a.idObatDetail, c.namaBarang, a.kodeBatch, a.tglExpired, a.stok, c.namaSatuanObat, b.namaJenisStok AS lokasiStok
		  ,CASE
				WHEN a.idJenisStok = @idJenisStok
					 THEN 1
				ELSE 0
			END AS flagPilih
	  FROM dbo.farmasiMasterObatDetail a
	 	   INNER JOIN dbo.farmasiMasterObatJenisStok b ON a.idJenisStok = b.idJenisStok
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) c
	 WHERE a.stok >= 1 AND a.tglExpired > CAST(GETDATE() AS date) AND a.idJenisStok <> 6/*BHP RUangan*/
		   AND a.idRuangan IS NULL AND c.namaBarang LIKE '%'+ @search +'%'
  ORDER BY c.namaBarang, flagPilih DESC, tglExpired
END