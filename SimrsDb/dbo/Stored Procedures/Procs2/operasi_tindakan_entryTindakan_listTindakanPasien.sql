-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE operasi_tindakan_entryTindakan_listTindakanPasien
	-- Add the parameters for the stored procedure here
	@idTransaksiOrderOK bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTindakanPasien, c.idPenjualanDetail, a.idRuangan, d.alias AS namaRuangan, a.idMasterTarif, b.qty AS jumlah
		  ,a.tglTindakan, b.namaTarif, b.jmlTarif AS biaya, e.namaOperator
		  ,c.namaBHP, c.jmlTarifBHP AS hargaJual, b.BHP
	  FROM dbo.transaksiTindakanPasien a
		   OUTER APPLY dbo.getInfo_tarifTindakan(a.idTindakanPasien) b
		   OUTER APPLY dbo.getInfo_bhpTindakan(a.idTindakanPasien) c
		   LEFT JOIN dbo.masterRuangan d ON a.idRuangan = d.idRuangan
		   OUTER APPLY dbo.getInfo_operatorTindakan(a.idTindakanPasien) e
	 WHERE a.idTransaksiOrderOK = @idTransaksiOrderOK
  ORDER BY a.tglTindakan
END