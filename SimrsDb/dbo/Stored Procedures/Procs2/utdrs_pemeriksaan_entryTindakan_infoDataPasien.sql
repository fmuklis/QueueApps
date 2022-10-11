-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[utdrs_pemeriksaan_entryTindakan_infoDataPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.anamnesa, a.idPendaftaranPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, b.alamatPasien, b.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien, b.umur
		  ,c.penjamin, c.jenisPasien, a.namaPenanggungJawabPasien, a.idHubunganKeluargaPenanggungJawab, a.alamatPenanggungJawabPasien
		  ,a.noHpPenanggungJawab, a.tanggalRawatInap, db.namaRuanganRawatInap, a.idDokter, da.idRuanganRawatInap, d.idTempatTidur, db.idRuangan, f.NamaOperator AS DPJP
		  ,da.noTempatTidur, g.idKelas, g.namaKelas As kelasPenjaminPasien, f.idOperator, f.NamaOperator
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) c
		   LEFT JOIN dbo.transaksiPendaftaranPasienDetail d ON a.idPendaftaranPasien = d.idPendaftaranPasien And d.aktif = 1
				LEFT JOIN dbo.masterRuanganTempatTidur da ON d.idTempatTidur = da.idTempatTidur
				LEFT JOIN dbo.masterRuanganRawatInap db ON da.idRuanganRawatInap = db.idRuanganRawatInap
		   LEFT JOIN dbo.masterOperator f ON a.idDokter = f.idOperator
		   LEFT JOIN dbo.masterKelas g ON a.idKelas = g.idKelas
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END