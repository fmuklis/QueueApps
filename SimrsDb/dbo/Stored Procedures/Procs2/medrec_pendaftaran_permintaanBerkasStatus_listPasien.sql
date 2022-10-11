-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE medrec_pendaftaran_permintaanBerkasStatus_listPasien
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   SELECT a.idPendaftaranPasien, a.idPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, b.tglLahirPasien, b.umur
		,b.namaJenisKelamin, a.idStatusPendaftaran, d.namaStatusPendaftaran, e.namaRuangan, b.jumlahCetak 
		,b.cetakKartu, a.flagBerkasTelahDikirim, a.tglDaftarPasien
	FROM dbo.transaksiPendaftaranPasien a 
		 OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		 LEFT JOIN dbo.masterStatusPendaftaran d ON a.idStatusPendaftaran = d.idStatusPendaftaran
		 LEFT JOIN dbo.masterRuangan e ON a.idRuangan = e.idRuangan
   WHERE a.idStatusPendaftaran < 99 And idJenisPerawatan = 2/*Rawat Jalan*/ AND a.idJenisPendaftaran = 2/*Rawat Jalan*/ 
ORDER BY a.flagBerkasTelahDikirim, a.tglDaftarPasien;
END