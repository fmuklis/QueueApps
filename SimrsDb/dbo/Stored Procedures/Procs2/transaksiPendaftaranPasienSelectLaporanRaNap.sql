-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectLaporanRaNap]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@tglDaftarA date,
	@tglDaftarB date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT a.idPendaftaranPasien, dbo.format_medicalRecord(b.kodePasien) noRM, ba.namaPasien, bb.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien
		  ,bc.detailUmur AS umur, b.alamatPasien, a.tglDaftarPasien, d.jenisPasien AS namaJenisPenjaminPembayaranPasien, f.NamaOperator
		  ,CONCAT(CONVERT(varchar(50), g.tglTindakan, 105), ' ', CONVERT(varchar(50), g.tglTindakan, 108), ' - ', gb.namaTarifHeader) AS namaTarifHeader
		  ,d.penjamin AS namaJenisPenjaminInduk, c.namaStatusPasien, h.diagnosa As diagnosaAwal, dbo.statusKunjunganPasien(a.idPendaftaranPasien) As statusPasien
		  ,e.lamaInap, e.tglInap, e.tglKeluar
	  FROM dbo.transaksiPendaftaranPasien a 
		   LEFT JOIN dbo.masterPasien b ON a.idPasien = b.idPasien
				OUTER APPLY dbo.generate_namaPasien(b.tglLahirPasien, a.tglDaftarPasien, b.idJenisKelaminPasien, b.idStatusPerkawinanPasien, b.namaLengkapPasien, b.namaAyahPasien) ba
				LEFT JOIN dbo.masterJenisKelamin bb ON b.idJenisKelaminPasien = bb.idJenisKelamin
				OUTER APPLY dbo.calculator_umur(b.tglLahirPasien, a.tglDaftarPasien) bc
		   LEFT JOIN dbo.masterStatusPasien c On a.idStatusPasien = c.idStatusPasien
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) d
		   OUTER APPLY (SELECT Sum(xa.lamaInap) AS lamaInap, MIN(xa.tanggalMasuk) AS tglInap, MAX(xa.tanggalKeluar) AS tglKeluar
						  FROM dbo.transaksiPendaftaranPasienDetail xa
							   INNER JOIN dbo.masterRuanganTempatTidur xb ON xa.idTempatTidur = xb.idTempatTidur
							   INNER JOIN dbo.masterRuanganRawatInap xc ON xb.idRuanganRawatInap = xc.idRuanganRawatInap
						 WHERE a.idPendaftaranPasien = xa.idPendaftaranPasien AND xc.idRuangan = @idRuangan) e
		   LEFT JOIN dbo.masterOperator f On a.idDokter = f.idOperator
		   Inner Join dbo.transaksiTindakanPasien g On a.idPendaftaranPasien = g.idPendaftaranPasien AND g.idRuangan = @idRuangan
				Inner Join dbo.masterTarip ga On g.idMasterTarif = ga.idMasterTarif And ga.idKelas = 99
				Inner Join dbo.masterTarifHeader gb On ga.idMasterTarifHeader = gb.idMasterTarifHeader
		   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) h
	 WHERE a.tglDaftarPasien BETWEEN @tglDaftarA AND CONCAT(@tglDaftarB, ' 23:59:59')
  ORDER BY a.tglDaftarPasien
END