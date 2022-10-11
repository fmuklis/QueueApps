-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_bhp_verifikasiCetak_dataBuktiTerima]
	-- Add the parameters for the stored procedure here
	@idMutasi bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tanggalAprove, a.kodeMutasi, b.namaRuangan AS ruanganTujuan, c.namaJenisStok AS unitAujuan
		  ,a.petugasPenyerahan, a.petugasPenerima
	  FROM dbo.farmasiMutasi a
		   LEFT JOIN dbo.masterRuangan b On a.idRuangan = b.idRuangan		
		   LEFT JOIN dbo.farmasiMasterObatJenisStok c ON a.idJenisStokAsal = c.idJenisStok
	 WHERE a.idMutasi = @idMutasi
END