-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterDiagnosaDelete]
	-- Add the parameters for the stored procedure here
	@idMasterDiagnosa int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiDiagnosaPasien Where idMasterDiagnosa = @idMasterDiagnosa)
		Begin
			Select 'Tidak Dapat Dihapus, Diagnosa Telah Dipakai Di Pelayanan' As respon, 0 As responCodel
		End
	Else
		Begin
			DELETE dbo.masterDiagnosa
			 WHERE idMasterDiagnosa = @idMasterDiagnosa;

			Select 'Master Diagnosa Berhasil Dihapus' As respon, 1 As responCode;
		End
END