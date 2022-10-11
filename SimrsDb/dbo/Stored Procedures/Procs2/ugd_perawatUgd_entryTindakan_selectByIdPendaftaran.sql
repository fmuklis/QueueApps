-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_selectByIdPendaftaran]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idDokter, a.anamnesa, a.idPendaftaranPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, b.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien, b.umur 
		  ,c.namaJenisPenjaminPembayaranPasien, a.namaPenanggungJawabPasien, d.idOperator, d.namaOperator As DPJP, a.idPelayananIGD
		  ,k.idStatusOrderRawatInap As idOrderRawatInap
		  ,Case
				When Exists(Select 1 From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = a.idPendaftaranPasien)
					 Then 1
				Else 0
			End As flagOrderRawatInap
		  ,Case
				When Exists(Select 1 From dbo.transaksiOrderOK Where idPendaftaranPasien = a.idPendaftaranPasien)
					 Then 1
				Else 0
			End As flagOrderOK
		  ,Case
				When Exists(Select 1 From dbo.transaksiDiagnosaPasien Where idPendaftaranPasien = a.idPendaftaranPasien)
					 Then 1
				Else 0
			End As flagDiagnosa
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   Inner Join dbo.masterJenisPenjaminPembayaranPasien c on a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
		   Left Join dbo.masterOperator d On a.idDokter = d.idOperator
		   Left Join dbo.masterPelayananIGD e On a.idPelayananIGD = e.idPelayananIGD
		   Left Join dbo.transaksiOrderRawatInap k On a.idPendaftaranPasien = k.idPendaftaranPasien
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END