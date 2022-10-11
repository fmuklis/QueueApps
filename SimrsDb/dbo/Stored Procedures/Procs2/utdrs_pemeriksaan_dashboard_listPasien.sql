-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[utdrs_pemeriksaan_dashboard_listPasien]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@start int,
	@length int,
	@search nvarchar(50)

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @sql nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@idr int, @begin int, @end int, @filter nvarchar(50)'
		   ,@where nvarchar(max) = Case
										When Len(@search) > 2
											 Then ' And (b.noRM like ''%''+ @filter +''%'' Or b.namaPasien like ''%''+ @filter +''%'')'
										Else ''
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @sql = '
		SELECT a.idPendaftaranPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, b.namaJenisKelamin, b.tglLahirPasien
			  ,b.umur, c.namaRuangan, d.NamaOperator, e.penjamin, jumlahData = COUNT(*) OVER()
			  ,1 AS btnAdd
		  FROM dbo.transaksiPendaftaranPasien a 
			   OUTER APPLY dbo.get_dataPasien(a.idPasien) b 
			   LEFT JOIN dbo.masterRuangan c On a.idRuangan = c.idRuangan
			   LEFT JOIN dbo.masterOperator d On a.idDokter = d.idOperator
			   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) e
			   OUTER APPLY (SELECT TOP 1 xa.idTindakanPasien
							  FROM dbo.transaksiTindakanPasien xa
							 WHERE xa.idPendaftaranPasien = a.idPendaftaranPasien AND xa.idRuangan = @idr) f
		 WHERE a.idStatusPendaftaran < 98 #dynamicHere#
	  ORDER BY a.tglDaftarPasien
		OFFSET @begin ROWS
	FETCH NEXT @end ROWS ONLY';
	
	SET @sql = REPLACE(@sql, '#dynamicHere#', @where)

	EXEC sp_executesql @sql, @paramDefinition, @idr = @idRuangan , @begin = @start, @end = @length, @filter = @search;
END