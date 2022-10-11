-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawat_tppri_listPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTindakanPasien, c.idPenjualanDetail, b.BHP, d.Alias
		  ,CAST(a.tglTindakan AS DATE) AS tglTindakan, b.namaTarif, c.namaBHP, e.namaOperator, d.namaRuangan, d.idRuangan
		  ,b.nilaiTarif AS biayaTindakan, c.jmlTarifBHP AS biayaBHP 
	  FROM dbo.transaksiTindakanPasien a
		   OUTER APPLY dbo.getInfo_tarif(a.idMasterTarif) b
		   OUTER APPLY dbo.getInfo_bhpTindakan(a.idTindakanPasien) c
		   LEFT JOIN dbo.masterRuangan d On a.idRuangan = d.idRuangan
		   OUTER APPLY dbo.getInfo_operatorTindakan(a.idTindakanPasien) e
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.idRuangan = @idRuangan
  ORDER BY a.tglTindakan
END