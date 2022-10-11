-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[masterProvinsiUpdate]
	-- Add the parameters for the stored procedure here
	 @idProvinsi int
	,@namaProvinsi nvarchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		IF EXISTS (select 1 from [dbo].[masterProvinsi] where [namaProvinsi] = @namaProvinsi AND [idProvinsi]<>@idProvinsi)
			BEGIN
				SELECT 'Provinsi '+ @namaProvinsi +' telah terdaftar' as respon, 0 as responCode;
			END
		ELSE
			BEGIN
					UPDATE [dbo].[masterProvinsi]
					SET  [namaProvinsi] = @namaProvinsi
					WHERE [idProvinsi] = @idProvinsi;

					SELECT 'Data berhasil diupdate' as respon, 1 as responCode;
			END
END