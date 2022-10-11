-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_penjualan_entryPenjualan_listItemPenjualan]
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien bigint = (SELECT idPendaftaranPasien FROM dbo.farmasiResep WHERE idResep = @idResep);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idPenjualanDetail, c.namaBarang, ba.kodeBatch, b.jumlah, c.namaSatuanObat
		  ,bb.hargaJual, bb.jmlHarga
	  FROM dbo.farmasiResepDetail a
		   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idResepDetail = b.idResepDetail
				INNER JOIN dbo.farmasiMasterObatDetail ba On b.idObatDetail = ba.idObatDetail
				OUTER APPLY dbo.getInfo_biayaPenjualanResep(b.idPenjualanDetail) bb
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) c
	 WHERE a.idResep = @idResep
  ORDER BY c.namaBarang;
END