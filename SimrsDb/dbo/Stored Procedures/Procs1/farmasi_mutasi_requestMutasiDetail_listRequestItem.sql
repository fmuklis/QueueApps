-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE farmasi_mutasi_requestMutasiDetail_listRequestItem
	-- Add the parameters for the stored procedure here
	@idMutasi bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idItemOrderMutasi, b.namaBarang, a.sisaStok, a.jumlahOrder, b.namaSatuanObat
	  FROM dbo.farmasiMutasiOrderItem a
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
	 WHERE a.idMutasi = @idMutasi
  ORDER BY b.namaBarang
END