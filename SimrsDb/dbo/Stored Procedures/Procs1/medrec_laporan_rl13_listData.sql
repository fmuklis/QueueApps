-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl13_listData]
	-- Add the parameters for the stored procedure here
	@tahun int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH dataSrc AS (
		SELECT a.idJenisPelayananRawatInap, a.jenisPelayananRawatInap, b.kelas, COUNT(b.kelas) AS jumlah
		  FROM dbo.masterJenisPelayananRawatInap a
			   OUTER APPLY (SELECT CASE
										WHEN xb.idKelas < 6
											 THEN xb.idKelas
										ELSE 6
									END AS kelas
							  FROM dbo.masterRuanganTempatTidur xa
								   INNER JOIN dbo.masterRuanganRawatInap xb ON xa.idRuanganRawatInap = xb.idRuanganRawatInap
							 WHERE xb.idJenisPelayananRawatInap = a.idJenisPelayananRawatInap AND xb.idKelas <> 7/*NeoNatus*/
								   AND @tahun BETWEEN YEAR(xa.tanggalDigunakan) AND YEAR(ISNULL(xa.tanggalNonaktif, GETDATE()))) b
		 WHERE a.perinatologi = 0/*Perawatan Non Bayi*/
	  GROUP BY a.idJenisPelayananRawatInap, a.jenisPelayananRawatInap, b.kelas)
	SELECT jenisPelayananRawatInap AS namaRuangan, ISNULL([1], 0) AS jmlVVIP, ISNULL([2], 0) AS jmlVIP, ISNULL([3], 0) AS jmlKlsI, ISNULL([4], 0) AS jmlKlsII
		  ,ISNULL([5], 0)jmlKlsIII, ISNULL([6], 0) AS jmlLain
		  ,ISNULL([1], 0) + ISNULL([2], 0) + ISNULL([3], 0) + ISNULL([4], 0) + ISNULL([5], 0) + ISNULL([6], 0) AS jmlTempatTidur
	  FROM dataSrc
	 PIVOT (SUM(jumlah) FOR kelas IN([1],[2],[3],[4],[5],[6])) dataPvt
  ORDER BY idJenisPelayananRawatInap
END