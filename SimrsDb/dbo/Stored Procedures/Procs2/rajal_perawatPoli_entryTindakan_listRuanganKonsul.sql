

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Daftar Ruangan Poli Untuk Konsul
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_listRuanganKonsul] 
	-- Add the parameters for the stored procedure here
	@idRuangan int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [idRuangan]
		  ,[namaRuangan]	
	  FROM dbo.masterRuangan
	 WHERE idjenisRuangan = 3 And idRuangan <> @idRuangan
  ORDER BY [namaRuangan]
END