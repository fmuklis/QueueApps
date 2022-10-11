-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Permintaan Perawatan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[operasi_tindakan_dashboard_listRequestOperasiByIdOrder]	
	-- Add the parameters for the stored procedure here
	@idTransaksiOrderOK int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT d.idTransaksiOrderOK, d.tglJadwal, g.idOperator, d.rencanaTindakan, d.idGolonganOk, d.idGolonganSpesialis, b.noHpPasien1, g.hp
	 FROM dbo.transaksiPendaftaranPasien a
			OUTER APPLY dbo.getInfo_dataPendaftaranPasien(a.idPendaftaranPasien) b
		  Inner Join dbo.transaksiOrderOK d On a.idPendaftaranPasien = d.idPendaftaranPasien
		  LEFT JOIN dbo.masterOperator g ON d.idOperator = g.idOperator
    WHERE a.idStatusPendaftaran < 98 And d.idStatusOrderOK = 1 AND d.idTransaksiOrderOK = @idTransaksiOrderOK
END