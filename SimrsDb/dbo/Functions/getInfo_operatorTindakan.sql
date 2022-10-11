-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_operatorTindakan]
(
	-- Add the parameters for the function here
	@idTindakanPasien bigint
)
RETURNS TABLE
AS
RETURN
(
	-- Add the SELECT statement with parameter references here
	SELECT STUFF((SELECT DISTINCT ', ' + c.NamaOperator
					FROM dbo.transaksiTindakanPasienDetail a
						 INNER JOIN dbo.transaksiTindakanPasienOperator b ON a.idTindakanPasienDetail = b.idTindakanPasienDetail
						 INNER JOIN dbo.masterOperator c ON b.idOperator = c.idOperator
   				   WHERE a.idMasterKatagoriTarip = 1/*Jasa Dokter*/ AND a.idTindakanPasien = @idTindakanPasien
			FOR XML PATH ('')), 1, 1, '') namaOperator
)