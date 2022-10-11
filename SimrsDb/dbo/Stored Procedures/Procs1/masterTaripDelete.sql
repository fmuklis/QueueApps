-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTaripDelete]
	-- Add the parameters for the stored procedure here
	@idMasterTarifHeader int
	,@idMasterPelayanan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Begin try
		DELETE FROM [dbo].[masterTarip]
			  WHERE idMasterTarifHeader = @idMasterTarifHeader And idMasterPelayanan = @idMasterPelayanan;
		Select 'Data Berhasil Dihapus' as respon, 1 as responCode;
	End Try
	Begin Catch
		Select 'Error :'+ERROR_MESSAGE() as respon, 0 as responCode;
	End Catch
END