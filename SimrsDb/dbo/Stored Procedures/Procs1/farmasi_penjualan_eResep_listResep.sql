-- =============================================
-- Author     :	Start -X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Daftar Pasien Yang Order Farmasi
-- =============================================
CREATE PROCEDURE farmasi_penjualan_eResep_listResep
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT COALESCE(a.nomorResep, a.noResep) AS noResep, ba.namaBarang, b.jumlah, ba.namaSatuanObat
		  ,b.idRacikan, bb.aturanPakai, b.keterangan
		  ,Case
				When b.idRacikan = 0
					 Then 0
				Else 1
			End As racikan
		  ,Case
				When b.idRacikan = 0
					 Then 'Non Racikan'
				Else 'Racikan'
			End As jenisObat
	  FROM dbo.farmasiResep a
		   LEFT JOIN dbo.farmasiResepDetail b On a.idResep = b.idResep
				OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
				OUTER APPLY dbo.getInfo_aturanPakai(b.idResepDetail) bb
	 WHERE a.idResep = @idResep
  ORDER BY b.idRacikan, ba.namaBarang
END