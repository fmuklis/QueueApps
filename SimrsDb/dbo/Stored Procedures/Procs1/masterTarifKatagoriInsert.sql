-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTarifKatagoriInsert]
	-- Add the parameters for the stored procedure here
	@namaMasterKatagoriTarif Nvarchar(50),
	@namaMasterKatagoriInProgram Nvarchar(50),
	@idMasterKatagoriJenis int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	If Not Exists(Select 1 From [dbo].[masterTarifKatagori] Where [namaMasterKatagoriTarif] = @namaMasterKatagoriTarif)
		Begin
			INSERT INTO [dbo].[masterTarifKatagori]
					   ([namaMasterKatagoriTarif]
					   ,[namaMasterKatagoriInProgram]
					   ,[idMasterKatagoriJenis])
				 VALUES
					   (@namaMasterKatagoriTarif
					   ,@namaMasterKatagoriInProgram
					   ,@idMasterKatagoriJenis);

				Select 'Data Berhasil Disimpan' respon, 1 responCode;
		End
	Else 
		Begin
			Select 'Data Sudah Ada' respon, 0 responCode;
		End
END