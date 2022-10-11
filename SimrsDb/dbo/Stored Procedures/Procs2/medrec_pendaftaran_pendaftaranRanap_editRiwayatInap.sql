-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_editRiwayatInap]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int,
	@idPendaftaranPasienDetail int,
	@tanggalMasuk date, 
	@tanggalKeluar date,
	@statusInap int,
	@ditagih bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT * FROM dbo.masterTarifKamar where idMasterTarifKamar = @idMasterTarifKamar
	DECLARE @idKelas int;
	DECLARE @idMasterTarifKamar int;
	DECLARE @hargaPokok float;
	DECLARE @tarif float;
	DECLARE @idStatusPendaftaran int = (
										 SELECT a.idStatusPendaftaran FROM dbo.transaksiPendaftaranPasien a
											WHERE a.idPendaftaranPasien = @idPendaftaranPasien
										);	
	
	 IF(@idStatusPendaftaran>=98)
		BEGIN 
			 SELECT 'Data gagal di update, Pasien telah pulang' AS respon, 0 AS responCode;
		END
	 ELSE
		BEGIN
			
		 IF(@tanggalMasuk > @tanggalKeluar)
			 BEGIN
				 SELECT 'Tanggal Masuk tidak boleh melebihi Tanggal Keluar' AS respon, 0 AS responCode;
			 END
		 ELSE
			 BEGIN
				IF(@statusInap=2)
				 BEGIN 
					 SET @idKelas = (SELECT a.idKelasPenjaminPembayaran FROM dbo.transaksiPendaftaranPasien a WHERE a.idPendaftaranPasien = @idPendaftaranPasien);

					SELECT  @tarif= b.tarif,@hargaPokok = b.hargaPokok,@idMasterTarifKamar = b.idMasterTarifKamar FROM dbo.masterTarifKamar b where idKelas = @idKelas
				 END
				ELSE
				 BEGIN
					 DECLARE @idTempatTidur int = (SELECT a.idTempatTidur FROM dbo.transaksiPendaftaranPasienDetail a WHERE a.idPendaftaranPasienDetail = @idPendaftaranPasienDetail);

					 SET @idKelas= (
						SELECT c.idKelas FROM dbo.masterRuanganTempatTidur b 
							INNER JOIN dbo.masterRuanganRawatInap c ON c.idRuanganRawatInap = b.idRuanganRawatInap	
						WHERE idTempatTidur = @idTempatTidur
					 );

					 SELECT @tarif= d.tarif,@hargaPokok = d.hargaPokok,@idMasterTarifKamar = d.idMasterTarifKamar FROM dbo.masterTarifKamar d where idKelas = @idKelas
				 END

				  UPDATE transaksiPendaftaranPasienDetail
						SET tanggalMasuk = @tanggalMasuk,
							tanggalKeluar = @tanggalKeluar,
							idStatusPendaftaranRawatInap= @statusInap,
							idMasterTarifKamar=@idMasterTarifKamar,
							tarifKamar = @tarif,
							hargaPokok = @hargaPokok,
							ditagih = @ditagih
				   WHERE idPendaftaranPasienDetail = @idPendaftaranPasienDetail

				   SELECT 'Data berhasil di update' AS respon, 1 AS responCode;
			 END
		END
	


	
			

END