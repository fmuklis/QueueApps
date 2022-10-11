-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudangDetail_dataRequest]
	-- Add the parameters for the stored procedure here
	@idRetur bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tanggalRetur, b.namaJenisStok AS stokAsal, c.namaJenisStok AS tujuanRequest
		  ,a.keterangan, d.statusRetur
	  FROM dbo.farmasiRetur a
		   LEFT JOIN dbo.farmasiMasterObatJenisStok b ON a.idJenisStokAsal = b.idJenisStok
		   LEFT JOIN dbo.farmasiMasterObatJenisStok c ON a.idJenisStokTujuan = c.idJenisStok
		   LEFT JOIN dbo.farmasiMasterStatusRetur d ON a.idStatusRetur = d.idStatusRetur
	 WHERE a.idRetur = @idRetur
END