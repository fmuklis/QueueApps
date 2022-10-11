-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiDiagnosaIGDInsert]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
	,@idMasterDiagnosa int
	,@tglDiagnosa date
	,@idDokter int
	,@idUserEntry int
	,@idRuangan int
	,@idPelayananIGD int
	,@primer bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPasien int = (Select idPasien From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiDiagnosaPasien Where idPendaftaranPasien = @idPendaftaranPasien And idMasterDiagnosa = @idMasterDiagnosa)
		Begin
			If @primer = 1
				Begin
					UPDATE dbo.transaksiDiagnosaPasien
					   SET [primer] = 0
					 WHERE idPendaftaranPasien = @idPendaftaranPasien;

					UPDATE dbo.transaksiPendaftaranPasien
					   SET idPelayananIGD = @idPelayananIGD
						  ,idDokter = @idDokter
					 WHERE idPendaftaranPasien = @idPendaftaranPasien;
				End

			INSERT INTO [dbo].[transaksiDiagnosaPasien]
					   ([idPendaftaranPasien]
					   ,[idMasterDiagnosa]
					   ,[idDokter]
					   ,[tglDiagnosa]
					   ,[tglEntry]
					   ,[idRuangan]
					   ,[idUserEntry]
					   ,[primer]
					   ,[baru])
				 VALUES
					   (@idPendaftaranPasien
					   ,@idMasterDiagnosa
					   ,@idDokter
					   ,@tglDiagnosa
					   ,GetDate()
					   ,@idRuangan
					   ,@idUserEntry
					   ,@primer
					   ,Case
							 When Exists(Select 1 From dbo.transaksiDiagnosaPasien a
												Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
										  Where b.idPasien = @idPasien And a.idPendaftaranPasien <> @idPendaftaranPasien And a.idMasterDiagnosa = @idMasterDiagnosa)
								  Then 0
							 Else 1
						 End);

			Select 'Diagnosa Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Gagal!: Sudah Ada Diagnosa Yang Sama' As respon, 0 As responCode;
		End
END