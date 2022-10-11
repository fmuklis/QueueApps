-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRadiologiPasienLuar_dataPasien]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.namaPasien, ba.namaJenisKelamin, ba.tglLahir, ba.umur, ba.alamatPasien, ba.tlp, ba.DPJP, a.kodeBayar
		  ,bb.namaRuangan, d.discountTotal, a.diskonTunai As diskonTunai, a.diskonPersen, b.nomorRadiologi
		  ,dbo.calculator_totalTagihanRadiologi(a.idBilling) AS jumlahBayar 
	  FROM dbo.transaksiBillingHeader a
		   Inner Join dbo.transaksiOrder b On a.idOrder = b.idOrder
				Outer Apply dbo.getInfo_dataPasienLuar(a.idPasienLuar, b.tglOrder) ba
				Left Join dbo.masterRuangan bb On b.idRuanganAsal = bb.idRuangan
		   Outer Apply(Select discountTotal 
						 From dbo.sistemKonfigurasiKasir) d
	 WHERE idBilling = @idBilling
END