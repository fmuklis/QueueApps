-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_addOrderResep] 
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
    ,@idRuangan int
    ,@idDokter int
    ,@tglResep date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	If Not Exists(Select 1 From dbo.farmasiResep Where idPendaftaranPasien = @idPendaftaranPasien And idRuangan = @idRuangan And idDokter = @idDokter And idStatusResep = 1)
		Begin
			INSERT INTO [dbo].[farmasiResep]
					   ([idPendaftaranPasien]
					   ,[idRuangan]
					   ,[idDokter]
					   ,[tglResep]
					   ,[idStatusResep])
				 VALUES
					   (@idPendaftaranPasien
					   ,@idRuangan
					   ,@idDokter
					   ,@tglResep
					   ,1);
		End
	Select 'Permintaan Resep Berhasil Disimpan' As respon, 1 As responCode;
END