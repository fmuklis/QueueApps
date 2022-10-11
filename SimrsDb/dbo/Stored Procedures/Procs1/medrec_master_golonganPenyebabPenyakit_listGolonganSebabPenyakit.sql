-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE   PROCEDURE [dbo].[medrec_master_golonganPenyebabPenyakit_listGolonganSebabPenyakit]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idGolonganSebabPenyakit, '('+ nomorDaftarTerperinci +') '+ golonganSebabPenyakit AS golonganSebabPenyakit
	  FROM dbo.consGolonganSebabPenyakit
END