-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Permintaan Perawatan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[operasi_tindakan_dashboard_listRequest_masterOperatorList]	
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT a.idOperator, a.NamaOperator 
	  FROM dbo.masterOperator a 
	  INNER JOIN dbo.masterOperatorJenis b ON a.idJenisOperator = b.idJenisOperator
	 WHERE a.aktif = 1 /*TRUE*/ AND b.jenisSpesialisasi IS NOT NULL

END