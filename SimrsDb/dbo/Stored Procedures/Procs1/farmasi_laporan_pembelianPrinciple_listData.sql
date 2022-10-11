-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_laporan_pembelianPrinciple_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idPabrik int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @query nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@dateBegin date, @dateEnd date, @idpb int'
		   ,@filter nvarchar(max) = CASE
										WHEN ISNULL(@idPabrik, 0) = 0
											 THEN ''
										ELSE ' AND ba.idPabrik = @idpb'
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = '
	      SELECT a.idPembelianHeader, a.tglPembelian, a.noFaktur, bb.namaPabrik, ca.namaDistroButor, b.discountUang, b.discountPersen, a.ppn
				,bc.namaBarang AS namaObat, bc.satuanBarang, b.hargaBeli, b.jumlahBeli, b.hargaBeli * b.jumlahBeli AS total
				,jumlahDiskon = b.discountUang + (((b.jumlahBeli * b.hargaBeli) - b.discountUang) * b.discountPersen / 100)
				,jumlahPPN = (((b.jumlahBeli * b.hargaBeli) - b.discountUang) - (((b.jumlahBeli * b.hargaBeli) - b.discountUang) * b.discountPersen / 100)) * a.ppn / 100
		    FROM dbo.farmasiPembelian a
				 INNER JOIN dbo.farmasiPembelianDetail b ON a.idPembelianHeader = b.idPembelianHeader
					LEFT JOIN dbo.farmasiOrderDetail ba ON b.idOrderDetail = ba.idOrderDetail
					LEFT JOIN dbo.farmasiMasterPabrik bb ON ba.idPabrik = bb.idPabrik
					OUTER APPLY dbo.getInfo_barangFarmasi(ba.idObatDosis) bc
				 LEFT JOIN dbo.farmasiOrder c ON a.idOrder = c.idOrder
					LEFT JOIN dbo.farmasiMasterDistrobutor ca ON c.idDistriButor = ca.idDistrobutor
		   WHERE CAST(a.tglPembelian AS date) BETWEEN @dateBegin AND @dateEnd #dynamicHere#
	    ORDER BY bb.namaPabrik, a.tglPembelian';

	SET @Query = REPLACE(@Query, '#dynamicHere#', @filter);

	EXECUTE sp_executesql @query, @paramDefinition, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir, @idpb = @idPabrik;
END