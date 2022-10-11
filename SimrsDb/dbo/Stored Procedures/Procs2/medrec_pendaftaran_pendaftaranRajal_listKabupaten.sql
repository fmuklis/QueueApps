CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_listKabupaten]

AS
BEGIN
	SET NOCOUNT ON;
Select * from [dbo].[masterKabupaten]order by [namaKabupaten] asc
END