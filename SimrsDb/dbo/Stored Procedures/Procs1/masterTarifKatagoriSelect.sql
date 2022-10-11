-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTarifKatagoriSelect]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idMasterKatagoriTarip, namaMasterKatagoriTarif, namaMasterKatagoriInProgram, b.namaMasterKatagoriJenis
	  FROM dbo.masterTarifKatagori a
		   Inner Join dbo.masterTarifKatagoriJenis b On a.idMasterKatagoriJenis = b.idMasterKatagoriJenis
  ORDER BY namaMasterKatagoriTarif
END