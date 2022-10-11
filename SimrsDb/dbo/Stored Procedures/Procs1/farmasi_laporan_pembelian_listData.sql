-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_laporan_pembelian_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idDistributor int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @query nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@dateBegin date, @dateEnd date, @iddsb int'
		   ,@filter nvarchar(max) = CASE
										WHEN ISNULL(@idDistributor, 0) = 0
											 THEN ''
										ELSE 'AND c.idDistriButor = @iddsb'
									END
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = '
		SELECT a.idPembelianHeader, a.tglPembelian, a.noFaktur, ca.namaDistroButor, b.discountUang, b.discountPersen, a.ppn
			  ,bb.namaBarang, b.jumlahBeli, bb.satuanBarang
			  ,b.hargaBeli * b.jumlahBeli As total
			  ,(((b.hargaBeli * b.jumlahBeli) - b.discountUang) * b.discountPersen / 100) + b.discountUang As jumlahDiscount
			  ,((b.hargaBeli * b.jumlahBeli) - ((((b.hargaBeli * b.jumlahBeli) - b.discountUang) * b.discountPersen / 100) + b.discountUang)) * a.ppn / 100 As jumlahPPN
	      FROM dbo.farmasiPembelian a
			   INNER JOIN dbo.farmasiPembelianDetail b On a.idPembelianHeader = b.idPembelianHeader
					INNER JOIN dbo.farmasiOrderDetail ba ON b.idOrderDetail = ba.idOrderDetail
					OUTER APPLY dbo.getInfo_barangFarmasi(ba.idObatDosis) bb
			   INNER JOIN dbo.farmasiOrder c ON a.idOrder = c.idOrder
					INNER JOIN dbo.farmasiMasterDistrobutor ca On c.idDistriButor = ca.idDistrobutor
		 WHERE CAST(a.tglPembelian AS date) BETWEEN @dateBegin AND @dateEnd #paramDefinition#
	  ORDER BY a.tglPembelian, ca.namaDistroButor
	';

	SET @query = REPLACE(@query, '#paramDefinition#', @filter);

	EXEC sp_executesql @query, @paramDefinition, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir, @iddsb = @idDistributor;
END