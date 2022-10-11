-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuanganUpdate]
	-- Add the parameters for the stored procedure here
	@idRuangan int
	,@Alias nvarchar(50)
	,@namaRuangan nvarchar(50)
	,@idJenisStok int
	,@idJenisRuangan int
	,@idMasterPelayanan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.masterRuangan Where idRuangan <> @idRuangan And namaRuangan = @namaRuangan)
		Begin
			/*UPDATE Edit Data Ruangan*/
			UPDATE dbo.masterRuangan
			   SET [Alias] = @Alias
				  ,[namaRuangan] = @namaRuangan
				  ,[idJenisRuangan] = @idJenisRuangan
				  ,[idJenisStok] = @idJenisStok
			 WHERE idRuangan = @idRuangan;
			
			If NULLIF(@idMasterPelayanan,'') Is Null
				Begin
					DELETE dbo.masterRuanganPelayanan
					 WHERE idRuangan = @idRuangan;
				End
			Else If Exists(Select 1 From dbo.masterRuanganPelayanan Where idRuangan = @idRuangan)
				Begin
					UPDATE dbo.masterRuanganPelayanan
					   SET idMasterPelayanan = @idMasterPelayanan
					 WHERE idRuangan = @idRuangan;
				End
			Else
				Begin
					INSERT INTO dbo.masterRuanganPelayanan
							   (idMasterPelayanan
							   ,idRuangan)
						 VALUES
							   (@idMasterPelayanan
							   ,@idRuangan)	
				End

			SELECT 'Data Ruangan Berhasil Diupdate' As respon, 1 As responCode;
		End
	Else
		Begin
			SELECT 'Gagal!: Ruangan '+ @namaRuangan +' Sudah Ada' As respon, 0 As responCode;
		End
END