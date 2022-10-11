-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_selectByIdPendaftaran]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.anamnesa, a.idPendaftaranPasien, a.[tglDaftarPasien], b.noRM, b.namaPasien, b.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien, b.umur, b.alamatPasien
		  ,c.NamaOperator As DPJP, a.idDokter, e.namaRuangan, d.namaJenisPenjaminPembayaranPasien, da.namaJenisPenjaminInduk
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
		   Left Join dbo.masterOperator c On a.idDokter = c.idOperator
		   Inner Join dbo.masterJenisPenjaminPembayaranPasien d on a.idJenisPenjaminPembayaranPasien = d.idJenisPenjaminPembayaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk da On d.idJenisPenjaminInduk = da.idJenisPenjaminInduk
		   Inner Join dbo.masterRuangan e On a.idRuangan = e.idRuangan
		   --Inner Join [dbo].[masterStatusPendaftaran] f on a.[idStatusPendaftaran] = f.[idStatusPendaftaran]
		   --Inner join [dbo].[masterJenisPendaftaran] g on a.[idJenisPendaftaran] = g.[idJenisPendaftaran]
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END