-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_listResepByIdPendaftaranPasien] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idResep, a.noResep, a.tglResep, a.idStatusResep, b.statusResep AS namaStatusResep
	  FROM dbo.farmasiResep a 
		   LEFT JOIN dbo.farmasiMasterStatusResep b On a.idStatusResep = b.idStatusResep
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END