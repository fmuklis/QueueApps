-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTarifKatagoriSelectByidMasterKatagoriTarip]
	-- Add the parameters for the stored procedure here
	@idMasterKatagoriTarip int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idMasterKatagoriTarip, namaMasterKatagoriTarif, namaMasterKatagoriInProgram, b.idMasterKatagoriJenis, b.namaMasterKatagoriJenis
	  FROM dbo.masterTarifKatagori a
		   Inner Join dbo.masterTarifKatagoriJenis b On a.idMasterKatagoriJenis = b.idMasterKatagoriJenis
	 WHERE a.idMasterKatagoriTarip = @idMasterKatagoriTarip
  ORDER BY namaMasterKatagoriTarif
END