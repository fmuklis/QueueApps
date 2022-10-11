-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[medrec_laporan_kunjunganRaNap_listDiagnosa]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisPenjaminInduk int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @sql nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@begin date, @end date, @penjaminId int'
		   ,@where nvarchar(max) = CASE
										WHEN @idJenisPenjaminInduk <> 0
											 THEN 'AND CAST(a.tglDaftarPasien AS date) BETWEEN @begin AND @end AND c.idJenisPenjaminInduk = @penjaminId'
										ELSE 'AND CAST(a.tglDaftarPasien AS date) BETWEEN @begin AND @end'
									END
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @sql = 'SELECT DISTINCT b.idMasterICD, ba.diagnosa
				  FROM dbo.transaksiPendaftaranPasien a
					   INNER JOIN dbo.transaksiDiagnosaPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
							INNER JOIN dbo.masterICD ba ON b.idMasterICD = ba.idMasterICD
					   INNER JOIN dbo.masterJenisPenjaminPembayaranPasien c ON a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien 
					   INNER JOIN dbo.masterStatusPasien d ON a.idStatusPasien = d.idStatusPasien
				 WHERE a.idJenisPerawatan = 1/*RaNap*/ #dynamicHere#
			  ORDER BY ba.diagnosa';

	SET @sql = REPLACE(@sql, '#dynamicHere#', @where);

	EXECUTE sp_executesql @sql, @paramDefinition , @begin = @periodeAwal, @end = @periodeAkhir, @penjaminId = @idJenisPenjaminInduk;
	
END