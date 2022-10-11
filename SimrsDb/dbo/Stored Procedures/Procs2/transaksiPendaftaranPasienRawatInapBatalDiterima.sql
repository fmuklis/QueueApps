-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienRawatInapBatalDiterima]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien And idStatusPendaftaran In(2,5))
		Begin
			Select 'Gagal!: Pasien '+ b.namaStatusPendaftaran as respon, 0 as responCode
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterStatusPendaftaran b on a.idStatusPendaftaran = b.idStatusPendaftaran
			Where a.idPendaftaranPasien = @idPendaftaranPasien; 
		End
	Else If Exists(Select 1 From dbo.transaksiPendaftaranPasienDetail Where idPendaftaranPasien = @idPendaftaranPasien Having Count(idPendaftaranPasienDetail) > 1)
		Begin
			Select 'Gagal!: Pasien Pernah Pindah Kamar, Jika Pasien Salah Kamar Harap Hubungi Petugas Admisi' as respon, 0 as responCode; 
		End
	Else
		Begin Try
			Begin Tran tranzRegPasienRaNapBatalDiterima;
			/*DELETE Tindakan Pasien*/
			DELETE a
			  FROM dbo.transaksiTindakanPasien a
				   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan And b.idJenisRuangan = 2/*Instalasi Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*DELETE Order Resep*/
			DELETE a
			  FROM dbo.farmasiResep a
				   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan And b.idJenisRuangan = 2/*Instalasi Rawat Inap*/
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
			
			/*DELETE Order Pasien*/
			DELETE a
			  FROM dbo.transaksiOrder a
				   Inner Join dbo.masterRuangan b On a.idRuanganAsal = b.idRuangan And b.idJenisRuangan = 2/*Instalasi Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*DELETE Diagnosa Pasien*/
			DELETE a
			  FROM dbo.transaksiDiagnosaPasien a
				   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan And b.idJenisRuangan = 2/*Instalasi Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Status Order Rawat Inap*/
			UPDATE [dbo].[transaksiOrderRawatInap]
			   SET [idStatusOrderRawatInap] = 2/*Selesai Pendaftaran Admisi*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Status Pendaftaran Rawat Inap*/
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET idStatusPendaftaran = 4/*Order RaNap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Billing Tagihan Rawat Jalan Atau IGD*/
			UPDATE a
			   SET idJenisBilling = Case
										 When b.idJenisRuangan = 1
											  Then 5/*Bill Tagihan IGD*/
										 When b.idJenisRuangan = 3 
											  Then 1/*Bill Tagihan RaJal*/
										 When b.idJenisRuangan = 4
											  Then 2/*Bill Tagihan Lab*/
										 When b.idJenisRuangan = 10 
											  Then 4/*Bill Tagihan Radiologi*/
									 End
			  FROM dbo.transaksiTindakanPasien a
				   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
				   Left Join dbo.transaksiBillingHeader c On a.idJenisBilling = c.idJenisBilling And a.idPendaftaranPasien = c.idPendaftaranPasien
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien And c.idJenisBayar is Null;

			Select 'Pasien Batal Dirawat, Data Berhasil Diupdate' as respon, 1 as responCode;
			Commit Tran tranzRegPasienRaNapBatalDiterima;
		End Try
		Begin Catch
			Rollback Tran tranzRegPasienRaNapBatalDiterima;
			Select 'Error!:'+ ERROR_MESSAGE() As respon, null As responCode;
		End Catch
END