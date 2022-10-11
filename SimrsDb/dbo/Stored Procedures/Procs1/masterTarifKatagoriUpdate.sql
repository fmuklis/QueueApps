-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTarifKatagoriUpdate]
	-- Add the parameters for the stored procedure here
	@idMasterKatagoriTarip int,
	@namaMasterKatagoriTarif nvarchar(50),
	@namaMasterKatagoriInProgram nvarchar(50),
	@idMasterKatagoriJenis int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	If Exists(Select 1 From dbo.masterTarifKatagori 
			   Where idMasterKatagoriTarip <> @idMasterKatagoriTarip And (namaMasterKatagoriTarif = @namaMasterKatagoriTarif Or namaMasterKatagoriInProgram = @namaMasterKatagoriInProgram))
		Begin
			Select 'Tidak Dapat Disimpan, Data Sudah Ada' respon, 0 responCode;
		End
	Else 
		Begin
			UPDATE dbo.masterTarifKatagori
			   SET [namaMasterKatagoriTarif] = @namaMasterKatagoriTarif
				  ,[namaMasterKatagoriInProgram] = @namaMasterKatagoriInProgram
				  ,[idMasterKatagoriJenis] = @idMasterKatagoriJenis
			 WHERE idMasterKatagoriTarip = @idMasterKatagoriTarip;

			Select 'Data Berhasil Diupdate' As respon, 1 As responCode;
		End
END