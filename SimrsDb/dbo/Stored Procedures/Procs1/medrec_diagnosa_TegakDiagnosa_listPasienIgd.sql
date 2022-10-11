-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_diagnosa_TegakDiagnosa_listPasienIgd]
	-- Add the parameters for the stored procedure here
	@idJenisPenjaminInduk tinyint,
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, c.penjamin, a.tglDaftarPasien, b.noRM, b.namaPasien, b.namaJenisKelamin, b.umur
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) c
	 WHERE a.idStatusPendaftaran = 99/*Pulang / Closed*/ AND a.idJenisPendaftaran = 1/*Pendaftaran IGD*/ AND a.idJenisPerawatan = 2/*Rawat Jalan*/
		   AND c.idJenisPenjaminInduk = @idJenisPenjaminInduk AND CAST(a.tglDaftarPasien AS date) BETWEEN @periodeAwal AND @periodeAkhir
  ORDER BY a.tglDaftarPasien
END