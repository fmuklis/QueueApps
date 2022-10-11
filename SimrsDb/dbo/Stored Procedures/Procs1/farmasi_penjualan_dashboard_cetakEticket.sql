-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_penjualan_dashboard_cetakEticket]
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.idRacikan, COALESCE(a.nomorResep, a.noResep) AS noResep, tglResep, ba.noRM, ba.namaPasien
		  ,ba.namaJenisKelamin AS jenisKelamin, ba.tglLahirPasien, ba.umur
		  ,CASE c.idRacikan
				WHEN 0
					 THEN ca.namaBarang
				ELSE 'Racikan '+ CAST(c.idRacikan AS varchar(10))
		    END AS namaObat
		  ,CASE c.idRacikan
				WHEN 0
					 THEN c.jumlah
				ELSE c.jumlahKemasan
		    END AS jumlah
		  ,CASE c.idRacikan
				WHEN 0
					 THEN ca.namaSatuanObat
				ELSE cb.namaKemasan
		    END AS namaSatuanObat
		  ,cc.aturanPakai, c.keterangan
	  FROM dbo.farmasiResep a 
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba
		   INNER JOIN dbo.farmasiResepDetail c On a.idResep = c.idResep
				OUTER APPLY dbo.getInfo_barangFarmasi(c.idObatDosis) ca
				LEFT JOIN dbo.farmasiResepKemasan cb ON c.idKemasan = cb.idKemasan
				OUTER APPLY dbo.getInfo_aturanPakai(c.idResepDetail) cc
	 WHERE a.idResep = @idResep
END