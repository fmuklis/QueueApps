-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Tujuan Permintaan Item Farmasi
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_mutasi_requestMutasi_listTujuanRequest]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok int = (SELECT idJenisStok FROM dbo.masterRuangan WHERE idRuangan = @idRuangan);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idJenisStok, namaJenisStok
	  FROM dbo.farmasiMasterObatJenisStok
	 WHERE idJenisStok BETWEEN 1 AND 5 AND idJenisStok <> @idJenisStok
  ORDER BY namaJenisStok
END