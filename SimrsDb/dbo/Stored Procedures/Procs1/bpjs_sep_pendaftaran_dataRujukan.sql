-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_dataRujukan]
	-- Add the parameters for the stored procedure here
	@idRujukan bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.nomorSep, a.nomorRujukan, a.tanggalRujukan, a.kodePpkDirujuk, a.jenisPelayanan, a.catatan, a.tanggalKunjungan
		  ,b.ICD, a.tipeRujukan, a.kodePoliRujukan
	  FROM dbo.bpjsRujukan a
		   LEFT JOIN dbo.masterICD b ON a.idMasterICD = b.idMasterICD
	 WHERE a.idRujukan = @idRujukan;
END