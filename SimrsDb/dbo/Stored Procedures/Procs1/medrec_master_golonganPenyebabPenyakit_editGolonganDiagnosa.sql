-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_master_golonganPenyebabPenyakit_editGolonganDiagnosa]
	-- Add the parameters for the stored procedure here
	@idMasterICD int,
	@idGolonganSebabPenyakit int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE dbo.masterICD
	   SET idGolonganSebabPenyakit = @idGolonganSebabPenyakit
	 WHERE idMasterICD = @idMasterICD;

	SELECT 'Data Golongan Sebab Penyakit Berhasil Diupdate' AS respon, 1 AS responCode;
END