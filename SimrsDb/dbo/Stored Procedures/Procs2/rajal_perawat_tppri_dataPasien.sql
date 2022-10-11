-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawat_tppri_dataPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.anamnesa, COALESCE(f.diagnosa, dbo.diagnosaPasien(a.idPendaftaranPasien)) AS diagnosa, a.tglDaftarPasien, b.noRM, b.namaPasien
		  ,b.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien, b.umur, b.alamatPasien
		  ,a.idDokter,c.NamaOperator As DPJP, e.namaRuangan, d.jenisPasien AS namaJenisPenjaminPembayaranPasien, d.penjamin AS namaJenisPenjaminInduk
		  ,Case
				When Exists(Select 1 From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = a.idPendaftaranPasien)
					Then 1
				Else 0
			End As flagOrderRawatInap
		  ,Case
				When Exists(Select 1 From dbo.transaksiDiagnosaPasien xa Where a.idPendaftaranPasien = xa.idPendaftaranPasien)
					Then 1
				Else 0
			End As flagDiagnosa
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   LEFT JOIN dbo.masterOperator c ON a.idDokter = c.idOperator
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) d
		   LEFT JOIN dbo.masterRuangan e ON a.idRuangan = e.idRuangan
		   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) f
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END