-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE farmasi_mutasi_verifikasiDetail_dataRequest
	-- Add the parameters for the stored procedure here
	@idMutasi bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tanggalOrder, a.nomorOrder, b.namaJenisStok AS tujuanMutasi
		  ,d.namaLengkap AS pemohon, a.kodeMutasi, c.statusMutasi		
	  FROM dbo.farmasiMutasi a
		   LEFT JOIN dbo.farmasiMasterObatJenisStok b ON a.idJenisStokTujuan = b.idJenisStok		
		   LEFT JOIN dbo.farmasiMasterStatusMutasi c ON a.idStatusMutasi = c.idStatusMutasi
		   LEFT JOIN dbo.masterUser d ON a.idUserEntry = d.idUser
	 WHERE a.idMutasi = @idMutasi
END