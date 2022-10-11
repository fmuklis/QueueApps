-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTarifKatagoriSelecByidOrder]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Distinct ba.idMasterKatagoriTarip
		  ,bb.namaMasterKatagoriInProgram
	  FROM dbo.transaksiOrderDetail a
		   Inner Join dbo.transaksiTindakanPasien b On a.idOrderDetail = b.idOrderDetail
				Inner Join dbo.transaksiTindakanPasienDetail ba On b.idTindakanPasien = ba.idTindakanPasien
				Inner Join dbo.masterTarifKatagori bb On ba.idMasterKatagoriTarip = bb.idMasterKatagoriTarip
	 WHERE a.idOrder = @idOrder And bb.idMasterKatagoriJenis = 1/*Jasa*/
  ORDER BY ba.idMasterKatagoriTarip
END