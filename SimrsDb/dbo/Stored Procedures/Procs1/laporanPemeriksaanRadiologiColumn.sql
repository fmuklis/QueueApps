-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPemeriksaanRadiologiColumn]
	-- Add the parameters for the stored procedure here
	@periodeAwal date
	,@periodeAkhir date
	,@idJenisPenjaminPembayaranPasien int
	,@idMasterTarif int
	,@idJenisRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Count(b.idMasterTarif) As jumlah
	  FROM dbo.transaksiPendaftaranPasien a
		   Inner Join dbo.transaksiTindakanPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.transaksiOrderDetail ba On b.idOrderDetail = ba.idOrderDetail
				Inner Join dbo.transaksiOrder bb On ba.idOrder = bb.idOrder
				Inner Join dbo.masterRuangan bc On bb.idRuanganAsal = bc.idRuangan And bc.idJenisRuangan = @idJenisRuangan
	 WHERE a.idJenisPenjaminPembayaranPasien = @idJenisPenjaminPembayaranPasien And b.idMasterTarif = @idMasterTarif
		   And a.tglDaftarPasien Between @periodeAwal And @periodeAkhir;
END