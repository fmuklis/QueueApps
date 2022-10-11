-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_entryTindakan_select_dataPasien]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  a.idPendaftaranPasien, b.tglDaftarPasien, ba.noRM, ba.namaPasien, ba.namaJenisKelamin As jenisKelamin, ba.tglLahirPasien, ba.umur
		   ,be.NamaOperator As DPJP, bc.namaJenisPenjaminInduk, bb.namaJenisPenjaminPembayaranPasien, IsNull(bd.namaKelas, '-') As kelasPenjaminPasien
		   ,bf.namaRuangan
		   /*Kelas Pelayanan*/
		   ,Case
				 When b.idJenisPerawatan = 1/*Rawat Inap*/ And bg.idStatusPendaftaranRawatInap = 3/*Naik Kelas*/
					  Then b.idKelasPenjaminPembayaran - 1
				 Else b.idKelasPenjaminPembayaran
			 End As idKelas
	  FROM dbo.transaksiOrder a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Outer Apply dbo.getinfo_datapasien(b.idPasien) ba
				Inner Join dbo.masterJenisPenjaminPembayaranPasien bb on b.idJenisPenjaminPembayaranPasien = bb.idJenisPenjaminPembayaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk bc On bb.idJenisPenjaminInduk = bc.idJenisPenjaminInduk
				Left Join dbo.masterKelas bd On b.idKelasPenjaminPembayaran = bd.idKelas			 
				Left Join dbo.masterOperator be On a.idDokter = be.idOperator
				Left Join dbo.masterRuangan bf On a.idRuanganAsal = bf.idRuangan
				Left Join dbo.transaksiPendaftaranPasienDetail bg On b.idPendaftaranPasien = bg.idPendaftaranPasien And bg.aktif = 1/*Aktif*/
	 WHERE a.idOrder= @idOrder;
END