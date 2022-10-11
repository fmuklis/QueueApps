-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[medrec_diagnosa_entryDiagnosaAkhir_listPelayanan]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idPelayananIGD
		  ,namaPelayananIGD
	  FROM dbo.masterPelayananIGD
  ORDER BY namaPelayananIGD
END