-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_orderIMF] 
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
    ,@idRuangan int
    ,@idDokter int
    ,@tglIMF date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisStok int = (Select idJenisStok From dbo.masterRuangan Where idRuangan = @idRuangan);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasienDetail WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1/*Current Bed*/
						  AND idJenisPelayananRawatInap IS NULL)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Silahkan Entry Jenis Pelayanan Pasien Pada Tab Diagnosa' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiIMF a
						  Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
				    Where idPendaftaranPasien = @idPendaftaranPasien And b.idJenisStok = @idJenisStok  And idDokter = @idDokter)
		BEGIN
			Select 'Permintaan IMF Ke '+ namaJenisStok +' Dengan Dokter '+ c.NamaOperator +' Telah Terdaftar, Tidak Perlu Direquest Lagi' As respon, 0 As responCode
			  From dbo.farmasiIMF a
				   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
						Inner Join dbo.farmasiMasterObatJenisStok ba On b.idJenisStok = ba.idJenisStok
				   Inner Join dbo.masterOperator c On a.idDokter = c.idOperator
			 Where idPendaftaranPasien = @idPendaftaranPasien And idDokter = @idDokter;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[farmasiIMF]
					   ([idPendaftaranPasien]
					   ,[idRuangan]
					   ,[idDokter]
					   ,[tglIMF]
					   ,[tglEntry]
					   ,[idUserEntry])
				 VALUES
					   (@idPendaftaranPasien
					   ,@idRuangan
					   ,@idDokter
					   ,@tglIMF
					   ,GetDate()
					   ,1);

			Select 'Permintaan Instruksi Medis Farmasi Berhasil Disimpan' As respon, 1 As responCode;
		END
END