-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE rajal_perawat_tppri_listPemeriksaanPasien
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTindakanPasien, c.idPenjualanDetail, b.BHP, d.Alias, CAST(a.tglTindakan AS DATE) AS tglTindakan, b.namaTarif
		  ,c.namaBHP, e.namaOperator, d.namaRuangan, d.idRuangan, b.nilaiTarif AS biayaTindakan, c.jmlTarifBHP AS biayaBHP
		  ,CASE
				WHEN a.idRuangan = @idRuangan
					 THEN 1
				ELSE 0
			END AS btnDelete
	  FROM dbo.transaksiTindakanPasien a
		   OUTER APPLY dbo.getInfo_tarif(a.idMasterTarif) b
		   OUTER APPLY dbo.getInfo_bhpTindakan(a.idTindakanPasien) c
		   LEFT JOIN dbo.masterRuangan d On a.idRuangan = d.idRuangan
		   OUTER APPLY dbo.getInfo_operatorTindakan(a.idTindakanPasien) e
		   LEFT JOIN dbo.transaksiBillingHeader f ON a.idPendaftaranPasien = f.idPendaftaranPasien AND a.idJenisBilling = f.idJenisBilling
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.idRuangan = @idRuangan
  ORDER BY a.tglTindakan DESC
END