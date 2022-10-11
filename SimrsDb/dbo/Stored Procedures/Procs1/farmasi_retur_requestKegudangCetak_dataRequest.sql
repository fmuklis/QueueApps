-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudangCetak_dataRequest]
	-- Add the parameters for the stored procedure here
	@idRetur bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tanggalRetur, a.kodeRetur, b.namaJenisStok AS stokAsal, c.namaJenisStok AS tujuanRequest
		  ,a.keterangan, d.namaPetugasFarmasi AS petugasRetur
	  FROM dbo.farmasiRetur a
		   LEFT JOIN dbo.farmasiMasterObatJenisStok b ON a.idJenisStokAsal = b.idJenisStok
		   LEFT JOIN dbo.farmasiMasterObatJenisStok c ON a.idJenisStokTujuan = c.idJenisStok
		   LEFT JOIN dbo.farmasiMasterPetugas d ON a.idPetugasRetur = d.idPetugasFarmasi
	 WHERE a.idRetur = @idRetur
END