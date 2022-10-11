CREATE PROCEDURE [dbo].[masterJenisTarifInsert]
	@namaJenisTarif nvarchar(50)
	,@captionLaporan nvarchar(50)
	,@idJenisPendaftaran int
AS
BEGIN
	SET NOCOUNT ON;
		if  not exists (select 1 from [dbo].[masterJenisTarif] where [namaJenisTarif] = @namaJenisTarif)
		begin
			INSERT INTO [dbo].[masterJenisTarif]
           ([namaJenisTarif]
           ,[captionLaporan]
           ,[idJenisPendaftaran])
		VALUES
           (@namaJenisTarif
           ,@captionLaporan
           ,@idJenisPendaftaran);
			select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		end
		else
		begin
			select 'Maaf Jenis Tarif Sudah Ada' as respon, 0 as responCode;
		end
END