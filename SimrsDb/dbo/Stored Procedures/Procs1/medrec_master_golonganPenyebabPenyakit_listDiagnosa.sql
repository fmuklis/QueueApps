-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE   PROCEDURE [dbo].[medrec_master_golonganPenyebabPenyakit_listDiagnosa]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT a.idGolonganSebabPenyakit, a.idMasterICD, c.nomorDTD, c.nomorDaftarTerperinci
		  ,c.golonganSebabPenyakit, a.ICD, a.diagnosa
	  FROM dbo.masterICD a
		   INNER JOIN dbo.transaksiDiagnosaPasien b ON a.idMasterICD = b.idMasterICD
		   LEFT JOIN dbo.consGolonganSebabPenyakit c ON a.idGolonganSebabPenyakit = c.idGolonganSebabPenyakit
  ORDER BY c.nomorDTD, a.ICD
END