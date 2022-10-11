-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_hasilPemeriksaanLaboratoriumCetak_dataPasien]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.nomorLabor, b.tanggalSampel, b.tanggalHasil, c.noRM, c.namaPasien, c.tglLahirPasien, c.umur
		  ,c.alamatPasien, c.namaJenisKelamin, d.penjamin, ba.NamaOperator AS DPJP, bb.namaRuangan
		  ,bd.namaLengkap AS otorisator, bc.NamaOperator AS penanggungjawab, b.keteranganHasilPemeriksaan AS keterangan
	  FROM dbo.transaksiPendaftaranPasien a
		   INNER JOIN dbo.transaksiOrder b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				LEFT JOIN dbo.masterOperator ba ON b.idDokter = ba.idOperator
				LEFT JOIN dbo.masterRuangan bb ON b.idRuanganAsal = bb.idRuangan
				LEFT JOIN dbo.masterOperator bc ON b.idPenanggungjawabLaboratorium = bc.idOperator
				LEFT JOIN dbo.masterUser bd ON b.idUserOtorisasi = bd.idUser
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) c
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) d
	 WHERE b.idOrder = @idOrder
END