-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_deleteTarif]
	-- Add the parameters for the stored procedure here
	@idMasterTarif int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Begin Try
		/*DELETE Master Tarif*/
		DELETE [dbo].[masterTarip]
		 WHERE idMasterTarif = @idMasterTarif;

		/*Respon*/
		Select 'Data Tarif Berhasil Dihapus' As respon, 1 As responCode;
	End Try
	Begin Catch
		Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
	End Catch
END