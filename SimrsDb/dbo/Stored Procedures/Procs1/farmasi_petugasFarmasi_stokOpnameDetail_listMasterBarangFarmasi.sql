-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameDetail_listMasterBarangFarmasi]
	-- Add the parameters for the stored procedure here
	@search varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idObatDosis, b.namaBarang +' '+ b.satuanBarang AS namaBarang
	  FROM dbo.farmasiMasterObatDosis a
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
	 WHERE b.namaBarang LIKE '%'+ @search +'%'
  ORDER BY b.namaBarang
END