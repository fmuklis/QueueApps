
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: 20/02/2019
-- Description:	Untuk Pindah Kamar Rawat Inap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_addPendaftaranPasienPindahKamar_pasienRanapUmum]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien bigint
	,@idOperator int
    ,@idTempatTidur int
	,@tglDaftar datetime
    ,@idUserEntry int
    ,@keterangan varchar(max)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasienDetail bigint
		   ,@idStatusPendaftaranRawatInap int
		   ,@idTransaksiOrderRawatInap int
		   ,@idMasterTarifKamar int
		   ,@tarifKamar money
		   ,@idKelasKamar int
		   ,@idRuangan int;

	 SELECT @idPendaftaranPasienDetail = a.idPendaftaranPasienDetail
		   ,@idTransaksiOrderRawatInap = b.idTransaksiOrderRawatInap
	   FROM dbo.transaksiPendaftaranPasienDetail a
			INNER JOIN dbo.transaksiOrderRawatInap b ON a.idPendaftaranPasien = b.idPendaftaranPasien
	  Where a.idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1;

	 SELECT @idMasterTarifKamar = ba.idMasterTarifKamar, @tarifKamar = ba.tarif, @idKelasKamar = b.idKelas, @idRuangan = b.idRuangan
	   FROM dbo.masterRuanganTempatTidur a
			INNER JOIN dbo.masterRuanganRawatInap b On a.idRuanganRawatInap = b.idRuanganRawatInap
				INNER JOIN dbo.masterTarifKamar ba On b.idKelas = ba.idKelas
	  WHERE a.idTempatTidur = @idTempatTidur;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasienDetail a INNER JOIN dbo.masterRuanganTempatTidur b ON a.idTempatTidur = b.idTempatTidur
					 OUTER APPLY (SELECT idRuanganRawatInap FROM masterRuanganTempatTidur WHERE idTempatTidur = @idTempatTidur) c
			   WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.aktif = 1 AND b.idRuanganRawatInap = c.idRuanganRawatInap)
		BEGIN
			SELECT 'Pasien Berpindah Dalam Kamar Yang Sama, Lakukan Edit Bukan Pindah Kamar' AS respon, 0 AS responCode;
		END
	ELSE
		Begin Try
			Begin Tran;

			/*INSERT Data Kamar Inap Pasien*/
			INSERT INTO dbo.transaksiPendaftaranPasienDetail
					   ([idTransaksiOrderRawatInap]
					   ,[idPendaftaranPasien]
					   ,[idTempatTidur]
					   ,[tanggalMasuk]
					   ,[idUserEntry]
					   ,[aktif]
					   ,[idMasterTarifKamar]
					   ,[tarifKamar])
				 VALUES
					   (@idTransaksiOrderRawatInap
					   ,@idPendaftaranPasien
					   ,@idTempatTidur
					   ,@tglDaftar
					   ,@idUserEntry
					   ,1/*Aktif*/
					   ,@idMasterTarifKamar
					   ,@tarifKamar);

			/*UPDATE Data Pendaftaran Pasien*/
			UPDATE a
			   SET a.idRuangan = @idRuangan
				  ,a.idKelas = @idKelasKamar
				  ,a.idStatusPendaftaran = 5/*Dalam Perawatan Rawat Inap*/
				  ,a.idKelasPenjaminPembayaran = Case /*Untuk Pasien Umum Jika Pindah kamar dan pindah kelas penjamin*/
													  When @idKelasKamar <= 5
														   Then @idKelasKamar
													  Else a.idKelasPenjaminPembayaran
												  End
			  FROM dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.transaksiPendaftaranPasienDetail b On a.idPendaftaranPasien = b.idPendaftaranPasien
			 WHERE b.idPendaftaranPasienDetail = @idPendaftaranPasienDetail;

			/*UPDATE Data Kamar Pasien Yang Aktif*/
			UPDATE a
			   SET a.aktif = 0
			      ,a.tanggalKeluar = @tglDaftar
			  FROM dbo.transaksiPendaftaranPasienDetail a
			 WHERE a.idPendaftaranPasienDetail = @idPendaftaranPasienDetail;
				
			/*UPDATE Status Order Pindah Kamar*/
			UPDATE a
			   SET flagStatus = 1/*Sudah Di Pindah*/
			  FROM dbo.transaksiOrderRawatInapPindahKamar a
				   Inner Join dbo.transaksiOrderRawatInap b On a.idTransaksiOrderRawatInap = b.idTransaksiOrderRawatInap
			 WHERE b.idPendaftaranPasien = @idPendaftaranPasien;
					
			Commit Tran;
			Select 'Data Pendaftaran Pasien Pindah Kamar Rawat Inap Berhasil Disimpan' AS respon, 1 AS responCode;
		End Try
		Begin Catch
		    Rollback Tran;
			Select 'Error !: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END