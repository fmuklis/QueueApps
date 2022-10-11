-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ok_select_dataPendaftaranPasien]
	-- Add the parameters for the stored procedure here
	@idTransaksiOrderOK int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, b.namaJenisKelamin As jenisKelamin, b.tglLahirPasien, b.umur, b.alamatPasien
		  ,c.NamaOperator, c.idOperator, e.namaRuangan, d.namaJenisPenjaminPembayaranPasien, da.namaJenisPenjaminInduk, c.NamaOperator, a.anamnesa
		  ,kelasPenjaminPembayaran.namaKelas As kelasPenjaminPasien, f.idGolonganOk, fa.golonganOk, f.idGolonganSpesialis, fb.golonganSpesialis
		  ,f.idGolonganSpinal, fc.golonganSpinal, f.tglOperasi, f.jamMulai, f.jamSelesai, f.tglAnestesi, f.jamMulaiAnestesi, f.jamSelesaiAnestesi
		  ,Case
				When Exists(Select 1 From dbo.transaksiDiagnosaPasien xa Where a.idPendaftaranPasien = xa.idPendaftaranPasien)
					 Then 1
				Else 0
			End As flagDiagnosa
		  ,Case
				When Exists(Select 1 From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = a.idPendaftaranPasien)
					Then 1
				Else 0
			End As flagOrderRawatInap
	  FROM dbo.transaksiPendaftaranPasien a
		   Outer Apply dbo.getinfo_datapasien(a.idPasien) b
		   Left Join dbo.masterOperator c On a.idDokter = c.idOperator
		   Inner Join dbo.masterJenisPenjaminPembayaranPasien d on a.idJenisPenjaminPembayaranPasien = d.idJenisPenjaminPembayaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk da On d.idJenisPenjaminInduk = da.idJenisPenjaminInduk
		   Inner Join dbo.masterRuangan e On a.idRuangan = e.idRuangan
		   Inner Join dbo.transaksiOrderOK f On a.idPendaftaranPasien = f.idPendaftaranPasien
				Left Join dbo.masterOkGolongan fa On f.idGolonganOk = fa.idGolonganOk
				Left join dbo.masterOkGolonganSpesialis fb On f.idGolonganSpesialis = fb.idGolonganSpesialis
				Left Join dbo.masterOkGolonganSpinal fc On f.idGolonganSpinal = fc.idGolonganSpinal
		   Left Join dbo.masterKelas kelasPenjaminPembayaran On a.idKelasPenjaminPembayaran = kelasPenjaminPembayaran.idKelas
	 WHERE f.idTransaksiOrderOK = @idTransaksiOrderOK
END