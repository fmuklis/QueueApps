-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiRaNap_listBiayaKamarRawatInap]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.kamarInap, b.tanggalMasuk, b.tanggalKeluar, b.tarifKamar, b.lamaInap, b.jmlBiayaInap, b.keterangan
	  FROM dbo.transaksiBillingHeader a 
		   OUTER APPLY dbo.getInfo_listBiayaKamarRawatInap(a.idPendaftaranPasien) b
	 WHERE a.idBilling = @idBilling
  ORDER BY b.tanggalMasuk
END