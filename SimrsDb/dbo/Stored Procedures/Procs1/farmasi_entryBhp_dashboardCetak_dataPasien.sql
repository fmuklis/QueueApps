-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_entryBhp_dashboardCetak_dataPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.noRM, b.namaPasien, b.tglLahirPasien, b.umur, e.diagnosa, b.namaJenisKelamin
		  ,f.penjamin, c.namaRuangan, d.NamaOperator AS DPJP
 	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   LEFT JOIN dbo.masterRuangan c ON a.idRuangan = c.idRuangan
		   LEFT JOIN dbo.masterOperator d ON a.idDokter = d.idOperator
		   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) e
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) f
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
END