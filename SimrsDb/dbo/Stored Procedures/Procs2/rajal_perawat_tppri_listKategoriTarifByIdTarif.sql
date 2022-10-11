-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rajal_perawat_tppri_listKategoriTarifByIdTarif]
	-- Add the parameters for the stored procedure here
	@idMasterTarif int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterKatagoriTarip, a.namaMasterKatagoriInProgram 
	  FROM dbo.masterTarifKatagori a
		   INNER JOIN dbo.masterTaripDetail b ON a.idMasterKatagoriTarip = b.idMasterKatagoriTarip AND b.[status] = 1
	 WHERE a.idmasterKatagoriJenis = 1 AND b.idMasterTarip = @idMasterTarif;
END