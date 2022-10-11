-- =============================================
-- Author     :	Start -X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Daftar Pasien Yang Order Farmasi
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_penjualan_dashboard_listRequestResep]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok int = (SELECT idJenisStok FROM dbo.masterRuangan WHERE idRuangan = @idRuangan);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 500 a.idResep, a.noResep, a.tglResep, dbo.format_medicalRecord(ba.kodePasien) AS noRM, bc.namaPasien, c.Alias
		  ,Case 
				When a.idStatusResep = 1
					 Then 1
				Else 0
			End As btnTerima
		  ,Case 
				When a.idStatusResep = 1
					 Then 1
				Else 0
			End As btnBatal
		  ,Case 
				When a.idStatusResep = 4
					 Then 1
				Else 0
			End As btnKembaliProses
	  FROM dbo.farmasiResep a 
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				INNER JOIN dbo.masterPasien ba ON b.idPasien = ba.idPasien
				Inner Join dbo.masterJenisPerawatan bb On b.idJenisPerawatan = bb.idJenisPerawatan
				OUTER APPLY dbo.generate_namaPasien(ba.tglLahirPasien, b.tglDaftarPasien, ba.idJenisKelaminPasien, ba.idStatusPerkawinanPasien, ba.namaLengkapPasien, ba.namaAyahPasien) bc
		   Inner Join dbo.masterRuangan c On a.idRuangan = c.idRuangan And c.idJenisStok = @idJenisStok
	 WHERE a.idStatusResep = 1/*Request Resep*/ OR (a.idStatusResep = 4/*Resep Batal*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date))
  ORDER BY a.tglResep DESC
END