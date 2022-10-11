-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl36_listDataBulanan]
	-- Add the parameters for the stored procedure here
	@tahun int,
	@bulan tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH dataSrc AS (
		SELECT a.idGolonganSpesialis, a.golonganSpesialis, ba.golonganOk
		  FROM dbo.masterOkGolonganSpesialis a
			   LEFT JOIN dbo.transaksiOrderOK b ON a.idGolonganSpesialis = b.idGolonganSpesialis AND YEAR(b.tglOperasi) = 2020 AND 	MONTH(b.tglOperasi) = @bulan
					LEFT JOIN dbo.masterOkGolongan ba ON b.idGolonganOk = ba.idGolonganOk
	)
	SELECT golonganSpesialis, [KHUSUS],[BESAR],[SEDANG],[KECIL]
	  FROM dataSrc
	 PIVOT (COUNT(idGolonganSpesialis) FOR golonganOk IN([KHUSUS],[BESAR],[SEDANG],[KECIL])) dataSet
END