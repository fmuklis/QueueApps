-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_listHistoriKonsul]
	-- Add the parameters for the stored procedure here
	@idTransaksiKonsul int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 
    -- Insert statements for procedure here
	SELECT a.idTindakanPasien, a.tglTindakan
		  ,a.idMasterTarif, ca.namaTarifHeader As namaTarif, eb.NamaOperator
		  ,(Select Sum(nilai) From dbo.transaksiTindakanPasienDetail xa Where a.idTindakanPasien = xa.idTindakanPasien) As Biaya
	  FROM dbo.transaksiTindakanPasien a
		   Inner Join dbo.transaksiKonsul b On a.idTransaksiKonsul = b.idTransaksiKonsul
		   Inner Join dbo.masterTarip c On a.idMasterTarif = c.idMasterTarif
			   Inner Join dbo.masterTarifHeader ca On c.idMasterTarifHeader = ca.idMasterTarifHeader				
		   Left Join dbo.transaksiTindakanPasienDetail e On a.idTindakanPasien = e.idTindakanPasien And e.idMasterKatagoriTarip = 1/*Jasa Dokter*/
				Left Join dbo.transaksiTindakanPasienOperator ea on e.idTindakanPasienDetail = ea.idTindakanPasienDetail
				Left Join dbo.masterOperator eb on ea.idOperator = eb.idOperator
	WHERE a.idTransaksiKonsul = @idTransaksiKonsul
 ORDER BY a.TglEntry;
END