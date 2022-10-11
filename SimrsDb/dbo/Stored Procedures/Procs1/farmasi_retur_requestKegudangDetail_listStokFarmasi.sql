-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudangDetail_listStokFarmasi]
	-- Add the parameters for the stored procedure here
	@idRetur bigint,
	@search varchar(50)

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    DECLARE @idJenisStok tinyint;

	SELECT @idJenisStok = idJenisStokAsal
	  FROM dbo.farmasiRetur
	 WHERE idRetur = @idRetur;

	SET NOCOUNT ON;
    -- Insert statements for procedure here

	SELECT a.idObatDetail, b.namaBarang, a.kodeBatch, a.tglExpired, a.stok, b.namaSatuanObat
	  FROM dbo.farmasiMasterObatDetail a
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
	 WHERE a.idJenisStok = @idJenisStok AND ISNULL(a.stok, 0) > 0 AND (b.namaBarang LIKE '%'+ @search +'%')
  ORDER BY b.namaBarang, a.tglExpired, a.kodeBatch
END