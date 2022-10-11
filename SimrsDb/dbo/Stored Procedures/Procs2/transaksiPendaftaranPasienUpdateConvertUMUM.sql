-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienUpdateConvertUMUM]
	 @idPendaftaranPasien int
	 ,@idJenisPenjaminPembayaranPasien int
	 ,@idKelasPenjaminPembayaran int
	 ,@idUser int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisBilling int = Case
									   When Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idJenisPerawatan = 1/*RaNap*/ And idPendaftaranPasien = @idPendaftaranPasien)
											Then 6/*Billing Rawat Inap*/
									   When Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idJenisPerawatan = 2/*RaJal*/ And idJenisPendaftaran = 1/*IGD*/ And idPendaftaranPasien = @idPendaftaranPasien)
											Then 5/*Billing IGD*/
									   Else 1/*Billing Poli Rawat Jalan*/
								   End
	Declare @pasienRaJal bit = Case 
									When @idJenisBilling = 6
										 Then 1
									Else 0
								End

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idStatusPendaftaran > = 99 And idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Gagal!: Pasien '+ b.namaStatusPendaftaran As respon, 0 As responCode
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterStatusPendaftaran b On a.idStatusPendaftaran = b.idStatusPendaftaran
			 Where a.idPendaftaranPasien = @idPendaftaranPasien;
		End
	Else
		Begin Try
			Begin Tran tranzRegPasienUpdateConvUMUM78;
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idJenisPenjaminPembayaranPasien = @idJenisPenjaminPembayaranPasien
				  ,idKelasPenjaminPembayaran = @idKelasPenjaminPembayaran
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			If @pasienRaJal = 1
				Begin
					/*Pemeriksaan Labor*/
					If Exists(Select 1 From dbo.transaksiTindakanPasien a
									 Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
							   Where b.idJenisRuangan = 4/*Instalasi Laboratorium*/ And a.idPendaftaranPasien = @idPendaftaranPasien)
						Begin
							INSERT INTO [dbo].[transaksiBillingHeader]
									   ([kodeBayar]
									   ,[idPendaftaranPasien]
									   ,[idOrder]
									   ,[idJenisBilling]
									   ,[idUserEntry]
									   ,[keterangan])
								 SELECT dbo.noKwitansi()
									   ,a.idPendaftaranPasien
									   ,a.idOrder
									   ,2/*Billing Laboratorium*/
									   ,@idUser
									   ,'Convert From BPJS To UMUM'
								   FROM dbo.transaksiOrder a
										Inner Join (Select xb.idOrder
													  From dbo.transaksiTindakanPasien xa
														   Inner Join dbo.transaksiOrderDetail xb On xa.idOrderDetail = xb.idOrderDetail
														   Inner Join dbo.masterRuangan xc On xa.idRuangan = xc.idRuangan
													 Where xc.idJenisRuangan = 4/*Instalasi Laboratorium*/ And xa.idPendaftaranPasien = @idPendaftaranPasien
												  Group By xb.idOrder) b On a.idOrder = b.idOrder;
						End
					/*Pemeriksaan Radiologi*/
					If Exists(Select 1 From dbo.transaksiTindakanPasien a
									 Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
							   Where b.idJenisRuangan = 10/*Instalasi Radiologi*/ And a.idPendaftaranPasien = @idPendaftaranPasien)
						Begin
							INSERT INTO [dbo].[transaksiBillingHeader]
									   ([kodeBayar]
									   ,[idPendaftaranPasien]
									   ,[idOrder]
									   ,[idJenisBilling]
									   ,[idUserEntry]
									   ,[keterangan])
								 SELECT dbo.noKwitansi()
									   ,a.idPendaftaranPasien
									   ,a.idOrder
									   ,4/*Billing Radiologi*/
									   ,@idUser
									   ,'Convert From BPJS To UMUM'
								   FROM dbo.transaksiOrder a
										Inner Join (Select xb.idOrder
													  From dbo.transaksiTindakanPasien xa
														   Inner Join dbo.transaksiOrderDetail xb On xa.idOrderDetail = xb.idOrderDetail
														   Inner Join dbo.masterRuangan xc On xa.idRuangan = xc.idRuangan
													 Where xc.idJenisRuangan = 10/*Instalasi Radiologi*/ And xa.idPendaftaranPasien = @idPendaftaranPasien
												  Group By xb.idOrder) b On a.idOrder = b.idOrder;
						End
					/*Resep*/
					If Exists(Select 1 From dbo.farmasiResep a
									 Inner Join dbo.farmasiPenjualanHeader b On a.idResep = b.idResep
											Inner Join dbo.farmasiPenjualanDetail ba On b.idPenjualanHeader = ba.idPenjualanHeader
							   Where a.idPendaftaranPasien = @idPendaftaranPasien)
						Begin
							INSERT INTO [dbo].[transaksiBillingHeader]
									   ([kodeBayar]
									   ,[idPendaftaranPasien]
									   ,[idResep]
									   ,[idJenisBilling]
									   ,[idUserEntry]
									   ,[keterangan])
								 SELECT dbo.noKwitansi()
									   ,a.idPendaftaranPasien
									   ,a.idResep
									   ,3/*Billing Farmasi*/
									   ,@idUser
									   ,'Convert From BPJS To UMUM'
								   FROM dbo.farmasiResep a
										Inner Join (Select xa.idResep
													  From dbo.farmasiResep xa
														   Inner Join dbo.farmasiPenjualanHeader xb On xa.idResep = xb.idResep
														   Inner Join dbo.farmasiPenjualanDetail xc On xb.idPenjualanHeader = xc.idPenjualanHeader
													 Where xa.idPendaftaranPasien = @idPendaftaranPasien
												  Group By xa.idResep) b On a.idResep = b.idResep;
							UPDATE a
							   SET a.idStatusPenjualan = 2/*Siap Dibayar*/
							  FROM dbo.farmasiPenjualanHeader a
								   Inner Join dbo.farmasiResep b On a.idResep = b.idResep
							 WHERE a.idStatusPenjualan = 3/*Telah Dibayar*/ And b.idPendaftaranPasien = @idPendaftaranPasien;
						End
						If Not Exists(Select 1 FRom dbo.transaksiBillingHeader Where idJenisBilling = @idJenisBilling And idPendaftaranPasien = @idPendaftaranPasien)
							Begin
								/*INSERT Billing Tindakan*/
								INSERT INTO [dbo].[transaksiBillingHeader]
											   ([kodeBayar]
											   ,[idPendaftaranPasien]
											   ,[idJenisBilling]
											   ,[idUserEntry]
											   ,[keterangan])
										VALUES (dbo.noKwitansi()
											  ,@idPendaftaranPasien
											  ,@idJenisBilling
											  ,@idUser
											  ,'Convert From BPJS To UMUM');
							End
				End
			Else
				Begin
					UPDATE a
					   SET a.idStatusPenjualan = 2/*Siap Dibayar*/
					  FROM dbo.farmasiPenjualanHeader a
						   Inner Join dbo.farmasiResep b On a.idResep = b.idResep
					 WHERE a.idStatusPenjualan = 3/*Telah Dibayar*/ And b.idPendaftaranPasien = @idPendaftaranPasien;

					If Not Exists(Select 1 From dbo.transaksiBillingHeader Where idJenisBilling = @idJenisBilling And idPendaftaranPasien = @idPendaftaranPasien)
						Begin
							/*INSERT Billing Tindakan*/
							INSERT INTO [dbo].[transaksiBillingHeader]
									   ([kodeBayar]
									   ,[idPendaftaranPasien]
									   ,[idJenisBilling]
									   ,[idUserEntry]
									   ,[keterangan])
								VALUES (dbo.noKwitansi()
									  ,@idPendaftaranPasien
									  ,@idJenisBilling
									  ,@idUser
									  ,'Convert From BPJS To UMUM');
							End
				End
			Commit Tran tranzRegPasienUpdateConvUMUM78;
			Select 'Berhasil, Penjamin Pembayaran Pasien Berubah Ke UMUM' As respon, 1 As responCode;
		End Try
		Begin Catch
			Rollback Tran tranzRegPasienUpdateConvUMUM78;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch

END