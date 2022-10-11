-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ugd_laporan_kunjunganPasien_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisPenjaminInduk int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*Make variable*/
	DECLARE @sql nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@begin date, @end date, @paramidJenisPenjaminInduk tinyint'
		   ,@where nvarchar(max) = CASE WHEN ISNULL(@idJenisPenjaminInduk, 0) = 0
											 THEN ''
										ELSE '  And d.idJenisPenjaminInduk = @paramidJenisPenjaminInduk'
									END
    
	SET @sql = '
		SELECT a.idPendaftaranPasien, dbo.format_medicalRecord(b.kodePasien) AS noRM, bc.namaPasien, bb.namaJenisKelamin AS jenisKelamin
			  ,b.tglLahirPasien, ba.umur, b.alamatPasien, a.tglDaftarPasien, d.penjamin, COALESCE(ca.NamaOperator, e.NamaOperator) AS dpjp
			  ,COALESCE(cb.NamaRuangan, f.NamaRuangan) AS namaRuangan, h.diagnosa, ga.namaTarif AS namaTarifHeader, g.tglTindakan
			  ,DATEDIFF(MINUTE, a.tglDaftarPasien, g.tglTindakan) AS waktuTunggu
			  ,IIF(a.idJenisPerawatan = 1/*Rawat Inap*/, ''Rawat Inap'', '''') AS keterangan
		  FROM dbo.transaksiPendaftaranPasien a 
			   LEFT JOIN dbo.masterPasien b ON a.idPasien = b.idPasien
					OUTER APPLY dbo.calculator_umur(b.tglLahirPasien, a.tglDaftarPasien) ba
					LEFT JOIN dbo.masterJenisKelamin bb ON b.idJenisKelaminPasien = bb.idJenisKelamin
					OUTER APPLY dbo.generate_namaPasien(b.tglLahirPasien, a.tglDaftarPasien, b.idJenisKelaminPasien, b.idStatusPerkawinanPasien, b.namaLengkapPasien, b.namaAyahPasien) bc
			   LEFT JOIN dbo.transaksiOrderRawatInap c ON a.idPendaftaranPasien = c.idPendaftaranPasien
					LEFT JOIN dbo.masterOperator ca ON c.idDokter = ca.idOperator
					LEFT JOIN dbo.masterRuangan cb ON c.idRuanganAsal = cb.idRuangan
			   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) d
			   LEFT JOIN dbo.masterOperator e ON a.idDokter = e.idOperator
			   LEFT JOIN dbo.masterRuangan f ON a.idRuangan = f.idRuangan
			   LEFT JOIN dbo.transaksiTindakanPasien g ON a.idPendaftaranPasien = g.idPendaftaranPasien AND g.idRuangan = 1/*UGD*/
					OUTER APPLY dbo.getInfo_tarifTindakan(g.idTindakanPasien) ga
			   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) h					
		 WHERE a.idJenisPendaftaran = 1/*Reg IGD*/ AND a.tglDaftarPasien BETWEEN @begin AND CONCAT(@end, '' 23:59:59'') #dynamicHere#
	  ORDER BY a.tglDaftarPasien, a.idPendaftaranPasien';

	SET @sql = REPLACE(@sql, '#dynamicHere#', @where);
	
	EXEC sp_executesql @sql, @paramDefinition, @paramidJenisPenjaminInduk = @idJenisPenjaminInduk, @begin = @periodeAwal, @end = @periodeAkhir;
END