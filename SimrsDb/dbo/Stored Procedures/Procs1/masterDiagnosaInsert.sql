-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterDiagnosaInsert]
	-- Add the parameters for the stored procedure here
	@idGolonganPenyakit int
	,@alias nvarchar(50)
	,@diagnosa nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.masterDiagnosa Where alias = Trim(@alias) Or diagnosa = Trim(@diagnosa))
		Begin
			Select 'Gagal!: Sudah Ada Diagnosa Yang Sama' As respon, 0 As responCode;
		End
	Else
		Begin
			INSERT INTO [dbo].[masterDiagnosa]
					   ([idGolonganPenyakit]
					   ,[diagnosa]
					   ,[alias])
				 VALUES
					   (@idGolonganPenyakit
					   ,Trim(@diagnosa)
					   ,Trim(@alias));
			Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
		End
END