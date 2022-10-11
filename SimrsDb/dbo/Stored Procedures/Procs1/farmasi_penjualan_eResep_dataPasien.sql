-- =============================================
-- Author     :	Start -X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Daftar Pasien Yang Order Farmasi
-- =============================================
CREATE PROCEDURE farmasi_penjualan_eResep_dataPasien
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.noRM, ba.namaPasien, ba.tglLahirPasien, ba.umur, c.NamaOperator, d.namaRuangan
	  FROM dbo.farmasiResep a
		   LEFT JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getinfo_datapasien(b.idPasien) ba
		   LEFT JOIN dbo.masterOperator c On a.idDokter = c.idOperator
		   LEFT JOIN dbo.masterRuangan d On a.idRuangan = d.idRuangan
	 WHERE a.idResep = @idResep
END