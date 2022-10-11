-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[medrec_laporan_kunjunganRaNap_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisPenjaminInduk int,
	@idMasterICD int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--Declare @diagnosaAwal nvarchar(max) = (Select Trim(diagnosa) From dbo.masterDiagnosa Where idMasterDiagnosa = @idMasterDiagnosa);
	DECLARE @query nvarchar(max)
		   ,@paramDefinition nvarchar(max) = N'@tglAwal date, @tglAkhir date, @filter nvarchar(max), @idjpi int'
		   ,@diagnosa nvarchar(max) = (SELECT diagnosa FROM dbo.masterICD WHERE idMasterICD = @idMasterICD)
		   ,@where nvarchar(max) = CASE
										WHEN @idJenisPenjaminInduk <> 0
											 THEN ' AND d.idJenisPenjaminInduk = @idjpi'
										ELSE ''										 									
									END
		   ,@filterDiag nvarchar(max) = CASE
											 WHEN @idMasterICD <> 0
												  THEN 'WHERE diagnosa Like ''%''+ @filter +''%'''
											 ELSE ''										 									
										 END;
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @query = '
		WITH dataSrc AS(
				SELECT a.tglDaftarPasien, a.tglKeluarPasien, d.penjamin, f.namaRuangan, e.NamaOperator AS dpjp, b.noRM, b.namaPasien, b.namaJenisKelamin
					  ,b.tglLahirPasien, b.umur, g.diagnosa, b.alamatPasien, b.namaDesaKelurahan, b.namaKecamatan, b.namaKabupaten, c.namaStatusPasien
					  ,CASE
							WHEN EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien xa 
										 WHERE xa.idPasien = a.idPasien AND a.idPendaftaranPasien > xa.idPendaftaranPasien)
								 THEN ''Lama''
							ELSE ''Baru''
						END AS statusPasien
								/*,Case a.idJenisPerawatan
									  When 1
										   Then ''Rawat Inap''
									  Else ''''
								  End As keterangan*/
				  FROM dbo.transaksiPendaftaranPasien a
					   OUTER APPLY dbo.getinfo_datapasien(a.idPasien) b
					   INNER JOIN dbo.masterStatusPasien c On a.idStatusPasien = c.idStatusPasien
					   CROSS APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) d
					   LEFT JOIN dbo.masterOperator e ON a.idDokter = e.idOperator
					   INNER JOIN dbo.masterRuangan f ON a.idRuangan = f.idRuangan
					   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) g
				 WHERE a.idJenisPerawatan = 1/*RaNap*/ And Convert(date, a.tglDaftarPasien) Between @tglAwal And @tglAkhir #dynamicHere#)
		SELECT *
		  FROM dataSrc #filter#
	  ORDER BY penjamin, namaRuangan, dpjp, tglDaftarPasien';

	SET @query = REPLACE(@query, '#dynamicHere#', @where);

	SET @query = REPLACE(@query, '#filter#', @filterDiag);

	EXEC sp_executesql @query, @paramDefinition, @tglAwal = @periodeAwal, @tglAkhir = @periodeAkhir, @idjpi = @idJenisPenjaminInduk, @filter = @diagnosa;
END