-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_pembayaran_riwayat_listPembayaranResep]
	-- Add the parameters for the stored procedure here
	@periodeAwal date
	,@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idBilling, a.tglBayar, c.tglResep, ba.noRM, ba.namaPasien, ba.tglLahirPasien, ba.umur, ca.namaRuangan, cb.NamaOperator, COALESCE(c.nomorResep, c.noResep) AS noResep
		  ,a.idJenisBayar, a.idPendaftaranPasien
		  ,dbo.calculator_totalTagihanResep(a.idBilling) as nilaiBayar
	  FROM dbo.transaksiBillingHeader a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba 
		   Inner Join dbo.farmasiResep c On a.idResep = c.idResep
				Inner Join dbo.masterRuangan ca On c.idRuangan = ca.idRuangan
				Inner Join dbo.masterOperator cb On c.idDokter = cb.idOperator
	 WHERE a.idStatusBayar=10 And Convert(date, a.tglBayar) Between @periodeAwal And @periodeAkhir
  ORDER BY a.tglBayar
END