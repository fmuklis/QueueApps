
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_dataRujukanEdit]
	-- Add the parameters for the stored procedure here
	@idRujukan bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ea.noPenjamin, a.nomorSep, a.tanggalRujukan, a.tanggalKunjungan, f.kodeFaskes +'#'+ f.faskes AS faskes
		  ,a.kodePpkDirujuk +'#'+ b.ppkRujukan AS ppkDirujuk, a.jenisPelayanan, a.catatan, a.nomorRujukan
		  ,c.ICD +'#'+ c.diagnosa AS diagRujukan, a.tipeRujukan, a.kodePoliRujukan +'#'+ d.poli AS poliRujukan
	  FROM dbo.bpjsRujukan a
		   LEFT JOIN dbo.bpjsMasterPpk b ON a.kodePpkDirujuk = b.kodePpkRujukan
		   LEFT JOIN dbo.masterICD c ON a.idMasterICD = c.idMasterICD
		   LEFT JOIN dbo.bpjsMasterPoli d ON a.kodePoliRujukan = d.kodePoli
		   LEFT JOIN dbo.transaksiPendaftaranPasien e ON a.nomorSep = e.noSEPRawatJalan OR a.nomorSep = e.noSEPRawatInap
				OUTER APPLY dbo.getInfo_dataPasien(e.idPasien) ea
		   LEFT JOIN dbo.bpjsMasterFaskes f ON a.kodeFaskes = f.kodeFaskes
	 WHERE a.idRujukan = @idRujukan;
END