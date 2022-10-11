-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_orderBhpCetak_dataOrder]
	-- Add the parameters for the stored procedure here
	@idMutasi bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.nomorOrder, a.tanggalOrder, b.namaRuangan AS ruanganAsal, c.namaJenisStok AS tujuanOrder, a.keterangan
	  FROM dbo.farmasiMutasi a
		   LEFT JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan
		   LEFT JOIN dbo.farmasiMasterObatJenisStok c ON a.idJenisStokAsal = c.idJenisStok
	 WHERE a.idMutasi = @idMutasi
END