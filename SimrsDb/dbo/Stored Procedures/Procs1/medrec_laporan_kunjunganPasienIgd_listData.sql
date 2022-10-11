-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_kunjunganPasienIgd_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisPenjaminInduk int,
	@idMasterDiagnosa int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @diagnosaAwal nvarchar(max) = (Select Trim(diagnosa) From dbo.masterDiagnosa Where idMasterDiagnosa = @idMasterDiagnosa);
	Declare @query nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@tglAwal date, @tglAkhir date, @filter nvarchar(max)'
		   ,@where nvarchar(max) = Case
										When IsNull(@idJenisPenjaminInduk, 0) <> 0
											 Then ' And d.idJenisPenjaminInduk = '+ Convert(nvarchar(20), @idJenisPenjaminInduk) +''
										Else ''										 									
									End
		   ,@filter nvarchar(max) = Case
										 When IsNull(@idMasterDiagnosa, 0) <> 0
											  Then 'Where diagnosaAwal Like ''%''+ @filter +''%'''
										 Else ''										 									
									 End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @query = 'SELECT tglDaftarPasien, noRM, namaPasien, namaJenisKelamin, tglLahirPasien, umur, namaJenisPenjaminInduk, diagnosaAwal, NamaOperator, statusPasien
						,alamatPasien, namaDesaKelurahan, namaKecamatan, namaKabupaten, keterangan, namaStatusPasien
				    FROM (Select a.tglDaftarPasien, b.noRM, b.namaPasien, b.namaJenisKelamin, b.tglLahirPasien, b.umur, da.namaJenisPenjaminInduk
								,dbo.diagnosaPasien(a.idPendaftaranPasien) As diagnosaAwal, e.NamaOperator, c.namaStatusPasien
								,b.alamatPasien, b.namaDesaKelurahan, b.namaKecamatan, b.namaKabupaten
								,Case
									  When Exists(Select 1 From dbo.transaksiPendaftaranPasien xa 
												   Where xa.idPasien = a.idPasien And a.idPendaftaranPasien > xa.idPendaftaranPasien)
										   Then ''Lama''
									  Else ''Baru''
								  End As statusPasien
								,Case a.idJenisPerawatan
									  When 1
										   Then ''Rawat Inap''
									  Else ''''
								  End As keterangan
							From dbo.transaksiPendaftaranPasien a
								 Cross Apply dbo.getinfo_datapasien(a.idPasien) b
								 Left Join dbo.masterStatusPasien c On a.idStatusPasien = c.idStatusPasien
								 Inner Join dbo.masterJenisPenjaminPembayaranPasien d On a.idJenisPenjaminPembayaranPasien = d.idJenisPenjaminPembayaranPasien
									Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk da On d.idJenisPenjaminInduk = da.idJenisPenjaminInduk
								 Left Join dbo.masterOperator e On a.idDokter = e.idOperator
						   Where a.idJenisPendaftaran = 1/*IGD*/ And a.idJenisPerawatan = 2/*RaJal*/ And a.idStatusPendaftaran > 1/*Sudah Diterima*/ And Convert(date, a.tglDaftarPasien) Between @tglAwal And @tglAkhir @dynamicHere) As dataSet
						  @filter
				ORDER BY namaJenisPenjaminInduk, NamaOperator, tglDaftarPasien';

	SET @query = Replace(@query, '@dynamicHere', @where);

	SET @query = Replace(@query, '@filter', @filter);

	EXEC sp_executesql @query, @paramDefinition, @tglAwal = @periodeAwal, @tglAkhir = @periodeAkhir, @filter = @diagnosaAwal;
END