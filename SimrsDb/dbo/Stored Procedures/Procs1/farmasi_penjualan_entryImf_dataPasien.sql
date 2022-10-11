-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_penjualan_entryImf_dataPasien
	-- Add the parameters for the stored procedure here
	@idIMF bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, a.tglIMF, b.tglDaftarPasien, ba.noRM, ba.namaPasien, ba.namaJenisKelamin As jenisKelamin
		  ,ba.tglLahirPasien, ba.umur, ba.alamatPasien, c.NamaOperator, a.idDokter, d.namaRuangan, bb.jenisPasien
		  ,bb.penjamin, bd.namaKelas As kelasPenjamin, bc.diagnosa
	  FROM dbo.farmasiIMF a
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
			   OUTER APPLY dbo.getinfo_datapasien(b.idPasien) ba
			   OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
			   LEFT JOIN dbo.masterKelas bd On b.idKelasPenjaminPembayaran = bd.idKelas
			   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) bc
		   LEFT JOIN dbo.masterOperator c On a.idDokter = c.idOperator
		   LEFT JOIN dbo.masterRuangan d On a.idRuangan = d.idRuangan
	 WHERE a.idIMF = @idIMF
END