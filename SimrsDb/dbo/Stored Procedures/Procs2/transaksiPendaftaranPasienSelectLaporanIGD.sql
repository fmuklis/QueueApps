-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectLaporanIGD]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisPenjaminInduk int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @sql nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@begin date, @end date'
		   ,@where nvarchar(max) = Case
										When @idJenisPenjaminInduk = 0
											 Then ''
										Else '  And d.idJenisPenjaminInduk = '+ Convert(nvarchar(10), @idJenisPenjaminInduk) +''
									End
	SET NOCOUNT ON;

	SET @sql = 'SELECT namaRuangan, idPendaftaranPasien, tglDaftarPasien, noRM, namaPasien, jenisKelamin, tglLahirPasien, umur, alamatPasien
					  ,namaJenisPenjaminPembayaranPasien, diagnosaAwal, NamaOperator, namaTarifHeader, keterangan
				  FROM (SELECT a.idPendaftaranPasien, b.noRM, b.namaPasien, b.jenisKelamin, b.tglLahirPasien, b.umur, b.alamatPasien
							  ,a.tglDaftarPasien, d.namaJenisPenjaminPembayaranPasien, f.NamaOperator
							  ,CONCAT(CONVERT(varchar(50), g.tglTindakan, 105), '' '', CONVERT(varchar(50), g.tglTindakan, 108), '' - '', gb.namaTarifHeader) AS namaTarifHeader
							  ,dbo.diagnosaPasien(a.idPendaftaranPasien) As diagnosaAwal
							  ,Case
									When a.idJenisPerawatan = 1/*Rawat Inap*/
										 Then c.idRuanganAsal
									Else a.idRuangan
								End As idRuangan
							  ,Case
									When a.idJenisPerawatan = 1/*Rawat Inap*/
										 Then ''Rawat Inap''
									Else ''''
								End As keterangan
						  FROM dbo.transaksiPendaftaranPasien a 
							   Inner Join dbo.dataPasien() b On a.idPasien = b.idPasien
							   Left Join dbo.transaksiOrderRawatInap c On a.idPendaftaranPasien = c.idPendaftaranPasien
							   Inner Join dbo.masterJenisPenjaminPembayaranPasien d On a.idJenisPenjaminPembayaranPasien = d.idJenisPenjaminPembayaranPasien
							   --Inner Join dbo.transaksiDiagnosaPasien e On a.idPendaftaranPasien = e.idPendaftaranPasien
							   Inner Join dbo.masterOperator f On a.idDokter = f.idOperator
							   Inner Join dbo.transaksiTindakanPasien g On a.idPendaftaranPasien = g.idPendaftaranPasien
									Inner Join dbo.masterTarip ga On g.idMasterTarif = ga.idMasterTarif And ga.idKelas = 99
									Inner Join dbo.masterTarifHeader gb On ga.idMasterTarifHeader = gb.idMasterTarifHeader
						 WHERE a.idJenisPendaftaran = 1/*Reg IGD*/ And a.tglDaftarPasien BETWEEN @begin AND CONCAT(@end, '' 23:59:59'') @dynamicHere) As dataSet
					   Inner Join dbo.masterRuangan b On dataSet.idRuangan = b.idRuangan
			  ORDER BY tglDaftarPasien';

	SET @sql = Replace(@sql, '@dynamicHere', @where);

	EXEC sp_executesql @sql, @paramDefinition, @begin = @periodeAwal, @end = @periodeAkhir;
END