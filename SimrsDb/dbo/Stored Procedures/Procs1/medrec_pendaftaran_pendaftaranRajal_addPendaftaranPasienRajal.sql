-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addPendaftaranPasienRajal]
	-- Add the parameters for the stored procedure here
	 @idPasien int
	,@idRuangan int
	,@idUser int
	,@rujukan bit
	,@idAsalPasien int
	,@tglDaftar date
	,@idJenisPenjaminPembayaranPasien int
	,@noPenjamin nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idpendaftaranPasien int
		   ,@currentDate datetime = GETDATE();

	If Not Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPasien = @idPasien And idStatusPendaftaran < 99)
		Begin			
			INSERT INTO [dbo].[transaksiPendaftaranPasien]
					   ([idPasien]
					   ,[noReg]
					   ,[idJenisPendaftaran]
					   ,[idJenisPerawatan]
					   ,[tglDaftarPasien]
					   --,[jamMasukPasien]
					   ,[rujukan]
					   ,[idAsalPasien]
					   ,[idRuangan]
					   ,[idTempatTidur]
					   ,[idUser]
					   ,[tglEntry]
					   ,[idStatusPendaftaran]
					   ,[idJenisPenjaminPembayaranPasien]
					   ,idKelas)
				 VALUES
					   (@idPasien
					   ,dbo.noRegister()
					   ,2/*Pendaftaran Rawat Jalan*/
					   ,2/*Perawatan Rawat Jalan*/
					   ,CONCAT(@tglDaftar, ' ', CAST(@currentDate AS time(3)))
					   --,@currentDate
					   ,@rujukan
					   ,@idAsalPasien
					   ,@idRuangan
					   ,13/*idTempat Tidur non rawat inap*/
					   ,@idUser
					   ,@currentDate
					   ,1/*Pendafatran*/
					   ,@idJenisPenjaminPembayaranPasien
					   ,99/*Non Kelas*/);

			/*GET idpendaftaranPasien*/
			SET @idpendaftaranPasien = SCOPE_IDENTITY();

			If Exists(Select 1 From dbo.transaksiDataPenjamin a
							 Inner Join dbo.transaksiPendaftaranPasien b On a.idPasien = b.idPasien And a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
					   Where b.idPendaftaranPasien = @idPendaftaranPasien)
				Begin
					UPDATE a
					   SET a.noPenjamin = @noPenjamin
					  FROM dbo.transaksiDataPenjamin a
						   Inner Join dbo.transaksiPendaftaranPasien b On a.idPasien = b.idPasien And a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
					 WHERE b.idPendaftaranPasien = @idPendaftaranPasien;
				End
			Else
				Begin
					INSERT INTO dbo.transaksiDataPenjamin
							   (idPasien
							   ,idJenisPenjaminPembayaranPasien
							   ,noPenjamin)
						 SELECT a.idPasien
							   ,a.idJenisPenjaminPembayaranPasien
							   ,@noPenjamin
						   FROM dbo.transaksiPendaftaranPasien a
						  WHERE idPendaftaranPasien = @idPendaftaranPasien;
				End

			Select 'Data Berhasil Disimpan' As respon, 1 As responCode, @idpendaftaranPasien As idPendaftaranPasien
				  ,Case 
						When cetakKartu Is null 
							 Then 0
						Else 1
					End As flagCetakkartu
			  From dbo.masterPasien 
			 Where idPasien = @idPasien;
		End 
	Else
		Begin
			Select 'Pasien Telah Terdaftar, Dan Masih Dalam '+ b.namaStatusPendaftaran +' Di '+ c.namaRuangan As respon, 0 As responCode
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterStatusPendaftaran b On a.idStatusPendaftaran = b.idStatusPendaftaran
				   Inner Join dbo.masterRuangan c On a.idRuangan = c.idRuangan
			 Where a.idPasien = @idPasien And a.idStatusPendaftaran < 99;
		End	  	
			    
	/*If Exists (Select 1 From dbo.transaksiPendaftaranPasien
			   Where idJenisPendaftaran = 1--idJenisPerawatan = 2 And  --And idJenisPenjaminPembayaranPasien <>1
					 And idStatusPendaftaran <> 99 And CONVERT(date,tglEntry) < =  DATEADD(day,-1,GETDATE()))	
		Begin
			Update dbo.transaksiPendaftaranPasien 
			   Set idStatusPendaftaran = 99 
			 Where idJenisPendaftaran = 1 And--idJenisPerawatan = 2 And  idJenisPenjaminPembayaranPasien <>1
				   idStatusPendaftaran = 98 And CONVERT(date, tglEntry) < =  DATEADD(day,-1,GETDATE());
		End*/
END