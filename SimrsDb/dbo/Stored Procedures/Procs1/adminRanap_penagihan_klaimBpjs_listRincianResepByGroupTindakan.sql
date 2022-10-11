-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[adminRanap_penagihan_klaimBpjs_listRincianResepByGroupTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien bigint = (SELECT idPendaftaranPasien FROM dbo.transaksiBillingHeader WHERE idBilling = @idBilling)
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idPenjualanDetail, b.kategoriBarang, c.tglResep, cb.namaRuangan
		  ,b.namaBarang, ca.namaOperator, b.hargaJual, b.jumlah, b.jmlHarga
	  FROM dbo.farmasiPenjualanHeader a
		   OUTER APPLY dbo.getInfo_biayaPenjualanBarangFarmasi(a.idPenjualanHeader) b
		   LEFT JOIN dbo.farmasiResep c On a.idResep = c.idResep
				LEFT JOIN dbo.masterOperator ca On c.idDokter = ca.idOperator
				LEFT JOIN dbo.masterRuangan cb ON c.idRuangan = cb.idRuangan
	 WHERE c.idPendaftaranPasien = @idPendaftaranPasien
  ORDER BY b.kategoriBarangOrder, b.idPenjualanDetail
END