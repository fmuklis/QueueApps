-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingUTDRS_dataPasien]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.namaPasien, ba.namaJenisKelamin, ba.tglLahir, ba.umur, ba.alamatPasien, ba.tlp, ba.DPJP, a.kodeBayar
		  ,b.nomorUtdrs, bb.namaRuangan, d.discountTotal, a.diskonTunai As diskonTunai, a.diskonPersen
		  ,dbo.calculator_totalTagihanUtdrs(a.idBilling) As jumlahBayar 
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiOrder b On a.idOrder = b.idOrder
				OUTER APPLY dbo.getInfo_dataPasienLuar(a.idPasienLuar, b.tglOrder) ba
				LEFT JOIN dbo.masterRuangan bb On b.idRuanganAsal = bb.idRuangan
		   OUTER APPLY (SELECT discountTotal 
						  FROM dbo.sistemKonfigurasiKasir) d
	 WHERE a.idBilling = @idBilling
END