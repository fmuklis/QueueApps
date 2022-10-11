-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasiMutasiInsert] 
	-- Add the parameters for the stored procedure here
	@idJenisStokAsal int
	,@idRuangan int
	,@tglMutasi date
	,@userEntry int
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisStokTujuan int = (Select idJenisStok From dbo.masterRuangan Where idRuangan = @idRuangan)
		   ,@idMutasi int;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*If Not Exists(Select 1 From dbo.farmasiMutasi Where idJenisStokAsal = @idJenisStokAsal And idJenisStokTujuan = @idJenisStokTujuan And tglMutasi = @tglMutasi And idStatusMutasi = 1/*Permintaan Mutasi*/)
		Begin
			INSERT INTO [dbo].[farmasiMutasi]
					   ([idJenisStokAsal]
					   ,[idJenisStokTujuan]
					   ,[idRuangan]
					   ,[idUserEntry]
					   ,[tglMutasi]
					   ,[tglEntry]
					   ,idStatusMutasi)
				 VALUES
					   (@idJenisStokAsal
					   ,@idJenisStokTujuan
					   ,@idRuangan
					   ,@userEntry
					   ,@tglMutasi
					   ,GetDate()
					   ,1);
		End
	Select idMutasi, 1 As respon
	  From dbo.farmasiMutasi 
	 Where idJenisStokAsal = @idJenisStokAsal And idJenisStokTujuan = @idJenisStokTujuan And tglMutasi = @tglMutasi And idStatusMutasi = 1/*Permintaan Mutasi*/;*/
END