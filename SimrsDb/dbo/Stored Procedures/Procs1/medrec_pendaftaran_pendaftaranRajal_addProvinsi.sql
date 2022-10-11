CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addProvinsi]
@namaProvinsi nvarchar(50),
@idNegara int
AS
BEGIN
	SET NOCOUNT ON;
		if not exists (select 1 from [dbo].[masterProvinsi] where [namaProvinsi] = @namaProvinsi and [idNegara] = @idNegara)
		begin
			INSERT INTO [dbo].[masterProvinsi]
			([namaProvinsi]
			,[idNegara])
			VALUES
			(@namaProvinsi
			,@idNegara);
			select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		end
		else
		begin
			select 'Maaf Nama Provinsi Sudah Ada' as respon, 0 as responCode;
		end
END