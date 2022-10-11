-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_pembayaran_riwayat_listPembayaranLaboratorium]
	-- Add the parameters for the stored procedure here
	@periodeAwal date
	,@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idBilling, a.idPendaftaranPasien, c.tglOrder, ba.noRM, ba.namaPasien, ba.tglLahirPasien, ba.umur, cb.NamaOperator
		  ,a.tglBayar
		  ,dbo.calculator_totalTagihanLaboratorium(a.idBilling) as nilaiBayar
	  FROM dbo.transaksiBillingHeader a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER Apply (Select * From dbo.getInfo_dataPasien(b.idPasien)) as ba
		   Inner Join dbo.transaksiOrder c On a.idOrder = c.idOrder
				--Inner Join dbo.masterRuangan ca On c.idRuanganTujuan = ca.idRuangan
				Inner Join dbo.masterOperator cb On c.idDokter = cb.idOperator
	 WHERE c.idRuanganTujuan=21 And a.idJenisBayar Is Not Null And Convert(date, a.tglBayar) Between @periodeAwal And @periodeAkhir
  ORDER BY a.tglBayar
END