-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRaNap_listBiayaKamarRawatInap]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT b.ruanganInap, b.kamarInap, b.tanggalMasuk, b.tanggalKeluar, b.lamaInap, b.biayaKamarRawatInap
	  FROM dbo.transaksiBillingHeader a 
		   OUTER APPLY dbo.getInfo_detailBiayaKamarRawatInap(a.idPendaftaranPasien) b
	 WHERE a.idBilling = @idBilling
  ORDER BY b.tanggalMasuk
END