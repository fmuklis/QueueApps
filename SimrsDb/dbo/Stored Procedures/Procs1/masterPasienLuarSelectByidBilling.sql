-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterPasienLuarSelectByidBilling]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.nama, ca.namaJenisKelamin, c.tglLahir, dbo.calculatorUmur(c.tglLahir, b.tglOrder) As umur, c.alamat, c.tlp, c.dokter
	  FROM dbo.transaksiBillingHeader a
		   Inner Join dbo.transaksiOrder b On a.idOrder = b.idOrder
		   Inner Join dbo.masterPasienLuar c On a.idPasienLuar = c.idPasienLuar
				Inner Join dbo.masterJenisKelamin ca On c.idJenisKelamin = ca.idJenisKelamin
	 WHERE a.idBilling = @idBilling
END