-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE farmasi_mutasi_requestMutasiDetail_dataRequest
	-- Add the parameters for the stored procedure here
	@idMutasi bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.nomorOrder, a.tanggalOrder, b.namaJenisStok AS unitAsal, c.namaJenisStok AS tujuanRequest, a.keterangan
	  FROM dbo.farmasiMutasi a
		   LEFT JOIN dbo.farmasiMasterObatJenisStok b ON a.idJenisStokAsal = b.idJenisStok
		   LEFT JOIN dbo.farmasiMasterObatJenisStok c ON a.idJenisStokAsal = c.idJenisStok
	 WHERE a.idJenisMutasi = 1/*Mutasi Barang Farmasi*/ AND a.idMutasi = @idMutasi
END