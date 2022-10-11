-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterDiagnosaSelectByidDiagnosa]
	-- Add the parameters for the stored procedure here
	@idMasterDiagnosa int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idMasterDiagnosa, a.idGolonganPenyakit, b.golonganPenyakit, diagnosa, alias
	  FROM dbo.masterDiagnosa a
		   Left Join dbo.masterDiagnosaGolonganPenyakit b On a.idGolonganPenyakit = b.idGolonganPenyakit
	 WHERE idMasterDiagnosa = @idMasterDiagnosa
END