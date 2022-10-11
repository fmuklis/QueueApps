CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_listDokter]

AS
BEGIN

	SET NOCOUNT ON;
		SELECT idOperator as idDokter,NamaOperator as namaLengkap FROM [dbo].[masterOperator]
		--order by [namaLengkap] asc
END