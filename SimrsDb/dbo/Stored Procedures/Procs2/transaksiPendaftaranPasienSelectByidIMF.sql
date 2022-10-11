-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectByidIMF]
	-- Add the parameters for the stored procedure here
	@idIMF int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, a.tglIMF, b.tglDaftarPasien, ba.noRM, ba.namaPasien, ba.namaJenisKelamin AS jenisKelamin, ba.tglLahirPasien, ba.umur, ba.alamatPasien
		  ,c.NamaOperator, a.idDokter, d.namaRuangan, bb.namaJenisPenjaminPembayaranPasien, bc.namaJenisPenjaminInduk, bd.namaKelas As kelasPenjamin
	  FROM dbo.farmasiIMF a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
			   OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba
			   Inner Join dbo.masterJenisPenjaminPembayaranPasien bb on b.idJenisPenjaminPembayaranPasien = bb.idJenisPenjaminPembayaranPasien
			   Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk bc On bb.idJenisPenjaminInduk = bc.idJenisPenjaminInduk
			   Left Join dbo.masterKelas bd On b.idKelasPenjaminPembayaran = bd.idKelas
		   Left Join dbo.masterOperator c On a.idDokter = c.idOperator
		   Inner Join dbo.masterRuangan d On a.idRuangan = d.idRuangan
	 WHERE a.idIMF = @idIMF
END