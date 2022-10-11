-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_kunjunganPasienRaJal_listDiagnosa]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisPenjaminInduk int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @sql nvarchar(max)
		   ,@paramDefinition nvarchar(max)
		   ,@where nvarchar(max) = Case
										When @idJenisPenjaminInduk <> 0
											 Then 'And Convert(date, a.tglDaftarPasien) Between @begin And @end And c.idJenisPenjaminInduk = @penjaminId'
										Else 'And Convert(date, a.tglDaftarPasien) Between @begin And @end'
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @sql = 'SELECT Distinct ba.idMasterDiagnosa, ba.diagnosa
				  FROM dbo.transaksiPendaftaranPasien a
					   Inner Join dbo.transaksiDiagnosaPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
							Inner Join dbo.masterDiagnosa ba On b.idMasterDiagnosa = ba.idMasterDiagnosa
					   Inner Join dbo.masterJenisPenjaminPembayaranPasien c On a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien 
				 WHERE a.idJenisPendaftaran = 2/*RaJal*/ And a.idJenisPerawatan = 2/*RaJal*/ @dynamicHere
			  ORDER BY ba.diagnosa';

	SET @sql = Replace(@sql, '@dynamicHere', @where);

	SET @paramDefinition = '@begin date, @end date, @penjaminId int';
	 
	EXECUTE sp_executesql @sql, @paramDefinition , @begin = @periodeAwal, @end = @periodeAkhir, @penjaminId = @idJenisPenjaminInduk;
	
END