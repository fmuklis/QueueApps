-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pasien_pencarian_SelectByidPasien]
	-- Add the parameters for the stored procedure here
	@idPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.noRM, a.namaPasien, a.namaJenisKelamin AS jenisKelamin, a.tglLahirPasien, a.umur, a.alamatPasien
	  FROM dbo.get_dataPasien(@idPasien) a
END