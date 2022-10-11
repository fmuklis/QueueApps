-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[operasi_tindakan_entryTindakan_deleteDiagnosaPasien]
	-- Add the parameters for the stored procedure here
	 @idDiagnosa int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiDiagnosaPasien Where idDiagNosa = @idDiagNosa And primer = 1)
		Begin
			Select 'Diagnosa Primer Tidak Dapat Dihapus' As respon, 0 As responCode;
		End
	Else
		Begin
			DELETE dbo.transaksiDiagnosaPasien
			 WHERE idDiagNosa = @idDiagNosa;
			Select 'Diagnosa Berhasil Dihapus' As respon, 1 As responCode;
		End
END