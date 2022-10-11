-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].ranap_perawat_entryTindakan_listStatusPasienRajal
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [idStatusPasien]
		  ,[namaStatusPasien]
	  FROM [dbo].[masterStatusPasien]
	 WHERE idStatusPendaftaran = 6/*Rawat Inap*/ Or idStatusPasien In(2,3,11)/*Kontrol, Rujuk, Isolasi Mandiri*/
  ORDER BY [namaStatusPasien]
END