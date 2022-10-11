-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_petugasLabor_entryPemeriksaan_dataPasien]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, a.tglOrder, ba.noRM, ba.namaPasien, ba.namaJenisKelamin, ba.tglLahirPasien, ba.umur
		  ,c.NamaOperator AS DPJP, bb.jenisPasien + ISNULL(' / '+ bc.namaKelas, '') penjamin, bc.idKelas, bd.diagnosa
	  FROM dbo.transaksiOrder a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getinfo_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
				LEFT JOIN dbo.masterKelas bc On b.idKelasPenjaminPembayaran = bc.idKelas
				OUTER APPLY dbo.getinfo_diagnosaPasien(b.idPendaftaranPasien) bd
		   LEFT JOIN dbo.masterOperator c On a.idDokter = c.idOperator
		   LEFT JOIN dbo.masterRuangan d On a.idRuanganAsal = d.idRuangan
	 WHERE a.idOrder = @idOrder
END