-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 15-10-2018
-- Description:	Insert To Master Ruangan & Master Ruangan Pelayanan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuangan_Insert] 
	-- Add the parameters for the stored procedure here

	--Master Ruangan
	 @namaRuangan nvarchar(50)
	,@idJenisRuangan int
	--Master Ruangan Pelayanan
	,@idMasterPelayanan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuangan int

	SET NOCOUNT ON;   
		
			If Not Exists ( Select 1 From [masterRuangan] Where namaRuangan = @namaRuangan)	
				Begin			
				
					INSERT INTO [dbo].[masterRuangan]
							   ([namaRuangan]
							   ,[idJenisRuangan])
						 VALUES
							   (UPPER(@namaRuangan)
							   ,@idJenisRuangan);										
				End	
			Select @idRuangan = idRuangan From [masterRuangan] Where namaRuangan = @namaRuangan;
			If @idMasterPelayanan! = 0
			Begin
			If not exists(Select 1 from masterRuanganPelayanan where idRuangan = @idRuangan and idMasterPelayanan = @idMasterPelayanan)
				Begin	
					INSERT INTO [dbo].[masterRuanganPelayanan]
							   ([idRuangan]
							   ,[idMasterPelayanan])
						 VALUES
							   (@idRuangan
							   ,@idMasterPelayanan);
					SELECT 'Data Berhasil Disimpan' respon, 1 responCode;
				End				
			ELSE 
				BEGIN
					SELECT 'Data Sudah Ada' respon, 0 responCode;
				END
			End
			else
			Begin
				SELECT 'Data Berhasil Disimpan' respon, 1 responCode;
			End
END