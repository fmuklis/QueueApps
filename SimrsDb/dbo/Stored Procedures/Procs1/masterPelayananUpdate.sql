
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterPelayananUpdate]
	-- Add the parameters for the stored procedure here
	@idMasterPelayanan int,
	@namaMasterPelayanan Nvarchar(225)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	update dbo.masterPelayanan set namaMasterPelayanan = @namaMasterPelayanan where idMasterPelayanan = @idMasterPelayanan;
	select 'Data berhasil diupdate' as respon, 1 as responCode;
END