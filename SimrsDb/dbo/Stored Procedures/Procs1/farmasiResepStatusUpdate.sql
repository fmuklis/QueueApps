-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasiResepStatusUpdate] 
	-- Add the parameters for the stored procedure here
	 @idObat int
	,@namaObat nvarchar(225)
	,@idSatuanObat int
	,@nilaiRacikan decimal(18,2)
	,@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (Select 1 From [dbo].[farmasiMasterObat] Where [idObat] = @idObat)
		Begin
			UPDATE [dbo].[farmasiMasterObat]
			   SET [namaObat] = @namaObat
				  ,[idSatuanObat] = @idSatuanObat
				  --,[nilaiRacikan] = @nilaiRacikan
				  ,[idUserEntry] = @idUserEntry
			 WHERE [idObat] = @idObat;
			Select 'Data Berhasil Diupdate' as respon, 1 responCode;
		End
	ELSE
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 responCode;
		End
END