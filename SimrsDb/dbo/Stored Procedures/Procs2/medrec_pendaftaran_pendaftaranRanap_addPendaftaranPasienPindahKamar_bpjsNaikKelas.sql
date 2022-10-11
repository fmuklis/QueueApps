
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: 20/02/2019
-- Description:	Untuk Pindah Kamar Rawat Inap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_addPendaftaranPasienPindahKamar_bpjsNaikKelas]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idOperator int
    ,@idTempatTidur int
	,@tglDaftar datetime
    ,@userIdEntry int
    ,@keterangan nvarchar(max)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasienDetail int
		   ,@idStatusPendaftaranRawatInap int
		   ,@idTransaksiOrderRawatInap int
		   ,@idMasterTarifKamar int
		   ,@tarifKamar money
		   ,@idKelasKamar int
		   ,@idRuangan int;
	 Select @idPendaftaranPasienDetail = idPendaftaranPasienDetail
		   ,@idTransaksiOrderRawatInap = idTransaksiOrderRawatInap
		   ,@idStatusPendaftaranRawatInap = Case /*Jika Pasien Titip Inap Ketika Pindah Menjadi Pasien Biasa*/
												 When idStatusPendaftaranRawatInap = 2/*Pasien Titip Kamar Rawat Inap*/
													  Then 1
												 Else idStatusPendaftaranRawatInap
											 End
	   From dbo.transaksiPendaftaranPasienDetail 
	  Where idPendaftaranPasien = @idPendaftaranPasien And aktif = 1;

	 Select @idMasterTarifKamar = ba.idMasterTarifKamar, @tarifKamar = ba.tarif, @idKelasKamar = b.idKelas, @idRuangan = b.idRuangan
	   From dbo.masterRuanganTempatTidur a
			Inner Join dbo.masterRuanganRawatInap b On a.idRuanganRawatInap = b.idRuanganRawatInap
				Inner Join dbo.masterTarifKamar ba On b.idKelas = ba.idKelas
	  Where a.idTempatTidur = @idTempatTidur;

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
			Begin Tran tranzRegPasienInapForPindahKamar;

			/*INSERT Data Kamar Inap Pasien*/
			INSERT INTO dbo.transaksiPendaftaranPasienDetail
					   (idTransaksiOrderRawatInap
					   ,idPendaftaranPasien
					   ,idStatusPendaftaranRawatInap
					   ,idTempatTidur
					   ,tanggalMasuk
					   ,tanggalEntry
					   ,idUserEntry
					   ,aktif
					   ,idMasterTarifKamar
					   ,tarifKamar)
				 VALUES
					   (@idTransaksiOrderRawatInap
					   ,@idPendaftaranPasien
					   ,@idStatusPendaftaranRawatInap
					   ,@idTempatTidur
					   ,@tglDaftar
					   ,GetDate()
					   ,@userIdEntry
					   ,1/*Aktif*/
					   ,@idMasterTarifKamar
					   ,@tarifKamar);

			/*UPDATE Data Pendaftaran Pasien*/
			UPDATE a
			   SET a.idRuangan = @idRuangan
				  ,a.idKelas = @idKelasKamar
				  ,a.idStatusPendaftaran = 5/*Dalam Perawatan Rawat Inap*/
				  ,a.idKelasPenjaminPembayaran = Case /*Untuk Pasien Umum Jika Pindah kamar dan pindah kelas penjamin*/
													  When @idKelasKamar < = 5 And a.idKelasPenjaminPembayaran <> @idKelasKamar And c.idJenisPenjaminInduk = 1/*UMUM*/
														   Then @idKelasKamar
													  Else a.idKelasPenjaminPembayaran
												  End
			  FROM dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.transaksiPendaftaranPasienDetail b On a.idPendaftaranPasien = b.idPendaftaranPasien
				   Inner Join dbo.masterJenisPenjaminPembayaranPasien c On a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
			 WHERE b.idPendaftaranPasienDetail = @idPendaftaranPasienDetail;

			/*UPDATE Data Kamar Pasien Yang Aktif*/
			UPDATE a
			   SET a.aktif = 0
			      ,a.tanggalKeluar = @tglDaftar
			  FROM dbo.transaksiPendaftaranPasienDetail a
				   Inner Join dbo.masterTarifKamar b On a.idMasterTarifKamar = b.idMasterTarifKamar
			 WHERE a.idPendaftaranPasienDetail = @idPendaftaranPasienDetail;
				
			/*UPDATE Status Order Pindah Kamar*/
			UPDATE a
			   SET flagStatus = 1/*Sudah Di Pindah*/
			  FROM dbo.transaksiOrderRawatInapPindahKamar a
				   Inner Join dbo.transaksiOrderRawatInap b On a.idTransaksiOrderRawatInap = b.idTransaksiOrderRawatInap
			 WHERE b.idPendaftaranPasien = @idPendaftaranPasien
					
			Commit Tran tranzRegPasienInapForPindahKamar;
			Select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		End Try
		Begin Catch
		    Rollback Tran tranzRegPasienInapForPindahKamar;
			Select 'Error !: '+ ERROR_MESSAGE() As respon, 0 as responCode;
		End Catch
END