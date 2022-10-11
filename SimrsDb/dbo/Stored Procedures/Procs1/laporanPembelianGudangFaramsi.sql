-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPembelianGudangFaramsi]
	-- Add the parameters for the stored procedure here
	@periodeAwal date
	,@periodeAkhir date
	,@idDistrobutor int
WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @Query nvarchar(max)
		   ,@Where nvarchar(max) = Case
										When @idDistrobutor = 0
											 Then ''
										Else ' And a.idDistrobutor = '+ Convert(nvarchar(50), @idDistrobutor) +''
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = 'SELECT a.idPembelianHeader, a.tglPembelian, a.noFaktur, c.namaDistroButor, b.discountUang, b.discountPersen, a.ppn
						,dbo.namaBarangFarmasi(b.idObatDosis) As namaObat
						,b.hargaBeli * b.jumlahBeli As total
						,(((b.hargaBeli * b.jumlahBeli) - b.discountUang) * b.discountPersen / 100) + b.discountUang As jumlahDiscount
						,((b.hargaBeli * b.jumlahBeli) - ((((b.hargaBeli * b.jumlahBeli) - b.discountUang) * b.discountPersen / 100) + b.discountUang)) * a.ppn / 100 As jumlahPPN
				    FROM dbo.farmasiPembelian a
						 Inner Join dbo.farmasiPembelianDetail b On a.idPembelianHeader = b.idPembelianHeader
								Inner Join dbo.farmasiMasterObatDosis ba On b.idObatDosis = ba.idObatDosis
								Inner Join dbo.farmasiMasterObat bb On ba.idObat = bb.idObat
								Inner Join dbo.farmasiMasterSatuanObat bc On bb.idSatuanObat = bc.idSatuanObat
								Inner Join dbo.farmasiMasterObatSatuanDosis bd On ba.idSatuanDosis = bd.idSatuanDosis
						 Inner Join dbo.farmasiMasterDistrobutor c On a.idDistrobutor = c.idDistrobutor
				   WHERE Convert(date, a.tglPembelian) Between '''+ Convert(nvarchar(50), @periodeAwal) +''' And '''+ Convert(nvarchar(50), @periodeAkhir) +''''+ @Where +'
			    ORDER BY a.tglPembelian, c.namaDistroButor';
	EXEC(@Query);
END