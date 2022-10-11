-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiDiagnosaPasienDetailInsert]
	-- Add the parameters for the stored procedure here
	@idDiagnosa int
	,@sekunder bit
	,@idPenyakit int
	,@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiDiagnosaPasienDetail Where idDiagnosa = @idDiagnosa And idPenyakit = @idPenyakit)
		Begin
			Select 'Data Sudah Ada' As respon, 0 As responCode;
		End
	Else
		Begin
			INSERT INTO [dbo].[transaksiDiagnosaPasienDetail]
					   ([idDiagnosa]
					   ,[sekunder]
					   ,[idPenyakit]
					   ,[idUserEntry]
					   ,[tglEntry])
				 VALUES
					   (@idDiagnosa
					   ,@sekunder
					   ,@idPenyakit
					   ,@idUserEntry
					   ,GetDate());
			If Exists(Select 1 From dbo.transaksiDiagnosaPasien a
							 Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
					   Where a.idDiagnosa = @idDiagnosa And b.idStatusPendaftaran = 99)
				Begin
					UPDATE b
					   SET b.idStatusPendaftaran = 100
					  FROM dbo.transaksiDiagnosaPasien a
						   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
					 WHERE a.idDiagnosa = @idDiagnosa
				End
			Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
		End
END