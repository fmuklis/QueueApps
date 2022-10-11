-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiDiagnosaPasienUpdate]
	-- Add the parameters for the stored procedure here
	@idDiagNosa int
	,@idOperator int
	,@tglDiagnosa date
	,@idMasterDiagnosa int
	,@primer bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPendaftaranPasien int 
		   ,@idPasien int;

	 Select Distinct @idPendaftaranPasien = a.idPendaftaranPasien, @idPasien = b.idPasien 
	   From dbo.transaksiDiagnosaPasien a
			Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
	  Where idDiagNosa = @idDiagNosa;

	If IsNull(@primer, 0) = 0 And Not Exists(Select 1 From dbo.transaksiDiagnosaPasien Where idPendaftaranPasien = @idPendaftaranPasien And idDiagNosa <> @idDiagNosa And primer = 1)
		Begin
			SET @primer = 1;
		End

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiDiagnosaPasien Where idDiagNosa = @idDiagNosa)
		Begin Try
			If @primer = 1
				Begin
					UPDATE dbo.transaksiDiagnosaPasien
					   SET [primer] = 0
					 WHERE idPendaftaranPasien = @idPendaftaranPasien;

					UPDATE a
					   SET idDokter = @idOperator
					  FROM dbo.transaksiPendaftaranPasien a
						   Inner Join dbo.transaksiDiagnosaPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
					 WHERE b.idDiagnosa = @idDiagNosa;
				End

			UPDATE [dbo].[transaksiDiagnosaPasien]
			   SET [idMasterDiagnosa] = @idMasterDiagnosa
				  ,[idDokter] = @idOperator
				  ,[tglDiagnosa] = @tglDiagnosa
				  ,[primer] = @primer
				  ,[baru] = Case
								 When Exists(Select 1 From dbo.transaksiDiagnosaPasien a
													Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
											  Where b.idPasien = @idPasien And a.idPendaftaranPasien <> @idPendaftaranPasien And a.idMasterDiagnosa = @idMasterDiagnosa)
									  Then 0
								 Else 1
							 End
			 WHERE idDiagNosa = @idDiagNosa;
			
			/*Update Data DPJP Pada Tabel Pendaftaran*/
			If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien And IsNull(idDokter, 0) <> @idOperator)
				Begin
					UPDATE dbo.transaksiPendaftaranPasien
					   SET idDokter = @idOperator
					 WHERE idPendaftaranPasien = @idPendaftaranPasien;
				End
			Select 'Diagnosa Berhasil Diupdate' As respon, 1 As responCode;
		End Try
		Begin Catch
			Select 'Error !: ' + ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
	Else
		Begin
			Select 'Data Tidak Ditemukan' As respon, 0 As responCode;
		End
END