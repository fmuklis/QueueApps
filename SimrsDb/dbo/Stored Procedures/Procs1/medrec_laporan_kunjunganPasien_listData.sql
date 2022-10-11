-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_kunjunganPasien_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@statusPasien int,
	@idJenisPenjaminInduk int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @query nvarchar(max)
		   ,@where nvarchar(max) = CASE
										WHEN @idJenisPenjaminInduk <> 0
											 THEN ' And d.idJenisPenjaminInduk = '+ CAST(@idJenisPenjaminInduk AS varchar(20))+''
										ELSE ''										 									
									END
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @query = 'SELECT * 
				    FROM (Select a.tglDaftarPasien, b.noRM, b.namaPasien, b.namaJenisKelamin AS jenisKelamin, b.umur, da.namaJenisPenjaminInduk
								,COALESCE(f.diagnosa, dbo.diagnosaPasien(a.idPendaftaranPasien)) As diagnosaAwal, e.NamaOperator
								,Case
									  When Exists(Select 1 From dbo.transaksiPendaftaranPasien xa 
												   Where xa.idPasien = a.idPasien And xa.idPendaftaranPasien <> a.idPendaftaranPasien)
										   Then 2
									  Else 1
								  End As idStatusPasien
								,Case
									  When Exists(Select 1 From dbo.transaksiPendaftaranPasien xa 
												   Where xa.idPasien = a.idPasien And xa.idPendaftaranPasien <> a.idPendaftaranPasien)
										   Then ''Lama''
									  Else ''Baru''
								  End As statusPasien
							From dbo.transaksiPendaftaranPasien a
								 OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
								 Inner Join dbo.masterStatusPasien c On a.idStatusPasien = c.idStatusPasien
								 Inner Join dbo.masterJenisPenjaminPembayaranPasien d On a.idJenisPenjaminPembayaranPasien = d.idJenisPenjaminPembayaranPasien
									Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk da On d.idJenisPenjaminInduk = da.idJenisPenjaminInduk
								 Inner Join dbo.masterOperator e On a.idDokter = e.idOperator
								 OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) f
						   Where Convert(date, a.tglDaftarPasien) Between '''+ Convert(nvarchar(50), @periodeAwal) +''' And '''+ Convert(nvarchar(50), @periodeAkhir) +''''+ @where +'
						 ) As dataSet
				   WHERE idStatusPasien = '+ Convert(nvarchar(50), @statusPasien) +'
				ORDER BY tglDaftarPasien, NamaOperator, namaPasien';
	EXEC(@query);
	--Select @query;
END