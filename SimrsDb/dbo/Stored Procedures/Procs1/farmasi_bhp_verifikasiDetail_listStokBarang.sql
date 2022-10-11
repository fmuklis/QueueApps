-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_verifikasiDetail_listStokBarang]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@idItemOrderMutasi bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idObatDetail, c.namaBarang, b.kodeBatch, b.tglExpired, b.stok, c.namaSatuanObat
	  FROM dbo.farmasiMutasiOrderItem a
		   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDosis = b.idObatDosis AND b.tglExpired > GETDATE() AND b.stok > 0
				INNER JOIN dbo.masterRuangan ba ON b.idJenisStok = ba.idJenisStok AND ba.idRuangan = @idRuangan
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) c
	 WHERE a.idItemOrderMutasi = @idItemOrderMutasi
  ORDER BY c.namaBarang
END