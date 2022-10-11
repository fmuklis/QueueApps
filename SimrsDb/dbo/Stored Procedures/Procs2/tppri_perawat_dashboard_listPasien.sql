-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Daftar Order Rawat Inap Yang masuk Ruangan TPPRI
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[tppri_perawat_dashboard_listPasien] 
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT a.idPendaftaranPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, b.namaJenisKelamin, b.tglLahirPasien, b.umur
		  ,CASE
				WHEN c.idTindakanPasien IS NOT NULL
					 THEN 1
				ELSE 0
		   END AS flagTindakan
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   LEFT JOIN dbo.transaksiTindakanPasien c ON a.idPendaftaranPasien = c.idPendaftaranPasien AND  c.idRuangan = @idRuangan 
	 WHERE a.idJenisPendaftaran = 2 AND a.idStatusPendaftaran = 4;
END