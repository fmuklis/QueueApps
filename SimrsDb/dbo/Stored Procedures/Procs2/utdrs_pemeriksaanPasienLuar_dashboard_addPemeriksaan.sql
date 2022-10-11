-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[utdrs_pemeriksaanPasienLuar_dashboard_addPemeriksaan]
	-- Add the parameters for the stored procedure here
	@nama nvarchar(250),
	@idJenisKelamin int,
	@tglLahir date,
	@alamat nvarchar(250),
	@dokter nvarchar(250),
	@tlp nvarchar(15),
    @tglOrder datetime,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPasienLuar bigint
		   ,@idOrder int;
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Begin Try
		/*Transaction Begin*/
		Begin Tran;

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
				   (57/*UTDRS*/
				   ,@idPasienLuar
				   ,@tglOrder
				   ,@idUserEntry
				   ,2/*Diterima*/
				   ,@idUserEntry);
		
		/*GET idOrder*/
		SET @idOrder = SCOPE_IDENTITY();

		/*Transaction Commit*/
		Commit Tran;
		
		/*Respon*/		   	
		Select 'Data Permintaan UTDRS Pasien Luar Berhasil Disimpan' As respon, 1 As responCode, @idOrder As idOrder;								
	End Try
	Begin Catch
		/*Rollback Commit*/
		Rollback Tran;
		
		/*Respon*/		   	
		Select 'Error!: ' As respon, 0 As responCode;
	End Catch
END