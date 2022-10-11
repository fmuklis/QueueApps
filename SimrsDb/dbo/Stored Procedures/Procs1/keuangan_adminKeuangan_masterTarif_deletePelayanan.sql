-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_deletePelayanan]
	-- Add the parameters for the stored procedure here
	@idMasterPelayanan int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Begin Try
		/*DELETE Master Pelayanan*/
		DELETE [dbo].[masterPelayanan]
		 WHERE idMasterPelayanan = @idMasterPelayanan;

		/*Respon*/
		Select 'Data Pelayanan Berhasil Dihapus' As respon, 1 As responCode;
	End Try
	Begin Catch
		Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
	End Catch
END