-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_pendaftaranPasien_listData]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@periodeAwal date,
	@periodeAkhir date

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @query nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@dateBegin date, @dateEnd date, @idR int'
		   ,@filter nvarchar(max) = CASE
										 WHEN @idRuangan = 0
											  THEN ''
										 ELSE 'AND (a.idRuangan = @idR OR da.idRuangan = @idR)'
									 END

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @query = '
		SELECT b.noRM, b.namaPasien, b.umur, a.tglDaftarPasien, b.alamatPasien, e.penjamin
			  ,CASE
					WHEN a.idJenisPerawatan = 1/*RaNap*/
						 THEN da.alias
					ELSE c.alias
				END AS namaRuangan
		  FROM dbo.transaksiPendaftaranPasien a 
			   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
			   LEFT JOIN dbo.masterRuangan c ON a.idRuangan = c.idRuangan
			   LEFT JOIN dbo.transaksiOrderRawatInap d ON a.idPendaftaranPasien = d.idPendaftaranPasien
				   LEFT JOIN dbo.masterRuangan da ON d.idRuanganAsal = da.idRuangan
			   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) e
		 WHERE a.tglDaftarPasien BETWEEN @dateBegin AND @dateEnd #dynamicHere#
	  ORDER BY c.idJenisRuangan, namaRuangan, a.tglDaftarPasien
	';

	SET @query = REPLACE(@query, '#dynamicHere#', @filter);

	EXECUTE sp_executesql @query, @paramDefinition, @idR = @idRuangan, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir;
END