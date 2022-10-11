-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl51_listData]
	-- Add the parameters for the stored procedure here
	@tahun int,
	@bulan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select a.statusKunjungan, Count(a.idPendaftaranPasien) As Jumlah
	  From (SELECT a.idPendaftaranPasien
				  ,Case
						When Exists(Select 1 From dbo.transaksiPendaftaranPasien xa 
									 Where a.idPasien = xa.idPasien And a.idPendaftaranPasien <> xa.idPendaftaranPasien
										   And a.tglDaftarPasien < xa.tglDaftarPasien) Or a.idPasien < = 450
							 Then 'Pengunjung Lama'
						Else 'Pengunjung Baru'
					End As statusKunjungan
			  FROM dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterRuangan b On a.idRuangan = b .idRuangan
			 WHERE a.idJenisPendaftaran = 2/*Pendaftaran Rawat Jalan*/ And a.idJenisPerawatan = 2/*Perawatan Rawat Jalan*/ And Year(a.tglDaftarPasien) = @Tahun And Month(a.tglDaftarPasien) = @Bulan) a
  Group By a.statusKunjungan
END