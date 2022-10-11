-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sistem_admin_masterBed_listPelayanan]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	SELECT idJenisPelayananRawatInap, jenisPelayananRawatInap
	  FROM dbo.consJenisPelayananRawatInap
  ORDER BY jenisPelayananRawatInap
END