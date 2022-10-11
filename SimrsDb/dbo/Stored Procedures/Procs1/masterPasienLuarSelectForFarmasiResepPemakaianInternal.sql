-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterPasienLuarSelectForFarmasiResepPemakaianInternal]
	-- Add the parameters for the stored procedure here
	@idPasienLuar int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT nama, b.namaJenisKelamin, tglLahir, alamat, dokter, tlp
	  FROM dbo.masterPasienLuar a
		   Inner Join dbo.masterJenisKelamin b On a.idJenisKelamin = b.idJenisKelamin
	 WHERE idPasienLuar = @idPasienLuar
END