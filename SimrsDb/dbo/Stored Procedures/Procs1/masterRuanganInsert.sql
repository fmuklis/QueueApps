-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 15-10-2018
-- Description:	Insert To Master Ruangan & Master Ruangan Pelayanan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuanganInsert] 
	-- Add the parameters for the stored procedure here
	@Alias nvarchar(50)
	,@namaRuangan nvarchar(50)
	,@idJenisRuangan int
	,@idJenisStok int
	,@idMasterPelayanan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuangan int

	SET NOCOUNT ON;   
	If Exists(Select 1 From dbo.masterRuangan Where namaRuangan = @namaRuangan)	
		Begin
			Select 'Gagal!: Ruangan '+ @namaRuangan +' Sudah Ada' As respon, 0 As responCode;
		End
	Else
		Begin			
			INSERT INTO [dbo].[masterRuangan]
					   ([Alias]
					   ,[namaRuangan]
					   ,[idJenisRuangan]
					   ,[idJenisStok])
				 VALUES
					   (@Alias
					   ,@namaRuangan
					   ,@idJenisRuangan
					   ,@idJenisStok);							
			

			/*GET idRuangan*/
			Select @idRuangan = idRuangan From dbo.masterRuangan Where namaRuangan = @namaRuangan;

			If IsNull(@idMasterPelayanan, 0) <> 0 And Not Exists(Select 1 From dbo.masterRuanganPelayanan Where idRuangan = @idRuangan)
				Begin
					INSERT INTO [dbo].[masterRuanganPelayanan]
							   ([idRuangan]
							   ,[idMasterPelayanan])
						 VALUES
							   (@idRuangan
							   ,@idMasterPelayanan);
				End				
			Select 'Data Ruangan Berhasil Disimpan' respon, 1 responCode;
		End
END