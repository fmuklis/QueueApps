-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[utdrs_pemeriksaanPasienLuar_entryPemeriksaanDetail_dataPasien]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tglOrder, a.kodeOrder, b.namaPasien, b.namaJenisKelamin, b.tglLahir
		  ,b.umur, b.alamatPasien, b.tlp, b.DPJP
	  FROM dbo.transaksiOrder a
		   OUTER APPLY dbo.getInfo_dataPasienLuar(a.idPasienLuar, a.tglOrder) b
	 WHERE a.idOrder = @idOrder
END