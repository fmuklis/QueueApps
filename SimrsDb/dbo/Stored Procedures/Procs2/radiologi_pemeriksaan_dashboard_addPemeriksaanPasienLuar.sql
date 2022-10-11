-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_dashboard_addPemeriksaanPasienLuar]
	-- Add the parameters for the stored procedure here
	@nama varchar(250),
	@idJenisKelamin tinyint,
	@tglLahir date,
	@alamat varchar(250),
	@dokter varchar(250),
	@tlp varchar(15),
    @tglOrder datetime,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPasienLuar bigint
		   ,@idOrder bigint;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*INSERT Entry Data Pasien Luar*/
	INSERT INTO [dbo].[masterPasienLuar]
			   ([nama]
			   ,[idJenisKelamin]
			   ,[tglLahir]
			   ,[alamat]
			   ,[dokter]
			   ,[tlp])
		 VALUES
			   (@nama
			   ,@idJenisKelamin
			   ,@tglLahir
			   ,@alamat
			   ,@dokter
			   ,@tlp);

	/*GET idPasienLuar*/
	SET @idPasienLuar = SCOPE_IDENTITY();

	/*INSERT Entry Data Order Lab*/
	INSERT INTO [dbo].[transaksiOrder]
			   ([idRuanganTujuan]
			   ,[idPasienLuar]
			   ,[tglOrder]
			   ,[idUserEntry]
			   ,[idStatusOrder]
			   ,[idUserTerima])
		 VALUES
			   (6/*Radiologi*/
			   ,@idPasienLuar
			   ,@tglOrder
			   ,@idUserEntry
			   ,2/*Diterima*/
			   ,@idUserEntry);
		
	/*GET idOrder*/
	SET @idOrder = SCOPE_IDENTITY();

	SELECT 'Data Pemeriksaan Radiologi Pasien Luar Berhasil Disimpan' AS respon, 1 AS responCode, @idOrder AS idOrder;								
END