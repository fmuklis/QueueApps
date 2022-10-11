-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pasien_pencarianDetail_listRiwayatPendaftaran]
	-- Add the parameters for the stored procedure here
	@idPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, i.idResep, a.idJenisPerawatan, a.tglDaftarPasien
		  ,a.noReg, b.penjamin, c.namaKelas AS kelasPenjaminPasien, d.alias AS namaRuangan, e.NamaOperator, f.namaStatusPendaftaran
		  ,g.namaJenisPendaftaran, h.namaJenisPerawatan
		  ,CASE
				WHEN i.idResep IS NOT NULL
					 THEN 1
				ELSE 0
			END AS btnResep
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) b
		   LEFT JOIN dbo.masterKelas c ON a.idKelasPenjaminPembayaran = c.idKelas
		   LEFT JOIN dbo.masterRuangan d ON a.idRuangan = d.idRuangan
		   LEFT JOIN dbo.masterOperator e ON a.idDokter = e.idOperator
		   LEFT JOIN dbo.masterStatusPendaftaran f ON a.idStatusPendaftaran = f.idStatusPendaftaran
		   LEFT JOIN dbo.masterJenisPendaftaran g ON a.idJenisPendaftaran = g.idJenisPendaftaran
		   LEFT JOIN dbo.masterJenisPerawatan h ON a.idJenisPerawatan = h.idJenisPerawatan
		   LEFT JOIN dbo.farmasiResep i ON a.idPendaftaranPasien = i.idPendaftaranPasien AND i.idStatusResep = 3/*Selesai*/
	 WHERE a.idPasien = @idPasien
  ORDER BY a.tglDaftarPasien DESC
END