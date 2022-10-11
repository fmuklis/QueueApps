-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Order Pemeriksaan
-- =============================================
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_dashboard_listRequest]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrder, a.tglOrder, ba.noRM, ba.namaPasien, ba.tglLahirPasien, ba.umur, c.Alias
		  ,CASE
				WHEN a.idStatusOrder = 1/*Request Pemeriksaan*/
					 THEN 1
				ELSE 0
			END AS btnTerima
		  ,CASE
				WHEN a.idStatusOrder = 1/*Request Pemeriksaan*/
					 THEN 1
				ELSE 0
			END AS btnBatal
		  ,CASE
				WHEN a.idStatusOrder = 10/*Request Ditolak*/
					 THEN 1
				ELSE 0
			END AS btnKembaliProses
	  FROM dbo.transaksiOrder a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getinfo_datapasien(b.idPasien) ba
		   INNER JOIN dbo.masterRuangan c ON a.idRuanganAsal = c.idRuangan
	 WHERE a.idRuanganTujuan = @idRuangan AND (a.idStatusOrder = 1/*Request Pemeriksaan*/ OR (a.idStatusOrder = 10/*Request Ditolak*/
		   AND CAST(a.tanggalModifikasi AS date) = CAST(GETDATE() AS date)))
  ORDER BY a.tglOrder;
END