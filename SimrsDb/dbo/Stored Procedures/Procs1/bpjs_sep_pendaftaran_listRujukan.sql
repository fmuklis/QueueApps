
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_listRujukan]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idRujukan, ca.noRM, ca.namaPasien, a.nomorSep, a.tanggalRujukan, a.kodePpkDirujuk, a.tanggalKunjungan, a.nomorRujukan
		  ,IIF(a.jenisPelayanan = 1, 'Rawat Inap', 'Rawat Jalan') AS jenisPelayanan, a.catatan, b.ICD, a.kodePoliRujukan,
		  CASE
			WHEN a.tipeRujukan = 0 THEN 'Penuh'
			WHEN a.tipeRujukan = 1 THEN 'Partial'
			WHEN a.tipeRujukan = 2 THEN 'Rujuk Balik'
		  END AS tipeRujukan
	  FROM dbo.bpjsRujukan a
		   LEFT JOIN dbo.masterICD b ON a.idMasterICD = b.idMasterICD
		   LEFT JOIN dbo.transaksiPendaftaranPasien c ON a.nomorSep = c.noSEPRawatJalan OR a.nomorSep = c.noSEPRawatInap
				OUTER APPLY dbo.getInfo_dataPasien(c.idPasien) ca
	 WHERE a.nomorRujukan IS NOT NULL AND DATEDIFF(DAY, a.tanggalEntry, GETDATE()) <= 7
  ORDER BY a.tanggalEntry DESC;
END