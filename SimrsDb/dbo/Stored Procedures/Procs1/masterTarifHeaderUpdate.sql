-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTarifHeaderUpdate]
	-- Add the parameters for the stored procedure here
	@idMasterTarifHeader int
	,@namaTarifHeader nvarchar(225)
	,@idMasterTarifGroup smallint
	,@BHP bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.masterTarifHeader Where namaTarifHeader = @namaTarifHeader And idMasterTarifHeader <> @idMasterTarifHeader)
		Begin
			Select 'Gagal!: Sudah Ada Nama Tarif Yang Sama' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE [dbo].[masterTarifHeader]
			   SET [namaTarifHeader] = @namaTarifHeader
				  ,[BHP] = @BHP
				  ,[idMasterTarifGroup] = @idMasterTarifGroup
			 WHERE idMasterTarifHeader = @idMasterTarifHeader

			Select 'Nama Tarif Berhasil Diupdate' As respon, 1 As responCode;
		End
END