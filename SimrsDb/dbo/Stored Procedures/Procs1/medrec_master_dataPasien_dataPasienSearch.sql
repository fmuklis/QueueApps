CREATE PROCEDURE [dbo].[medrec_master_dataPasien_dataPasienSearch]
	-- Add the parameters for the stored procedure here
	@idJenisPencarian tinyint,
	@keyword varchar(50)

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @query nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@nik varchar(50), @noKartu varchar(50), @noRm varchar(50)'
		   ,@filter nvarchar(max) = CASE
										 WHEN @idJenisPencarian = 1/*NIK*/
											  THEN 'WHERE a.noDokumenIdentitasPasien = @nik'
										 WHEN @idJenisPencarian = 2/*NO BPJS*/
											  THEN 'WHERE a.noBPJS = @noKartu'
										 WHEN @idJenisPencarian = 3/*NO RM*/
											  THEN 'WHERE a.kodePasien = @noRm'
									 END
	SET NOCOUNT ON;
	-- Insert statements for procedure here
	SET @query = '
		IF EXISTS(SELECT TOP 1 1 FROM dbo.masterPasien a #dynamicHere#)
			BEGIN
				SELECT 1 AS responCode, ''Data Pasien Ditemukan'' AS respon, a.idPasien, b.Umur, b.namaPasien, b.noPenjamin, b.idJenisKelamin, b.namaJenisKelamin
					  ,b.idDesaKelurahan, b.namaDesaKelurahan, b.idKecamatan, b.namaKecamatan, b.idKabupaten, b.namaKabupaten, b.idProvinsi, b.namaProvinsi
					  ,b.idNegara, b.namaNegara, a.idAgamaPasien AS idAgama, b.namaAgama, a.idPekerjaanPasien AS idPekerjaan, b.namaPekerjaan, a.idPendidikanPasien AS idPendidikan
					  ,b.namaPendidikan, a.idWargaNegaraPasien AS idWargaNegara, b.namaWargaNegara, a.idStatusPerkawinanPasien AS idStatusPerkawinan, b.namaStatusPerkawinan
					  ,a.idDokumenIdentitasPasien AS idDokumenIdentitas, b.namaDokumenIdentitas
					  ,CASE dbo.jumlahKata(a.namaLengkapPasien)
							WHEN 1 
								 THEN b.namaPasien
							ELSE a.namaLengkapPasien
						END AS namaDiGelang
					  ,CASE
							WHEN LEN(ISNULL(a.namaAyahPasien, '''')) <= 1 OR a.idDesaKelurahanPasien Is Null 
								 THEN 1
							ELSE 0
						END AS flagUpdate
				  FROM dbo.masterPasien a 
					   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b #dynamicHere#;
			END
		ELSE
			BEGIN
				SELECT ''Data Pasien Tidak Ditemukan'' AS respon, 0 AS responCode;
			END';

	SELECT @query = REPLACE(@query, '#dynamicHere#', @filter), @keyword = REPLACE(@keyword, '.', '');

	EXECUTE sp_executesql @query, @paramDefinition, @nik = @keyword, @noKartu = @keyword, @noRm = @keyword;
END