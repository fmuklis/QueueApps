-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiUTDRS_dataPasien]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT bb.namaRuangan, ba.DPJP, b.nomorUtdrs,ba.namaPasien, ba.namaJenisKelamin, ba.tglLahir, ba.umur
		  ,a.kodeBayar, a.tglBayar, a.diskonTunai As diskonTunai, a.diskonPersen
		  ,e.jumlahBayar, d.namaLengkap As petugasKasir, f.kota
	  FROM dbo.transaksiBillingHeader a
		   Inner Join dbo.transaksiOrder b On a.idOrder = b.idOrder
				Outer Apply dbo.getInfo_dataPasienLuar(a.idPasienLuar, b.tglOrder) ba
				Inner Join dbo.masterRuangan bb On b.idRuanganTujuan = bb.idRuangan
		   Inner Join dbo.masterUser d On a.idUserBayar = d.idUser
		   Outer Apply (Select Sum(xa.jumlahBayar) As jumlahBayar 
						  From dbo.transaksiBillingPembayaran xa
						 Where xa.idBilling = a.idBilling) e
		   OUTER APPLY dbo.getInfo_dataRumahsakit() f
	 WHERE idBilling = @idBilling
END