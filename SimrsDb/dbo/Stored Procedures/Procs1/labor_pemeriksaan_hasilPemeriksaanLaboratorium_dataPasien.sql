-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_hasilPemeriksaanLaboratorium_dataPasien]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.tglOrder, b.tanggalSampel, b.nomorLabor, c.noRM, c.namaPasien, c.tglLahirPasien, c.umur
		  ,d.diagnosa, c.namaJenisKelamin, e.penjamin + ISNULL(' / '+ f.namaKelas, '') AS penjamin
		  ,ba.NamaOperator AS DPJP, bb.namaRuangan, b.keteranganHasilPemeriksaan AS keterangan
		  ,bc.namaLengkap AS otorisator
	  FROM dbo.transaksiPendaftaranPasien a
		   INNER JOIN dbo.transaksiOrder b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				LEFT JOIN dbo.masterOperator ba ON b.idDokter = ba.idOperator
				LEFT JOIN dbo.masterRuangan bb ON b.idRuanganAsal = bb.idRuangan
				LEFT JOIN dbo.masterUser bc ON b.idUserOtorisasi = bc.idUser
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) c
		   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) d
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) e
		   LEFT JOIN dbo.masterKelas f ON a.idKelasPenjaminPembayaran = f.idKelas
	 WHERE b.idOrder = @idOrder
END