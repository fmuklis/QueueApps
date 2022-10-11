-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_master_masterBarangFarmasi_listStokFarmasiByIdObatDosis]
	-- Add the parameters for the stored procedure here
	@idObatDosis int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idObatDetail, b.namaBarang, a.kodeBatch, a.tglExpired, a.stok, a.hargaPokok, dbo.calculator_hargaJualBarangFarmasi(a.idObatDetail) AS hargaJual
		  ,CASE
			    WHEN ISNULL(a.idJenisStok, 6) = 6/*BHP*/
					 THEN 'BHP '+ d.namaRuangan
			    ELSE c.namaJenisStok
		    END AS lokasiStok
	  FROM dbo.farmasiMasterObatDetail a
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
		   LEFT JOIN dbo.farmasiMasterObatJenisStok c ON a.idJenisStok = c.idJenisStok
		   LEFT JOIN dbo.masterRuangan d ON a.idRuangan = d.idRuangan
	 WHERE a.idObatDosis = @idObatDosis AND a.tglExpired > CAST(GETDATE() AS date) AND a.stok >= 1
  ORDER BY a.tglExpired, lokasiStok
END