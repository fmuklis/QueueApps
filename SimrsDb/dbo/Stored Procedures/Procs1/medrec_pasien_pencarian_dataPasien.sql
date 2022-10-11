-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pasien_pencarian_dataPasien]
	-- Add the parameters for the stored procedure here
	@search nvarchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPasien, b.noRM, b.namaLengkapPasien, b.namaJenisKelamin, b.tglLahirPasien, b.umur, b.alamatPasien
	  FROM dbo.masterPasien a
	  OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
	 WHERE a.kodePasien= REPLACE(@search,'.','') Or a.namaLengkapPasien Like '%'+ @search +'%';
END