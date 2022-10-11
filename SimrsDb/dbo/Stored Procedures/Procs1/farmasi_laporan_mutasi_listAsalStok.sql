-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_laporan_mutasi_listAsalStok]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT b.idJenisStok, b.namaJenisStok
	  FROM dbo.farmasiMutasi a
		   INNER JOIN dbo.farmasiMasterObatJenisStok b On a.idJenisStokAsal = b.idJenisStok
	 WHERE a.tanggalAprove BETWEEN @periodeAwal AND @periodeAkhir
  ORDER BY idJenisStok
END