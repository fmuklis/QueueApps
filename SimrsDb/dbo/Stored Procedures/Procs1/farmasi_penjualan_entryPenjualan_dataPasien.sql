-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_penjualan_entryPenjualan_dataPasien
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idResep, a.noResep, tglResep, ba.noRM, ba.namaPasien, ba.namaJenisKelamin, ba.tglLahirPasien, ba.umur
		  ,c.namaRuangan, bd.diagnosa, d.NamaOperator, bb.namaJenisPenjaminPembayaranPasien, bc.namaKelas, bb.idJenisPenjaminInduk
	  FROM dbo.farmasiResep a 
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba
				Inner Join dbo.masterJenisPenjaminPembayaranPasien bb On b.idJenisPenjaminPembayaranPasien = bb.idJenisPenjaminPembayaranPasien
				Inner Join dbo.masterKelas bc On b.idKelas = bc.idKelas
				OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) bd
		   Inner Join dbo.masterRuangan c On a.idRuangan = c.idRuangan
		   Inner Join dbo.masterOperator d On a.idDokter = d.idOperator
	 WHERE idResep = @idResep
END