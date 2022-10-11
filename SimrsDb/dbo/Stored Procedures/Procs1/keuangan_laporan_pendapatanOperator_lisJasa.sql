-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_laporan_pendapatanOperator_lisJasa]
	-- Add the parameters for the stored procedure here
	 @periodeAwal date,
	 @periodeAkhir date,
	 @idOperator int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	

	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	SELECT DISTINCT ba.idMasterKatagoriTarip, ba.namaMasterKatagoriInProgram
	  FROM dbo.transaksiTindakanPasien a
		   INNER JOIN dbo.transaksiTindakanPasienDetail b ON a.idTindakanPasien = b.idTindakanPasien
				INNER JOIN dbo.masterTarifKatagori ba ON b.idMasterKatagoriTarip = ba.idMasterKatagoriTarip
	 WHERE a.tglTindakan BETWEEN @periodeAwal AND @periodeAkhir
  ORDER BY ba.idMasterKatagoriTarip;
					
END