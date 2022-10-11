-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_rincianSementara_listTindakan]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTindakanPasien, c.idPenjualanDetail, a.tglTindakan, d.namaRuangan, e.namaOperator, b.namaTarif
		  ,b.tarif, b.qty, b.jmlTarif, b.keterangan AS statusTindakan, c.jmlBHP AS qtyBHP
		  ,c.namaBHP, c.jmlTarifBHP, c.keterangan AS statusBhp, c.tarifBHP
	  FROM dbo.transaksiTindakanPasien a
		   OUTER APPLY dbo.getInfo_tarifTindakan(a.idTindakanPasien) b
		   OUTER APPLY dbo.getInfo_bhpTindakan(a.idTindakanPasien) c
		   LEFT JOIN dbo.masterRuangan d ON a.idRuangan = d.idRuangan
		   OUTER APPLY dbo.getInfo_operatorTindakan(a.idTindakanPasien) e
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.idJenisBilling = 6/*Tagihan RaNap*/
  ORDER BY d.namaRuangan, a.tglTindakan
END