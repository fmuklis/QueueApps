-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_returResep_listPendaftaran]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok int = (SELECT idJenisStok FROM dbo.masterRuangan WHERE idRuangan = @idRuangan);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT a.idPendaftaranPasien, a.tglDaftarPasien, a.noReg, c.noRM, c.namaPasien, b.penjamin
		  ,d.alias AS namaRuangan, e.NamaOperator, f.namaStatusPendaftaran
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) b
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) c
		   LEFT JOIN dbo.masterRuangan d ON a.idRuangan = d.idRuangan
		   LEFT JOIN dbo.masterOperator e ON a.idDokter = e.idOperator
		   LEFT JOIN dbo.masterStatusPendaftaran f ON a.idStatusPendaftaran = f.idStatusPendaftaran
		   INNER JOIN dbo.farmasiResep g ON a.idPendaftaranPasien = g.idPendaftaranPasien
				INNER JOIN dbo.farmasiPenjualanHeader ga ON g.idResep = ga.idResep AND ga.idStatusPenjualan = 2/*Siap Bayar*/
				INNER JOIN dbo.farmasiResepDetail gb ON g.idResep = gb.idResep
				INNER JOIN dbo.farmasiPenjualanDetail gc ON gb.idResepDetail = gc.idResepDetail
				INNER JOIN dbo.farmasiMasterObatDetail gd ON gc.idObatDetail = gd.idObatDetail
	 WHERE gd.idJenisStok = @idJenisStok
  ORDER BY a.tglDaftarPasien DESC
END