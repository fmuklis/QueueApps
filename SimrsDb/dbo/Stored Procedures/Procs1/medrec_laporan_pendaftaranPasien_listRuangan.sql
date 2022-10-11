-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[medrec_laporan_pendaftaranPasien_listRuangan]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idRuangan, a.namaRuangan
	  FROM dbo.masterRuangan a
 	 WHERE a.idJenisRuangan IN(1,3)
  ORDER BY a.idJenisRuangan, a.namaRuangan
END