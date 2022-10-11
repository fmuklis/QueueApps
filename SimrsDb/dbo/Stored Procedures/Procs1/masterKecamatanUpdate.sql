-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[masterKecamatanUpdate]
	-- Add the parameters for the stored procedure here
	 @idKecamatan int
	,@nama nvarchar(50)
	,@idKabupaten int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (select 1 from [dbo].[masterKecamatan] where [namaKecamatan] = @nama AND [idKecamatan] <> @idKecamatan)
		BEGIN
				SELECT 'Kecamatan '+ @nama +' telah terdaftar' as respon, 0 as responCode;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[masterKecamatan]
			SET [namaKecamatan] = @nama
				,[idKabupaten] = @idKabupaten
			WHERE [idKecamatan] = @idKecamatan;
			SELECT 'Data berhasil diupdate' as respon, 1 as responCode;
		END
	
END