-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanapBayi_searchDataIbu]
	-- Add the parameters for the stored procedure here
	@kodePasien nchar(20)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT b.idPendaftaranPasien, c.noRM, c.namaPasien, c.tglLahirPasien, c.umur, c.namaJenisKelamin
		  ,bb.penjamin, ba.NamaOperator AS DPJP, bc.Alias As namaRuangan, b.tglDaftarPasien
	  FROM dbo.masterPasien a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPasien = b.idPasien
				LEFT JOIN dbo.masterOperator ba On b.idDokter = ba.idOperator		   
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
				LEFT JOIN dbo.masterRuangan bc On b.idRuangan = bc.idRuangan
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) c
	 WHERE a.kodePasien = REPLACE(@kodePasien, '.','') AND a.idJenisKelaminPasien = 2/*Perempuan*/
  ORDER BY b.tglDaftarPasien DESC 
END