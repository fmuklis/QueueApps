-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_selectByIdPendaftaranPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT d.tglDaftarPasien, d1.kodePasien as noRM,d1.namaLengkapPasien as namaPasien,d1.tglLahirPasien,d1.umur,d1.namaJenisKelamin as jenisKelamin,d3.namaJenisPenjaminPembayaranPasien,
	d2.NamaOperator as DPJP, a.idDiagNosa, a.tglDiagnosa, b.idOperator, b.NamaOperator, a.anamnesa, d.idPelayananIGD, da.namaPelayananIGD
		  ,c.ICD, c.diagnosa
		  ,Case
				When a.primer = 1
					 Then 'Primer'
				Else 'Skunder'
			End As jenis
	  FROM dbo.transaksiDiagnosaPasien a
		   Inner Join dbo.masterOperator b On a.idDokter = b.idOperator
		   Inner Join dbo.masterICD c On a.idMasterICD = c.idMasterICD
		   Inner Join dbo.transaksiPendaftaranPasien d On a.idPendaftaranPasien = d.idPendaftaranPasien
				
				outer apply dbo.getinfo_datapasien(d.idPasien) d1
				inner join dbo.masterOperator d2 on d.idDokter=d2.idOperator
				Left Join dbo.masterPelayananIGD da On d.idPelayananIGD = da.idPelayananIGD 
				inner join masterJenisPenjaminPembayaranPasien d3 on d.idJenisPenjaminPembayaranPasien=d3.idJenisPenjaminPembayaranPasien
				inner join masterJenisPenjaminPembayaranPasienInduk d4 on d3.idJenisPenjaminInduk=d4.idJenisPenjaminInduk
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
  ORDER BY a.primer DESC;
END