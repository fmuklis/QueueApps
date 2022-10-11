-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_penjualan_entryPenjualan_riwayatFarmasi]
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien bigint = (SELECT idPendaftaranPasien FROM dbo.farmasiResep WHERE idResep = @idResep);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idResep, a.tglResep, a.noResep, c.NamaOperator, ba.namaObat, bb.jumlah, ba.namaSatuanObat
	  FROM dbo.farmasiResep a
		   INNER JOIN dbo.farmasiResepDetail b ON a.idResep = b.idResep
				OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
				LEFT JOIN dbo.farmasiPenjualanDetail bb ON b.idResepDetail = bb.idResepDetail
		   LEFT JOIN dbo.masterOperator c On a.idDokter = c.idOperator
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.idResep <> @idResep
  ORDER BY tglResep, a.idResep;
END