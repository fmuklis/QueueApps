-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Menampilkan Detil Konsul Pasien (Kemana Saja Konsulnya)
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_selectKonsulDetail]
	-- Add the parameters for the stored procedure here
	@idTransaksiKonsul int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tglOrderKonsul, a.idRuanganTujuan, b.namaRuangan, c.statusKonsul AS namaStatusKonsul, a.alasan, a.itemKonsul
	  FROM dbo.transaksiKonsul a
		   Inner Join dbo.masterRuangan b On a.idRuanganTujuan = b.idRuangan
		   Inner Join dbo.masterStatusKonsul c On a.idStatusKonsul = c.idStatusKonsul
	 WHERE idTransaksiKonsul = @idTransaksiKonsul;
END