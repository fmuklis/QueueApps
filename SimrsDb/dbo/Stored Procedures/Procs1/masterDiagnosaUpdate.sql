-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterDiagnosaUpdate]
	-- Add the parameters for the stored procedure here
	@idMasterDiagnosa int
	,@idGolonganPenyakit int
	,@diagnosa nvarchar(250)
	,@alias nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.masterDiagnosa Where idMasterDiagnosa = @idMasterDiagnosa)
		Begin
			Select 'Data Tidak Ditemukan' As respon, 0 As responCode;
		End
	Else If Exists(Select 1 From dbo.masterDiagnosa Where idMasterDiagnosa <> @idMasterDiagnosa And diagnosa = Trim(@diagnosa))
		Begin
			Select 'Tidak Dapat Diupdate, Sudah Ada Diagnosa Yang Sama' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE dbo.masterDiagnosa
			   SET idGolonganPenyakit = @idGolonganPenyakit
				  ,diagnosa = @diagnosa
				  ,alias = @alias
			 WHERE idMasterDiagnosa = @idMasterDiagnosa;
			Select 'Diagnosa Berhasil Diupdate' As respon, 1 As responCode;
		End
END