-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
create PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_listKategoriByIdTarif]
	-- Add the parameters for the stored procedure here
	@idTarif int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterKatagoriTarip, a.namaMasterKatagoriInProgram 
	  FROM dbo.masterTarifKatagori a
		   Inner Join dbo.masterTaripDetail b On a.idMasterKatagoriTarip = b.idMasterKatagoriTarip And b.status = 1
	 WHERE a.idmasterKatagoriJenis = 1 And b.idMasterTarip = @idTarif;
END