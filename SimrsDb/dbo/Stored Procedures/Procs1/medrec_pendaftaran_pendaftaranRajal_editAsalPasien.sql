-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_editAsalPasien]
	-- Add the parameters for the stored procedure here
	 @idAsalPasien int
	,@namaAsalPasien nvarchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (select 1 from [dbo].[masterAsalPasien] where [namaAsalPasien] = @namaAsalPasien AND [idAsalPasien] <> @idAsalPasien)
		BEGIN
			SELECT 'Asal Rujukan '+ @namaAsalPasien +' telah terdaftar' as respon, 0 as responCode;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[masterAsalPasien]
			   SET [namaAsalPasien] = @namaAsalPasien
			 WHERE [idAsalPasien] = @idAsalPasien;

			Select 'Data berhasil diupdate ' As respon, 1 As responCode;
		END
END