-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addAsalPasien]
	-- Add the parameters for the stored procedure here
	@idJenisFaskes tinyint,
	@asalPasien nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterAsalPasien WHERE namaAsalPasien = @asalPasien)
		BEGIN
			SELECT 'Faskes '+ @asalPasien +' Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[masterAsalPasien]
					   ([idJenisFaskes]
					   ,[namaAsalPasien])
				 VALUES
					   (@idJenisFaskes
					   ,@asalPasien);

			SELECT 'Data Faskes '+ @asalPasien +' Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END