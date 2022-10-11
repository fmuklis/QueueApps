CREATE PROCEDURE [dbo].[masterPendidikanInsert]

	@namaPendidikan nvarchar(50)

AS
BEGIN
	SET NOCOUNT ON;
		if not exists (select 1 from [dbo].[masterPendidikan] where namaPendidikan = @namaPendidikan)
		begin
			INSERT INTO [dbo].[masterPendidikan]
           ([namaPendidikan])
		VALUES
           (@namaPendidikan);
			select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		end
		else
		begin
			select 'Maaf Data Sudah Ada' as respon, 0 as responCode;
		end
END