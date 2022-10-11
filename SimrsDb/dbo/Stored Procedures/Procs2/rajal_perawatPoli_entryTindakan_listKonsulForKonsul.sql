-- =============================================
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Menampilkan Detil Konsul Pasien (Kemana Saja Konsulnya)
-- =============================================
CREATE procedure [dbo].[rajal_perawatPoli_entryTindakan_listKonsulForKonsul]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTransaksiKonsul ,a.idStatusKonsul ,a.tglOrderKonsul ,a.idRuanganTujuan, a.jawaban, a.anjuran
		   ,b.idStatusPendaftaran, c.namaRuangan, d.statusKonsul AS namaStatusKonsul, ea.NamaOperator
	  FROM dbo.transaksiKonsul a
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
		   INNER JOIN dbo.masterRuangan c On a.idRuanganTujuan = c.idRuangan		
		   INNER JOIN dbo.masterStatusKonsul d On a.idStatusKonsul = d.idStatusKonsul
		   LEFT JOIN dbo.transaksiTindakanPasien e On a.idPendaftaranPasien = e.idPendaftaranPasien And a.idTransaksiKonsul = e.idTransaksiKonsul
				OUTER APPLY dbo.getInfo_operatorTindakan(e.idTindakanPasien) ea
	 WHERE b.idPendaftaranPasien = @idPendaftaranPasien
  ORDER BY a.tglOrderKonsul DESC;
END