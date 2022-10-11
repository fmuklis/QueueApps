-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_addOrder]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@idDokter int,
    @idRuanganAsal int,
	@idRuanganTujuan int,
    @tglOrder datetime,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasienDetail WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1/*Current Bed*/
						  AND idJenisPelayananRawatInap IS NULL)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Silahkan Entry Jenis Pelayanan Pasien Pada Tab Diagnosa' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.transaksiOrder WHERE idPendaftaranPasien = @idPendaftaranPasien AND idRuanganTujuan = @idRuanganTujuan AND idStatusOrder = 1)
		BEGIN
			SELECT 'Tidak Dapat Diproses, Masih Ada Request Pemeriksaan '+ b.namaRuangan +' Yang Belum Diproses Pada Pasien Ini' AS respon, 0 AS responCode 
			  FROM dbo.transaksiOrder a
				   INNER JOIN dbo.masterRuangan b ON a.idRuanganTujuan = b.idRuangan
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.idStatusOrder = 1
		END					
	ELSE
		BEGIN
			INSERT INTO [dbo].[transaksiOrder]
					   ([idDokter]
					   ,[idRuanganAsal]
					   ,[idRuanganTujuan]
					   ,[idPendaftaranPasien]
					   ,[tglOrder]
					   ,[idUserEntry]
					   ,[idStatusOrder])
				 VALUES(@idDokter
					   ,@idRuanganAsal
					   ,@idRuanganTujuan
					   ,@idPendaftaranPasien 
					   ,@tglOrder
					   ,@idUserEntry
					   ,1);	

			SELECT 'Request Pemeriksaan Penunjang Berhasil Disimpan' AS respon, 1 AS responCode;								
		END
END