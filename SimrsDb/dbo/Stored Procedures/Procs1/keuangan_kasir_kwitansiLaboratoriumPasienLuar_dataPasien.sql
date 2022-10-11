-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiLaboratoriumPasienLuar_dataPasien]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT bb.namaRuangan, ba.DPJP, ba.namaPasien, ba.namaJenisKelamin, ba.tglLahir, ba.umur, b.nomorLabor
		  ,a.kodeBayar, a.tglBayar, a.diskonTunai As diskonTunai, a.diskonPersen, d.namaLengkap As petugasKasir
		  ,dbo.calculator_totalTagihanLaboratorium(a.idBilling) As jumlahBayar, e.kota
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiOrder b On a.idOrder = b.idOrder
				OUTER APPLY dbo.getInfo_dataPasienLuar(a.idPasienLuar, b.tglOrder) ba
				LEFT JOIN dbo.masterRuangan bb On b.idRuanganTujuan = bb.idRuangan
		   LEFT JOIN dbo.masterUser d On a.idUserBayar = d.idUser
		   OUTER APPLY dbo.getInfo_dataRumahsakit() e
	 WHERE a.idBilling = @idBilling
END