CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addDokumenIdentitas]
	@namaDokumenIdentitas nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
		if  not exists (select 1 from [dbo].[masterDokumenIdentitas] where [namaDokumenIdentitas] = @namaDokumenIdentitas)
		begin
			INSERT INTO [dbo].[masterDokumenIdentitas]
           ([namaDokumenIdentitas])
			 VALUES
           (@namaDokumenIdentitas);
			select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		end
		else
		begin
			select 'Maaf Data Dokumen Identitas Sudah Ada' as respon, 0 as responCode;
		end
END