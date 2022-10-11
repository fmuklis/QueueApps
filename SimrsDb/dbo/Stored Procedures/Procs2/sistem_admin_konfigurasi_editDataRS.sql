-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sistem_admin_konfigurasi_editDataRS] 
	-- Add the parameters for the stored procedure here

	@kodeRS varchar(200),
	@namaRumahSakit varchar(200),
	@namaPendekRumahSakit varchar(200),
	@headerSurat1 varchar(200),
	@alamat varchar(200),
	@kodePos varchar(200),
	@telp varchar(200),
	@email varchar(200),
	@namaDirektur varchar(200),
	@namaSekretaris varchar(200),
	@kota varchar(200),
	@kabupaten varchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

      -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterKonfigurasi)
		BEGIN
			UPDATE dbo.masterRumahSakit
			   SET kodeRS = @kodeRS
				  ,namaRumahSakit = @namaRumahSakit
				  ,namaPendekRumahSakit = @namaPendekRumahSakit
				  ,headerSurat1 = @headerSurat1
				  ,alamat = @alamat
				  ,kodePos = @kodePos
				  ,telp = @telp
				  ,email = @email
				  ,namaDirektur = @namaDirektur
				  ,namaSekretaris = @namaSekretaris
				  ,kota = @kota
				  ,kabupaten=@kabupaten

			SELECT 'Data Rumah Sakit Berhasil Diupdate' AS respon, 1 AS responCode
		END
	ELSE
		BEGIN
			INSERT INTO dbo.masterRumahSakit
					   (kodeRS
					   ,namaRumahSakit
					   ,namaPendekRumahSakit
					   ,headerSurat1
					   ,alamat
					   ,kodePos
					   ,telp
					   ,email
					   ,namaDirektur
					   ,namaSekretaris
					   ,kota
					   ,kabupaten)
				 VALUES
					   (@kodePos
					   ,@namaRumahSakit
					   ,@namaPendekRumahSakit
					   ,@headerSurat1
					   ,@alamat
					   ,@kodePos
					   ,@telp
					   ,@email
					   ,@namaDirektur
					   ,@namaSekretaris
					   ,@kota
					   ,@kabupaten)

			SELECT 'Data Rumah Sakit Berhasil Disimpan' AS respon, 1 AS responCode
		END
END