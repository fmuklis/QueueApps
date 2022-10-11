-- =============================================
-- Author:		komar
-- Create date: 30/11/2021
-- Description:	
-- =============================================
CREATE PROCEDURE sistem_admin_masterBed_listRuangKhusus 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT '' AS idJenisKelamin, 'Umum' AS namaJenisKelamin 
	UNION SELECT idJenisKelamin, namaJenisKelamin 
	FROM dbo.masterJenisKelamin
END