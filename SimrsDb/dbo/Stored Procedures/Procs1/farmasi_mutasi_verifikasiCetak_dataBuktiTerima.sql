-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE farmasi_mutasi_verifikasiCetak_dataBuktiTerima
	-- Add the parameters for the stored procedure here
	@idMutasi bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tanggalAprove, a.kodeMutasi, b.namaJenisStok AS tujuanMutasi, c.namaJenisStok AS asalMutasi
		  ,a.petugasPenyerahan, a.petugasPenerima
	  FROM dbo.farmasiMutasi a
		   LEFT JOIN dbo.farmasiMasterObatJenisStok b On a.idJenisStokTujuan = b.idJenisStok		
		   LEFT JOIN dbo.farmasiMasterObatJenisStok c ON a.idJenisStokAsal = c.idJenisStok
	 WHERE a.idMutasi = @idMutasi
END