-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_penjualan_entryPenjualan_listStokFarmasiByidResepDetail]
	-- Add the parameters for the stored procedure here
	@idResepDetail bigint,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok int = (SELECT b.idJenisStok FROM dbo.masterUser a
									   INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan
								 WHERE a.idUser = @idUserEntry)
		   ,@idObatDosis bigint
		   ,@sisaTebus decimal(18,2);

	SELECT @idObatDosis = a.idObatDosis, @sisaTebus = a.jumlah - ISNULL(b.jmlTebus, 0)
	  FROM dbo.farmasiResepDetail a
		   OUTER APPLY(SELECT SUM(xa.jumlah) AS jmlTebus
						 FROM dbo.farmasiPenjualanDetail xa
						WHERE xa.idResepDetail = a.idResepDetail) b
	 WHERE a.idResepDetail = @idResepDetail;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idObatDetail, b.namaBarang, a.kodeBatch, a.tglExpired, a.stok, b.namaSatuanObat
		  ,a.idJenisStok, c.namaJenisStok, @sisaTebus AS sisaTebus
		  ,CASE
				WHEN a.idJenisStok = @idJenisStok
					 THEN 1
				ELSE 0
			END AS btnPilih
	  FROM dbo.farmasiMasterObatDetail a
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
		   INNER JOIN dbo.farmasiMasterObatJenisStok c ON a.idJenisStok = c.idJenisStok
	 WHERE a.idObatDosis = @idObatDosis AND a.stok > 0 AND a.tglExpired > GETDATE()
		   AND c.idJenisStok <> 6/*Stok BHP*/
  ORDER BY b.namaBarang, a.tglExpired, btnPilih
END