-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_penjualan_entryPenjualan_listItemResepPasien]
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idResepDetail, a.idObatDosis, b.tanggalEntry, c.namaBarang, a.jumlah, c.namaSatuanObat
		  ,a.idRacikan, d.jenisResep, d.aturanPakai, d.keterangan
	  FROM dbo.farmasiResepDetail a
		   INNER JOIN dbo.farmasiResep b On a.idResep = b.idResep
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) c
		   OUTER APPLY dbo.getInfo_aturanPakai(a.idResepDetail) d
	 WHERE a.idResep = @idResep
  ORDER BY c.namaBarang
END