-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Menampilkan Detil Konsul Pasien (Kemana Saja Konsulnya)
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_listKonsul]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTransaksiKonsul ,a.idStatusKonsul ,a.tglOrderKonsul ,a.idRuanganTujuan, a.jawaban, a.anjuran
		   ,b.idStatusPendaftaran
		   ,c.namaRuangan
		   ,d.statusKonsul AS namaStatusKonsul
		   ,eb.NamaOperator
	  FROM dbo.transaksiKonsul a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
		   Inner Join dbo.masterRuangan c On a.idRuanganTujuan = c.idRuangan		
		   Inner Join dbo.masterStatusKonsul d On a.idStatusKonsul = d.idStatusKonsul
		   left Join dbo.transaksiTindakanPasien e On a.idPendaftaranPasien = e.idPendaftaranPasien And a.idRuanganTujuan = e.idRuangan
			left Join dbo.transaksiTindakanPasienOperator ea On e.idTindakanPasien = ea.idTindakanPasien
				left Join dbo.masterOperator eb On ea.idOperator = eb.idOperator
	 WHERE b.idPendaftaranPasien = @idPendaftaranPasien
  ORDER BY a.tglOrderKonsul DESC;
END