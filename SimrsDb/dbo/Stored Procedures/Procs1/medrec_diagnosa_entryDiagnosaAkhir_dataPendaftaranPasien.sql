-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_diagnosa_entryDiagnosaAkhir_dataPendaftaranPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, b.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien, b.umur, b.alamatPasien
		  ,c.NamaOperator, c.idOperator, e.namaRuangan
		  ,Case a.idJenisPerawatan
				When 1
					 Then da.namaJenisPenjaminInduk +'/'+ f.namaKelas
				Else da.namaJenisPenjaminInduk
			End As namaJenisPenjaminInduk
		  ,Case
				When Exists(Select 1 From dbo.transaksiDiagnosaPasien xa
								   Inner Join dbo.masterDiagnosa xb On xa.idMasterDiagnosa = xb.idMasterDiagnosa
							 Where xa.idPendaftaranPasien = @idPendaftaranPasien)
					 Then 1
				Else 0
			End As flagDiagnosa
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   Left Join dbo.masterOperator c On a.idDokter = c.idOperator
		   Inner Join dbo.masterJenisPenjaminPembayaranPasien d on a.idJenisPenjaminPembayaranPasien = d.idJenisPenjaminPembayaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk da On d.idJenisPenjaminInduk = da.idJenisPenjaminInduk
		   Inner Join dbo.masterRuangan e On a.idRuangan = e.idRuangan
		   Left Join dbo.masterKelas f On a.idKelasPenjaminPembayaran = f.idKelas
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END