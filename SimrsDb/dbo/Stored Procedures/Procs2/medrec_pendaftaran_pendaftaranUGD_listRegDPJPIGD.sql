-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
create PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranUGD_listRegDPJPIGD]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idOperator, NamaOperator
	  FROM dbo.masterOperator
	 WHERE idJenisOperator = 1/*Dokter UMUM*/ And aktif = 1/*Aktif*/
  ORDER BY NamaOperator
END