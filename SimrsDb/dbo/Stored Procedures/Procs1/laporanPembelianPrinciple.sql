-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPembelianPrinciple]
	-- Add the parameters for the stored procedure here
	@periodeAwal date
	,@periodeAkhir date
	,@idPabrik int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @Query nvarchar(max)
		   ,@Where nvarchar(max) = Case
										When @idPabrik = 0
											 Then ''
										Else ' And d.idPabrik = '+ Convert(nvarchar(50), @idPabrik) +''
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = 'SELECT a.idPembelianHeader, a.tglPembelian, a.noFaktur, da.namaPabrik, c.namaDistroButor, b.discountUang, b.discountPersen, a.ppn
						,dbo.namaBarangFarmasi(b.idObatDosis) As namaObat
						,b.hargaBeli * b.jumlahBeli As total, db.jumlahPPN, db.jumlahDiskon
				    FROM dbo.farmasiPembelian a
						 Inner Join dbo.farmasiPembelianDetail b On a.idPembelianHeader = b.idPembelianHeader
								Inner Join dbo.farmasiMasterObatDosis ba On b.idObatDosis = ba.idObatDosis
								Inner Join dbo.farmasiMasterObat bb On ba.idObat = bb.idObat
								Inner Join dbo.farmasiMasterSatuanObat bc On bb.idSatuanObat = bc.idSatuanObat
								Inner Join dbo.farmasiMasterObatSatuanDosis bd On ba.idSatuanDosis = bd.idSatuanDosis
						 Inner Join dbo.farmasiMasterDistrobutor c On a.idDistrobutor = c.idDistrobutor
						 Inner Join dbo.farmasiOrderDetail d On b.idOrderDetail = d.idOrderDetail
								Inner Join dbo.farmasiMasterPabrik da On d.idPabrik = da.idPabrik
								Inner Join (Select xa.idPembelianDetail
												  ,Sum(
														((xa.hargaBeli * xa.jumlahBeli) 
													  - ((((xa.hargaBeli * xa.jumlahBeli) - xa.discountUang) * xa.discountPersen / 100) + xa.discountUang)) 
													  * xc.ppn / 100
													  ) As jumlahPPN
												  ,Sum((xa.discountUang + (((xa.hargaBeli * xa.jumlahBeli) - xa.discountUang) * xa.discountPersen / 100))) As jumlahDiskon
											  From dbo.farmasiPembelianDetail xa
												   Inner Join dbo.farmasiOrderDetail xb On xa.idOrderDetail = xb.idOrderDetail
												   Inner Join dbo.farmasiPembelian xc On xa.idPembelianHeader = xc.idPembelianHeader
										  Group By xa.idPembelianDetail) db On b.idPembelianDetail = db.idPembelianDetail
				   WHERE Convert(date, a.tglPembelian) Between '''+ Convert(nvarchar(50), @periodeAwal) +''' And '''+ Convert(nvarchar(50), @periodeAkhir) +''''+ @Where +'
			    ORDER BY da.namaPabrik, a.tglPembelian';
	EXEC(@Query);
END