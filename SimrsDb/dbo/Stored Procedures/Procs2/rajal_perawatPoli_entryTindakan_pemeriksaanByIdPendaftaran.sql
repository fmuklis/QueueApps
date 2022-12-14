-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_pemeriksaanByIdPendaftaran]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrder, a.idStatusOrder, c.namaStatusOrder, ba.namaMasterPelayanan, a.kodeOrder, da.namaTarif
	  FROM dbo.transaksiOrder a 
		   Inner Join dbo.masterRuanganPelayanan b On a.idRuanganTujuan = b.idRuangan
		   Inner Join dbo.masterPelayanan ba On b.idMasterPelayanan = ba.idMasterPelayanan
		   Inner Join dbo.masterStatusOrder c On a.idStatusOrder = c.idStatusOrder
		   Inner Join dbo.transaksiOrderDetail d On a.idOrder = d.idOrder
				Cross Apply dbo.getinfo_tarif(d.idMasterTarif) da
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
  ORDER BY a.idOrder, d.idOrderDetail
END