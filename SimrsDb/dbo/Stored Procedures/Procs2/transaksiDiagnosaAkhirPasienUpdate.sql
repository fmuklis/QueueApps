-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiDiagnosaAkhirPasienUpdate]
	-- Add the parameters for the stored procedure here
	@idDiagNosa int
	,@idMasterICD int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPendaftaranPasien int = (Select idPendaftaranPasien From dbo.transaksiDiagnosaPasien Where idDiagnosa = @idDiagNosa);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiDiagnosaPasien Where idPendaftaranPasien = @idPendaftaranPasien And idMasterICD = @idMasterICD)
		Begin
			Select 'Tidak Dapat Disimpan, Sudah Ada Kode ICD Yang Sama' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE dbo.transaksiDiagnosaPasien
			   SET idMasterICD = @idMasterICD
			 WHERE idDiagnosa = @idDiagNosa
			Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
		End
END