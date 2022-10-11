-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_laporan_mutasi_listTujuanStok]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisStokAsal int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT b.idJenisStok, b.namaJenisStok
	  FROM dbo.farmasiMutasi a
		   Inner Join dbo.farmasiMasterObatJenisStok b ON a.idJenisStokTujuan = b.idJenisStok
	 WHERE a.tanggalAprove BETWEEN @periodeAwal AND @periodeAkhir AND a.idJenisStokAsal = @idJenisStokAsal
  ORDER BY idJenisStok
END